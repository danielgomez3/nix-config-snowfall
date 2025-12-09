# Function to format a single default.nix file
format_default_nix() {
  local file="$1"

  # Create a temporary file
  local temp_file=$(mktemp)

  # Read the file content
  local content=$(cat "$file")

  # Find the first occurrence of '}:'
  if echo "$content" | grep -q "}:"; then
    # Use sed to handle the replacement more carefully
    # Insert the new content after the first '}:'
    echo "$content" | sed '/}:/{:a;N;$!ba;s/}:/}:\n\nlet\n  cfg = config.profiles.${namespace}.my.xxplatformxx.xxcategoryxx.xxmodulexx;\n  inherit (lib) mkEnableOption mkIf;\n\nin{\n  options.profiles.${namespace}.my.xxplatformxx.xxcategoryxx.zsh = {\n    enable = mkEnableOption "Enable custom '\''xxplatformxx'\'' module, category '\''xxcategoryxx'\'', module '\''xxmodulexx'\'', for namespace '\''${namespace}'\''";\n  };\n  config = mkIf cfg.enble \n/}' >"$temp_file"

    # Then ensure we have the closing at the end
    echo -e "\n;} # End of config block" >>"$temp_file"

    # Move the temp file to the original file
    mv "$temp_file" "$file"
    echo "Formatted: $file"
  else
    echo "Warning: No '}:' found in $file - skipping"
    rm -f "$temp_file"
  fi
}

# Alternative version using awk (more reliable)
format_default_nix_awk() {
  local file="$1"
  local temp_file=$(mktemp)

  awk '
    BEGIN { inserted=0 }
    /}:/ && !inserted {
        print $0
        print ""
        print "let"
        print "  cfg = config.profiles.${namespace}.my.xxplatformxx.xxcategoryxx.xxmodulexx;"
        print "  inherit (lib) mkEnableOption mkIf;"
        print ""
        print "in{"
        print "  options.profiles.${namespace}.my.xxplatformxx.xxcategoryxx.zsh = {"
        print "    enable = mkEnableOption \"Enable custom '\''xxplatformxx'\'' module, category '\''xxcategoryxx'\'', module '\''xxmodulexx'\'', for namespace '\''${namespace}'\''\";"
        print "  };"
        print "  config = mkIf cfg.enable "
        inserted=1
        next
    }
    { print $0 }
    END {
        if (inserted) {
            print ""
            print ";} # End of config block"
        }
    }
    ' "$file" >"$temp_file"

  if grep -q "}:" "$temp_file"; then
    mv "$temp_file" "$file"
    echo "Formatted: $file"
  else
    echo "Warning: No '}:' found in $file - skipping"
    rm -f "$temp_file"
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
echo "Searching for default.nix files in $target_dir..."
find "$target_dir" -name "default.nix" -type f | while read -r file; do
  echo "Processing: $file"
  format_default_nix_awk "$file"
done

echo "Formatting complete!"
