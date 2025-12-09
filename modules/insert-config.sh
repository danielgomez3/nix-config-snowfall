# Simple Nix Config Insertion Script

echo "=== Nix Config Insertion Tool ==="
echo ""

# Find all default.nix files
files=($(find . -name "default.nix" -type f | sort))
total=${#files[@]}

echo "Found $total default.nix files"
echo ""

# Ask for confirmation
read -p "Do you want to process all files? (y/n): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Aborted."
  exit 0
fi

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

  # Show the current config block
  echo "Current config block:"
  echo "----------------------------------------"
  grep -A 5 -B 5 "config = mkIf cfg.enable" "$file" | head -15
  echo "----------------------------------------"
  echo ""

  # Ask if user wants to edit this file
  read -p "Do you want to insert config in this file? (y/n/skip): " -r
  echo ""

  if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo "Skipping..."
    continue
  elif [[ $REPLY == "skip" ]]; then
    echo "Skipping this file..."
    continue
  fi

  # Get user input
  echo "Paste your Nix configuration below (end with Ctrl+D on empty line):"
  echo ""

  # Read multi-line input
  input=""
  while IFS= read -r line; do
    input+="$line"$'\n'
  done

  # Check if input is empty
  if [ -z "$input" ]; then
    echo "No input provided. Skipping."
    continue
  fi

  # Create backup
  cp "$file" "${file}.backup.$(date +%s)"

  # Insert the input
  # Use sed to insert after the pattern
  sed -i "/config = mkIf cfg.enable {/a\\
$input" "$file"

  echo "✅ Configuration inserted!"
  echo ""
done

echo "=== Done! ==="
