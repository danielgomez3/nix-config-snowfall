TARGET_DIR="$1"

if [[ -z "$TARGET_DIR" ]]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

find "$TARGET_DIR" -type f | while read -r file; do
  first_line=$(head -n 1 "$file" | sed 's/^[[:space:]]*//')

  if [[ "$first_line" == "{"* ]]; then
    echo "$file"
  fi
done
