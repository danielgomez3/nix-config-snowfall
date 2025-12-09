# Function to format a single default.nix file
format_default_nix() {
  local file="$1"

  # Create a temporary file
  local temp_file=$(mktemp)

  # Read the file content
  local content=$(cat "$file")

  # Find the first occurrence of '}:'
  if [[ "$content" =~ }: ]]; then
    # Split at the first '}:'
    local before="${content%%}:*}:"
    local after="${content#*}:}"

    # Construct the new content
    echo "$before" >"$temp_file"
    echo "" >>"$temp_file"
    echo "let" >>"$temp_file"
    echo "  cfg = config.profiles.\${namespace}.my.xxplatformxx.xxcategoryxx.xxmodulexx;" >>"$temp_file"
    echo "  inherit (lib) mkEnableOption mkIf;" >>"$temp_file"
    echo "" >>"$temp_file"
    echo "in{" >>"$temp_file"
    echo "  options.profiles.\${namespace}.my.xxplatformxx.xxcategoryxx.zsh = {" >>"$temp_file"
    echo "    enable = mkEnableOption \"Enable custom 'xxplatformxx' module, category 'xxcategoryxx', module 'xxmodulexx', for namespace '\${namespace}'\";" >>"$temp_file"
    echo "  };" >>"$temp_file"
    echo "  config = mkIf cfg.enable " >>"$temp_file"
    echo "$after" >>"$temp_file"
    echo "" >>"$temp_file"
    echo ";} # End of config block" >>"$temp_file"

    # Move the temp file to the original file
    mv "$temp_file" "$file"
    echo "Formatted: $file"
  else
    echo "Warning: No '}:' found in $file - skipping"
    rm "$temp_file"
  fi
}

# Main script
if [ $# -eq 0 ]; then
  echo "Usage: $0 <target-directory>"
  echo "Example: $0 /path/to/nix/files"
  exit 1
fi

target_dir="$1"

# Check if directory exists
if [ ! -d "$target_dir" ]; then
  echo "Error: Directory '$target_dir' does not exist"
  exit 1
fi

# Find all default.nix files in the target directory and subdirectories
find "$target_dir" -name "default.nix" -type f | while read -r file; do
  format_default_nix "$file"
done

echo "Formatting complete!"
