# Color codes for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to display file header
show_file_info() {
  local file="$1"
  echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
  echo -e "${GREEN}📁 File: ${CYAN}$(realpath --relative-to=. "$file")${NC}"
  echo ""

  # Show the current config block
  echo -e "${YELLOW}Current config block in file:${NC}"
  echo -e "${PURPLE}────────────────────────────────────────────────────────────────${NC}"

  # Extract and show lines around the config block
  local line_num=$(grep -n "config = mkIf cfg.enable" "$file" | head -1 | cut -d: -f1)
  if [ -n "$line_num" ]; then
    # Show 5 lines before and 5 lines after
    local start=$((line_num > 5 ? line_num - 5 : 1))
    sed -n "${start},$((line_num + 10))p" "$file" | head -20
  else
    echo -e "${RED}No 'config = mkIf cfg.enable' found in this file!${NC}"
  fi

  echo -e "${PURPLE}────────────────────────────────────────────────────────────────${NC}"
  echo ""
}

# Function to get user input with multi-line support
get_user_input() {
  local file="$1"
  echo -e "${YELLOW}📝 Enter the Nix configuration to insert after 'config = mkIf cfg.enable {'${NC}"
  echo -e "${YELLOW}(Press Ctrl+D twice when finished, or type 'SKIP' on a new line to skip this file)${NC}"
  echo ""

  # Use a temporary file to collect multi-line input
  local input_file=$(mktemp)

  # Read multi-line input until EOF (Ctrl+D) or SKIP
  while IFS= read -r line; do
    if [ "$line" = "SKIP" ]; then
      echo "skip" >"$input_file"
      break
    fi
    echo "$line" >>"$input_file"
  done

  # Read the collected input
  local input=$(cat "$input_file")
  rm "$input_file"

  echo "$input"
}

# Function to process a single file
process_file() {
  local file="$1"

  # Show file info
  show_file_info "$file"

  # Check if the file contains the target pattern
  if ! grep -q "config = mkIf cfg.enable" "$file"; then
    echo -e "${RED}✗ This file doesn't contain 'config = mkIf cfg.enable'${NC}"
    echo -e "${YELLOW}Moving to next file...${NC}"
    echo ""
    return 1
  fi

  # Get user input
  local user_input=$(get_user_input "$file")

  # Check if user wants to skip
  if [ "$user_input" = "skip" ]; then
    echo -e "${YELLOW}⏭️  Skipping this file${NC}"
    echo ""
    return 0
  fi

  # Check if input is empty
  if [ -z "$user_input" ]; then
    echo -e "${YELLOW}⚠️  No input provided, skipping${NC}"
    echo ""
    return 0
  fi

  # Create a backup
  local backup_file="${file}.backup.$(date +%Y%m%d_%H%M%S)"
  cp "$file" "$backup_file"

  # Process the file using awk
  local temp_file=$(mktemp)

  awk -v user_input="$user_input" '
    BEGIN { inserted = 0 }
    
    # Find the config line
    /config = mkIf cfg.enable/ && !inserted {
        # Print the line itself
        print $0
        # Insert the user input with proper indentation
        print ""
        print user_input
        inserted = 1
        next
    }
    
    # Print all other lines
    { print $0 }
    ' "$file" >"$temp_file"

  # Replace the original file
  mv "$temp_file" "$file"

  echo -e "${GREEN}✅ Successfully inserted configuration!${NC}"
  echo -e "${YELLOW}📋 Backup saved as: $backup_file${NC}"
  echo ""

  # Show the updated config block
  echo -e "${YELLOW}Updated config block:${NC}"
  echo -e "${PURPLE}────────────────────────────────────────────────────────────────${NC}"
  local line_num=$(grep -n "config = mkIf cfg.enable" "$file" | head -1 | cut -d: -f1)
  if [ -n "$line_num" ]; then
    sed -n "${line_num},$((line_num + 15))p" "$file" | head -20
  fi
  echo -e "${PURPLE}────────────────────────────────────────────────────────────────${NC}"
  echo ""
}

# Function to show summary
show_summary() {
  local total=$1
  local processed=$2
  local skipped=$3
  local failed=$4

  echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
  echo -e "${GREEN}📊 PROCESSING SUMMARY${NC}"
  echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
  echo -e "${CYAN}Total files found:    ${YELLOW}$total${NC}"
  echo -e "${GREEN}Successfully processed: ${YELLOW}$processed${NC}"
  echo -e "${YELLOW}Skipped:              ${YELLOW}$skipped${NC}"
  echo -e "${RED}Failed:                ${YELLOW}$failed${NC}"
  echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
}

# Main script
main() {
  echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
  echo -e "${GREEN}🎯 Nix Config Insertion Tool${NC}"
  echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
  echo ""

  # Check if target directory was provided
  if [ $# -eq 0 ]; then
    echo -e "${YELLOW}Usage: $0 <target-directory>${NC}"
    echo -e "${YELLOW}Example: $0 ./modules${NC}"
    exit 1
  fi

  local target_dir="$1"

  # Check if directory exists
  if [ ! -d "$target_dir" ]; then
    echo -e "${RED}Error: Directory '$target_dir' does not exist${NC}"
    exit 1
  fi

  # Find all default.nix files
  echo -e "${CYAN}🔍 Searching for default.nix files in: $target_dir${NC}"
  echo ""

  local files=($(find "$target_dir" -name "default.nix" -type f | sort))
  local total=${#files[@]}

  if [ $total -eq 0 ]; then
    echo -e "${YELLOW}No default.nix files found in $target_dir${NC}"
    exit 0
  fi

  echo -e "${GREEN}Found $total default.nix files${NC}"
  echo ""

  # Ask for confirmation
  echo -e "${YELLOW}Do you want to process all $total files? (yes/no)${NC}"
  read -p "> " confirm

  if [[ ! "$confirm" =~ ^[Yy](es)?$ ]]; then
    echo -e "${YELLOW}Aborted by user${NC}"
    exit 0
  fi

  # Counters
  local processed=0
  local skipped=0
  local failed=0

  # Process each file
  for file in "${files[@]}"; do
    ((processed++))

    echo -e "${CYAN}Processing file $processed of $total${NC}"

    # Process the file
    if process_file "$file"; then
      # Check if it was actually skipped
      if grep -q "config = mkIf cfg.enable" "$file"; then
        ((processed++))
      else
        ((skipped++))
        ((processed--))
      fi
    else
      ((failed++))
      ((processed--))
    fi

    # Ask if user wants to continue after each file
    if [ $processed -lt $total ]; then
      echo -e "${YELLOW}Press Enter to continue to next file, or type 'q' to quit${NC}"
      read -p "> " response
      if [[ "$response" == "q" ]]; then
        echo -e "${YELLOW}Stopping early at user request${NC}"
        break
      fi
    fi
  done

  # Show summary
  show_summary $total $processed $skipped $failed

  # List backup files
  echo ""
  echo -e "${CYAN}📋 Backup files created:${NC}"
  find "$target_dir" -name "*.backup.*" -type f 2>/dev/null | while read backup; do
    echo -e "  ${YELLOW}$backup${NC}"
  done

  echo ""
  echo -e "${GREEN}✨ Processing complete!${NC}"
}

# Run the main function with all arguments
main "$@"
