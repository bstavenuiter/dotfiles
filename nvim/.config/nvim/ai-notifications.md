# Setup macOS Notifications for Claude Code (Ghostty + tmux)
This document provides the necessary scripts and configuration changes to enable macOS system notifications whenever Claude Code requires user interaction or completes a task.

## 1. Dependencies
Ensure the following are installed via Homebrew:
- `terminal-notifier`: For sending clickable macOS alerts.
- `jq`: For parsing Claude's hook JSON payload.

```bash
brew install terminal-notifier jq
2. Notification Script
Create a helper script that Claude will execute. This script parses the hook event and triggers a notification that, when clicked, focuses Ghostty.

File: ~/.claude/hooks/notify.sh

Bash
#!/bin/bash
# Read JSON from Claude Code via stdin
input=$(cat)

# Extract the message from the JSON payload
message=$(echo "$input" | jq -r '.message // "Claude needs your attention"')

# Trigger macOS notification
# Note: -activate focuses Ghostty on click
terminal-notifier \
  -title "Claude AI" \
  -message "$message" \
  -activate "com.mitchellh.ghostty" \
  -sound "Glass"
Permissions:

Bash
chmod +x ~/.claude/hooks/notify.sh
3. Claude Code Configuration
Add the notification hook to your global Claude settings.

File: ~/.claude/settings.json

JSON
{
  "hooks": {
    "Notification": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/notify.sh"
          }
        ]
      }
    ]
  }
}
4. tmux Passthrough Support
Since Claude runs inside tmux, you must allow escape sequences to pass through to Ghostty.

File: ~/.tmux.conf

Code snippet
# Allow programs to bypass tmux and talk to the terminal emulator
set -g allow-passthrough on
Action: Reload tmux config with tmux source-file ~/.tmux.conf.

5. Ghostty Integration (Optional)
To enable Ghostty's native ability to notify you when any background command finishes:

File: ~/.config/ghostty/config

Plaintext
notify-on-command-finish = unfocused
