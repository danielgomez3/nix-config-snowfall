echo "=== Nix Config Insertion Tool ==="
echo ""

# Progress file
PROGRESS=".progress.txt"
LOG=".nix-insert.log"

# Clear any leftover input
while read -t 0; do read -r; done

# Find all default.nix files
echo "🔍 Finding files..."
files=($(find . -name "default.nix" -type f | sort))
total=${#files[@]}

echo "Found $total files"
echo ""

# Ask for confirmation
read -p "Do you want to process all files? (y/n): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Aborted."
  exit 0
fi

# Clear input buffer again
while read -t 0; do read -r; done

# Process each file
count=0
for file in "${files[@]}"; do
  ((count++))

  echo ""
  echo "=== File $count of $total: $file ==="
  echo ""

  # Check if file has the pattern
  if ! grep -q "config = mkIf cfg.enable" "$file"; then
    echo "⚠️  No 'config = mkIf cfg.enable' found. Skipping."
    continue
  fi

  # Show the current config block (more context)
  echo "Current config block:"
  echo "----------------------------------------"
  # Show more context - 10 lines before, 10 lines after
  grep -A 30 -B 30 "config = mkIf cfg.enable" "$file"
  echo "----------------------------------------"
  echo ""

  # Ask if user wants to edit this file
  echo "Do you want to insert config in this file? (y=yes, n=no, s=skip, q=quit)"
  # Clear input before reading
  while read -t 0; do read -r; done
  read -r answer

  case $answer in
  [Nn])
    echo "Skipping..."
    continue
    ;;
  [Ss])
    echo "Skipping this file..."
    continue
    ;;
  [Qq])
    echo "Quitting..."
    break
    ;;
  [Yy])
    # Continue with editing
    ;;
  *)
    echo "Invalid input. Skipping..."
    continue
    ;;
  esac

  # Get user input using a temporary file approach
  echo ""
  echo "Paste your Nix configuration below."
  echo "When done, press Ctrl+D on an empty line."
  echo ""

  # Create a temporary file for input
  input_file=$(mktemp)

  # Use cat to read input (most reliable)
  echo ">>> START PASTING (press Ctrl+D twice when done):"
  cat >"$input_file"

  # Read the input from the file
  input=$(cat "$input_file")
  rm "$input_file"

  # Check if input is empty
  if [ -z "$input" ]; then
    echo "No input provided. Skipping."
    continue
  fi

  # Create backup
  backup="${file}.backup.$(date +%s)"
  cp "$file" "$backup"

  # Use Python for safe insertion (handles all characters)
  python3 -c "
import sys

with open('$file', 'r') as f:
    content = f.read()

# Find the config line
lines = content.split('\n')
output_lines = []
inserted = False

for line in lines:
    output_lines.append(line)
    if not inserted and 'config = mkIf cfg.enable' in line:
        # Add the user input
        output_lines.append('')
        # Split input and add each line
        for input_line in '''$input'''.split('\n'):
            if input_line.strip() != '':
                output_lines.append(input_line)
        inserted = True

# Write back
with open('$file', 'w') as f:
    f.write('\n'.join(output_lines))
"

  if [ $? -eq 0 ]; then
    echo "✅ Updated!"
    echo "$file" >>"$PROGRESS"
  else
    echo "❌ Failed!"
  fi

  # Clear input buffer before next iteration
  while read -t 0; do read -r; done

  echo ""
done

echo ""
echo "=== Done! Processed $count files ==="
echo "Progress saved in $PROGRESS"
