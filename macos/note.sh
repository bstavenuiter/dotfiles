#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title note
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖
# @raycast.argument1 { "type": "text", "placeholder": "Placeholder" }

# Documentation:
# @raycast.description Create a note

sed -i -E "s/## $(date '+%Y-%m-%d')/## $(date '+%Y-%m-%d')\n- [ ] $1/" ## enter todo path here
