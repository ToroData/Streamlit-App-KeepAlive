# Streamlit App KeepAlive

This is a Bash-based automation script to keep your **Streamlit apps alive** by periodically pinging them through GitHub Actions.

## Features

- **Automatically creates a GitHub Actions workflow** in `.github/workflows/keep-streamlit-alive.yml`
- **Allows adding new Streamlit apps** dynamically through a terminal interface.
- **Ensures your workflow YAML file remains correctly structured**.
- **Keeps Streamlit apps awake** by making periodic HTTP requests.

## Installation & Usage

### 1. Clone the Repository

```bash
git clone https://github.com/YOUR-USERNAME/streamlit-app-keepalive.git
cd streamlit-app-keepalive
```

### 2. Make the Script Executable

```bash
chmod +x keepalive.sh
```

### 3. Run the Script

```bash
./keepalive.sh
```

## How It Works

1. The script ensures `.github/workflows/keep-streamlit-alive.yml` exists and is correctly formatted.
2. It provides an interactive menu to:
   - Add new Streamlit app URLs.
   - Exit the script.
3. The GitHub Actions workflow will periodically send requests to your Streamlit apps to keep them active.

## Automating the Process

The workflow runs at **06:00 UTC every day** by default. You can modify the schedule via:

```yaml
on:
  schedule:
    - cron: '0 6 * * *'  # Adjust this cron expression as needed
```

It has been successfully tested with streamlit apps that do not go to sleep. Please note, however, that this has been tested on a GitHub Pro account, so workflow calls should be adjusted according to your current plan. It is your responsibility to verify your account settings and budgeted spend in GitHub Actions.

## Example of a Generated Workflow

```yaml
name: Keep Streamlit Apps Alive

on:
  schedule:
    - cron: '0 6 * * *'
  workflow_dispatch:

jobs:
  ping-apps:
    runs-on: ubuntu-latest
    steps:
      - name: Send request to MyStreamlitApp
        run: curl -s -o /dev/null -w "%{http_code}\n" https://mystreamlitapp.streamlit.app/
```

## ❓ FAQ

**Q: Why do I need this script?**  
A: Streamlit apps deployed on Streamlit Cloud go into sleep mode when inactive for a long time. This script helps keep them awake.

**Q: Can I change the cron schedule?**  
A: Yes! Just edit the `cron` expression inside `.github/workflows/keep-streamlit-alive.yml`.

---

## Contributing

Feel free to **submit pull requests** to improve the script or suggest new features.

**Pending Task**:

- **A second option is pending to be implemented** that shows a list of current URLs and allows them to be deleted by entering the URL.

---
