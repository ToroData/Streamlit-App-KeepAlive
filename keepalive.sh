#!/bin/bash

YAML_FILE=".github/workflows/keep-streamlit-alive.yml"

default_read() {
    local prompt="$1"
    local default="$2"
    local var
    read -p "$prompt [$default]: " var
    echo "${var:-$default}"
}

initialize_yaml() {
    cat > "$YAML_FILE" <<EOL
name: Keep Streamlit Apps Alive

on:
  schedule:
    - cron: '0 6 * * *'

  workflow_dispatch:

jobs:
  ping-apps:
    runs-on: ubuntu-latest

    steps:
EOL
}

# Ensure YAML file exists and has correct structure
if [ ! -f "$YAML_FILE" ] || [ ! -s "$YAML_FILE" ] || ! grep -q "name: Keep Streamlit Apps Alive" "$YAML_FILE"; then
    echo "YAML file is missing or corrupted. Reinitializing..."
    mkdir -p $(dirname "$YAML_FILE")
    initialize_yaml
fi

CURRENT_NAME=$(grep -E '^name:' "$YAML_FILE" | awk -F': ' '{print $2}')
CURRENT_CRON=$(grep -E 'cron: ' "$YAML_FILE" | awk -F': ' '{print $2}' | tr -d "'")
NEW_NAME=$(default_read "Workflow name" "$CURRENT_NAME")
NEW_CRON=$(default_read "CRON expression for execution" "$CURRENT_CRON")

sed -i "s/^name:.*/name: $NEW_NAME/" "$YAML_FILE"
sed -i "s/cron: .*/cron: '$NEW_CRON'/" "$YAML_FILE"

add_app() {
    clear
    echo "Adding a new application..."
    read -p "Enter the URL of the new Streamlit app: " NEW_URL
    APP_NAME=$(basename "$NEW_URL")
    echo "      - name: Send request to $APP_NAME" >> "$YAML_FILE"
    echo "        run: curl -s -o /dev/null -w \"%{http_code}\\n\" $NEW_URL" >> "$YAML_FILE"
    echo "Application added successfully!"
    sleep 2
}

while true; do
    clear
    echo "========== Streamlit App Manager =========="
    echo "1) Add a new application"
    echo "2) Exit"
    echo "==========================================="
    read -p "Select an option: " OPTION

    case $OPTION in
        1)
            add_app
            ;;
        2)
            clear
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            sleep 2
            ;;
    esac

done
