---
categories: ["[[Guides]]"]
status: active
areas: ["[[Self-Management]]"]
tags: [self-management]
created: 2026-03-04
---

# Capture System Setup Guide

Implementation plan for a universal capture system that sends everything to the Obsidian `Inbox/` with minimal friction. Non-markdown files (PDFs, images, etc.) go to `Attachments/` with a wrapper note in `Inbox/`.

---

## Architecture Overview

The capture system uses a hybrid approach: **Drafts** handles all quick text capture across platforms, while **Keyboard Maestro** handles three contextual desktop captures that need app-specific data (browser URLs, email references, Finder files). The three KM macros share a single hotkey scoped by active application.

| Platform | Tool | Hotkey | Capture Type | Target |
|----------|------|--------|-------------|--------|
| iOS | Drafts + iOS Shortcut | — | Share sheet (any app) | Drafts inbox → `Inbox/` |
| iOS/macOS | Drafts app | `Control+Spacebar` (macOS) | Direct text capture | Drafts inbox → `Inbox/` |
| macOS | Keyboard Maestro | `Ctrl+Opt+Cmd+Spacebar` | Browser URL + title | `Inbox/` |
| macOS | Keyboard Maestro | `Ctrl+Opt+Cmd+Spacebar` | Apple Mail reference | `Inbox/` |
| macOS | Keyboard Maestro | `Ctrl+Opt+Cmd+Spacebar` | Finder file capture | `Inbox/` + `Attachments/` |

Drafts captures live in the Drafts inbox until processed. During daily review, Claude reads the Drafts inbox via MCP, smart-routes each item (extract actions, push keepers to Obsidian, archive the rest), then processes the Obsidian `Inbox/`. All captured Obsidian notes use minimal frontmatter (`status: active`, `created: YYYY-MM-DD`). Full `categories`/`areas` properties are added during inbox processing.

---

## Prerequisites

- [ ] Create `Attachments/` folder in vault
- [ ] In Obsidian > Settings > Files & Links > Default location for new attachments, set to "In the folder specified below" and enter `Attachments`
- [ ] Add `Attachments/` to `.gitignore` (large binaries shouldn't bloat the git repo -- iCloud handles sync)
- [ ] Ensure Drafts app is installed on iPhone and Mac
- [ ] Ensure Keyboard Maestro is installed on Mac

---

## Part 1: iOS Share Sheet Capture (Drafts + Shortcuts)

### Step 1: Install the Drafts Action

1. Open Drafts on your iPhone
2. Go to the [Drafts Action Directory](https://actions.getdrafts.com/a/1qn) and install **"Save in Obsidian Vault"**
3. Edit the action to customize the template:
   - Tap the action > Edit > find the File step
   - Set the **Name** field to: `[[safe_title]].md`
   - Set the **Template** field to:

```
---
status: active
tags: []
created: [[date|%Y-%m-%d]]
---

# [[title]]

[[body]]
```

   - Set the **Bookmark** to a new bookmark named `Obsidian Inbox`

### Step 2: Create the Folder Bookmark

1. In Drafts > Settings > Storage > Bookmarks
2. Tap **+** > **Pick Folder**
3. Name it `Obsidian Inbox`
4. Navigate in the Files picker to: **iCloud Drive > Obsidian > {{VAULT_NAME}} > Inbox**
5. Tap Done

> **Note:** Bookmarks are device-specific. You'll need to set this up on each device (iPhone, Mac) independently. The action itself syncs via iCloud, but the folder permission does not.

### Step 3: Create the iOS Shortcut

1. Open **Shortcuts** on iPhone
2. Create a new Shortcut
3. Tap the **(i)** button (or the name at top) and enable **Show in Share Sheet**
4. Set accepted input types: **Text, URLs, Rich Text, Safari web pages**
5. Add the action: **Drafts > Run Action on Text**
   - Set **Action** to your "Save in Obsidian Vault" action
   - Set **Text** to the **Shortcut Input** variable
6. Name the Shortcut something memorable (e.g., "Send to Obsidian")
7. Done

> Drafts will briefly flash open to execute the action. The file goes exactly where your bookmark points.

### Step 4: Test It

- Open Safari, tap Share, select your "Send to Obsidian" shortcut
- Verify a new `.md` file appears in `Inbox/`
- Check that frontmatter and content are correct

---

## Part 2: Browser URL Capture (Keyboard Maestro)

### Overview

Global hotkey > KM grabs page title + URL via built-in tokens > create inbox note with markdown link.

### Prerequisites

In each browser you use, enable **Allow JavaScript from Apple Events**:
- **Safari**: Develop menu > Allow JavaScript from Apple Events (enable the Develop menu in Settings > Advanced if hidden)
- **Chrome/Chromium**: View > Developer > Allow JavaScript from Apple Events

### Step 1: Create the Macro

1. New macro: **Capture Browser URL to Obsidian**
2. Trigger: **Hot Key** (`Ctrl+Opt+Cmd+Spacebar`)
3. **Scope to Safari and Chrome** (or whichever browsers you use)

### Step 2: Set Variables from Browser Tokens

Add two **Set Variable to Text** actions:

- Variable `PageTitle` → text: `%FrontBrowserTitle%`
- Variable `PageURL` → text: `%FrontBrowserURL%`

> **How it works:** `%FrontBrowserTitle%` and `%FrontBrowserURL%` are Keyboard Maestro's built-in web browser tokens. They query the most recently front recognized browser's active tab via AppleScript. Supports Safari, Chrome, Brave, Edge, Vivaldi, and their developmental versions out of the box. Chromium (and other unlisted browsers) must be registered via `AdditionalWebBrowserBundleIDs`. See the Keyboard Maestro documentation for troubleshooting if these tokens return the wrong browser's data.

### Step 3: Add Execute Shell Script Action

Add action: **Execute Shell Script** (`/bin/bash`):

```bash
#!/bin/bash
INBOX="{{VAULT_PATH}}/Inbox"
DATE_TODAY=$(date +"%Y-%m-%d")

# Sanitize title for filename
SAFE_TITLE=$(echo "$KMVAR_PageTitle" | sed 's/[\/:\\*?"<>|]/-/g' | sed 's/  */ /g' | sed 's/^ *//;s/ *$//' | cut -c1-80)

# Handle filename conflicts
FILENAME="${SAFE_TITLE}.md"
if [ -f "${INBOX}/${FILENAME}" ]; then
    FILENAME="${SAFE_TITLE} - $(date +%H%M%S).md"
fi

cat > "${INBOX}/${FILENAME}" << ENDOFNOTE
---
status: active
tags: []
created: ${DATE_TODAY}
---

# ${KMVAR_PageTitle}

[${KMVAR_PageTitle}](${KMVAR_PageURL})
ENDOFNOTE
```

### Step 4: Add Notification + Test

Add optional **Notification** action (Title: "Captured"), then test from Safari and Chrome.

---

## Part 3: Apple Mail Email Reference Capture (Keyboard Maestro)

### Overview

Hotkey (in Mail.app) > grab selected email's subject + message ID > create inbox note with clickable `message://` link.

### Step 1: Create the Macro

1. New macro: **Capture Email to Obsidian**
2. Trigger: **Hot Key** (`Ctrl+Opt+Cmd+Spacebar`)
3. **Scope to Mail.app only** -- set "Available in these applications" to Mail

### Step 2: Add Execute AppleScript Action

```applescript
tell application "Mail"
    set selectedMessages to selection
    if selectedMessages is {} then
        display dialog "No message selected in Mail." buttons {"OK"}
        error number -128
    end if

    set theMessage to item 1 of selectedMessages
    set theSubject to subject of theMessage
    set theSender to sender of theMessage
    set theDate to date received of theMessage
    set theMessageId to message id of theMessage
end tell

-- Percent-encode the message ID for the message:// URL
set encodedId to do shell script "python3 -c 'import sys, urllib.parse; print(urllib.parse.quote(sys.argv[1]))' " & quoted form of theMessageId

-- Build the message:// URL
set messageURL to "message://%3c" & encodedId & "%3e"

-- Format date as YYYY-MM-DD
set y to year of theDate as string
set m to text -2 thru -1 of ("0" & ((month of theDate) as integer))
set d to text -2 thru -1 of ("0" & (day of theDate))
set isoDate to y & "-" & m & "-" & d

-- Pass to KM variables
tell application "Keyboard Maestro Engine"
    setvariable "EmailSubject" to theSubject
    setvariable "EmailSender" to theSender
    setvariable "EmailDate" to isoDate
    setvariable "EmailURL" to messageURL
end tell
```

> **Key detail:** Use `message id` (the RFC Message-ID header), NOT `id` (Mail.app's internal numeric ID). The `message://` URL scheme has been stable since macOS Leopard (2007) and works on both macOS and iOS.

### Step 3: Add Execute Shell Script Action

```bash
#!/bin/bash
INBOX="{{VAULT_PATH}}/Inbox"
DATE_TODAY=$(date +"%Y-%m-%d")

# Sanitize subject for filename
SAFE_SUBJECT=$(echo "$KMVAR_EmailSubject" | sed 's/[\/:\\*?"<>|]/-/g' | sed 's/  */ /g' | sed 's/^ *//;s/ *$//' | cut -c1-80)

FILENAME="${SAFE_SUBJECT}.md"
if [ -f "${INBOX}/${FILENAME}" ]; then
    FILENAME="${SAFE_SUBJECT} - $(date +%H%M%S).md"
fi

cat > "${INBOX}/${FILENAME}" << ENDOFNOTE
---
status: active
tags: [email]
created: ${DATE_TODAY}
---

# ${KMVAR_EmailSubject}

**From:** ${KMVAR_EmailSender}
**Date:** ${KMVAR_EmailDate}
**Link:** [${KMVAR_EmailSubject}](${KMVAR_EmailURL})

## Notes

ENDOFNOTE
```

### Step 4: Test

- Select an email in Mail.app, press your hotkey
- Verify inbox note appears with correct subject and link
- Click the `message://` link from Obsidian -- it should open the email in Mail.app

---

## Part 4: Finder File Capture (Keyboard Maestro)

### Overview

Select file(s) in Finder > hotkey > smart routing based on file type:
- `.md` files: Copy directly to `Inbox/`, prepend frontmatter if missing
- `.txt` files: Rename to `.md`, copy to `Inbox/`, prepend frontmatter
- All other files: Copy to `Attachments/`, create wrapper note in `Inbox/`

### Step 1: Create the Macro

1. New macro: **Send File to Obsidian**
2. Trigger: **Hot Key** (`Ctrl+Opt+Cmd+Spacebar`)
3. **Scope to Finder only**

### Step 2: Add Variable Setup Actions

Add two **Set Variable to Text** actions:
- Variable `VaultPath` = `{{VAULT_PATH}}`
- Variable `EmbeddableExts` = `png jpg jpeg gif bmp svg mp3 webm wav m4a ogg 3gp flac mp4 ogv pdf md`

### Step 3: Add For Each Loop

Add action: **For Each**
- Variable: `FilePath`
- Collection: **The Finder's Selection** (set type to **Path**)

Inside the loop, add: **Execute Shell Script** (`/bin/bash`):

```bash
#!/bin/bash
VAULT="$KMVAR_VaultPath"
ATTACH_DIR="$VAULT/Attachments"
INBOX_DIR="$VAULT/Inbox"
EMBEDDABLE="$KMVAR_EmbeddableExts"
SOURCE="$KMVAR_FilePath"

# Derived values
FILENAME=$(basename "$SOURCE")
BASENAME="${FILENAME%.*}"
EXT=$(echo "${FILENAME##*.}" | tr '[:upper:]' '[:lower:]')
TODAY=$(date '+%Y-%m-%d')
TIMESTAMP=$(date '+%Y%m%d-%H%M%S')

# Ensure directories exist
mkdir -p "$ATTACH_DIR"
mkdir -p "$INBOX_DIR"

# --- Smart routing based on file type ---

if [ "$EXT" = "md" ]; then
    # Markdown files: copy directly to inbox, prepend frontmatter if missing
    DEST="$INBOX_DIR/$FILENAME"
    if [ -f "$DEST" ]; then
        DEST="$INBOX_DIR/${BASENAME}-${TIMESTAMP}.md"
    fi
    cp "$SOURCE" "$DEST"
    # Prepend frontmatter if missing
    if ! head -1 "$DEST" | grep -q '^---'; then
        TMPFILE=$(mktemp)
        cat > "$TMPFILE" << FMEOF
---
status: active
tags: []
created: $TODAY
---

$(cat "$DEST")
FMEOF
        mv "$TMPFILE" "$DEST"
    fi

elif [ "$EXT" = "txt" ]; then
    # Text files: rename to .md, copy to inbox, prepend frontmatter
    NEW_FILENAME="${BASENAME}.md"
    DEST="$INBOX_DIR/$NEW_FILENAME"
    if [ -f "$DEST" ]; then
        DEST="$INBOX_DIR/${BASENAME}-${TIMESTAMP}.md"
    fi
    cp "$SOURCE" "$DEST"
    # Always prepend frontmatter for .txt conversions
    TMPFILE=$(mktemp)
    cat > "$TMPFILE" << FMEOF
---
status: active
tags: []
created: $TODAY
---

$(cat "$DEST")
FMEOF
    mv "$TMPFILE" "$DEST"

else
    # All other files: copy to Attachments, create wrapper note in Inbox

    # Handle filename conflicts in Attachments
    DEST="$ATTACH_DIR/$FILENAME"
    FINAL_NAME="$FILENAME"
    if [ -f "$DEST" ]; then
        FINAL_NAME="${BASENAME}-${TIMESTAMP}.${EXT}"
        DEST="$ATTACH_DIR/$FINAL_NAME"
    fi
    cp "$SOURCE" "$DEST"

    # Determine source-type for frontmatter
    case "$EXT" in
        pdf) SOURCE_TYPE="pdf" ;;
        png|jpg|jpeg|gif|bmp|svg|webp|heic|tiff) SOURCE_TYPE="image" ;;
        mp3|wav|m4a|ogg|flac|aac|3gp) SOURCE_TYPE="audio" ;;
        mp4|mov|avi|mkv|ogv|webm) SOURCE_TYPE="video" ;;
        doc|docx|xls|xlsx|ppt|pptx|csv|rtf|pages|numbers|keynote) SOURCE_TYPE="document" ;;
        *) SOURCE_TYPE="other" ;;
    esac

    # Determine embed vs link
    IS_EMBEDDABLE=false
    for e in $EMBEDDABLE; do
        if [ "$EXT" = "$e" ]; then
            IS_EMBEDDABLE=true
            break
        fi
    done

    if [ "$IS_EMBEDDABLE" = true ]; then
        EMBED_SYNTAX="![[${FINAL_NAME}]]"
    else
        EMBED_SYNTAX="[[${FINAL_NAME}]] *(opens in default app)*"
    fi

    # Create wrapper note in Inbox
    NOTE_FILE="$INBOX_DIR/${BASENAME}.md"
    if [ -f "$NOTE_FILE" ]; then
        NOTE_FILE="$INBOX_DIR/${BASENAME} ${TIMESTAMP}.md"
    fi

    cat > "$NOTE_FILE" << NOTEEOF
---
status: active
source-type: $SOURCE_TYPE
source-file: "[[${FINAL_NAME}]]"
tags: []
created: $TODAY
---

# $BASENAME

$EMBED_SYNTAX

## Summary

NOTEEOF
fi
```

### Step 4: Add Notification After Loop + Test

After the For Each loop ends, add a **Notification** action confirming the capture.

Test with:
- A single `.md` file (should copy directly to inbox with frontmatter)
- A `.txt` file (should convert to `.md` and copy to inbox)
- A PDF (should go to Attachments with wrapper note in inbox)
- An image file (should go to Attachments with wrapper note in inbox)
- A non-embeddable file (e.g., .xlsx) (should go to Attachments with link-style wrapper)

---

## Part 5: Drafts MCP Integration

### Overview

Claude processes the Drafts inbox during daily and weekly reviews via the `@agiletortoise/drafts-mcp-server` MCP server.

### Setup

1. Add `drafts` entry to `.mcp.json` (already done if following this guide)
2. Restart Claude Code session to load the new MCP server
3. First MCP call will trigger macOS Automation permissions -- approve them
4. Ensure the "Save in Obsidian Vault" action is installed in Drafts (from Part 1)

### Processing Flow

During reviews, Claude processes the Drafts inbox before the Obsidian inbox:

1. **List unprocessed drafts** via `mcp__drafts__drafts_get_drafts`
2. **Read each draft** and determine its routing:
   - **Actionable** → Extract action to project note or Action Pool, archive the draft
   - **Worth keeping** → Run "Save in Obsidian Vault" action to push to `Inbox/`, archive the draft
   - **Already captured** → Archive directly
   - **Junk** → Trash (with user confirmation)
3. **Archive processed drafts** so they leave the Drafts inbox

### Requirements

- Drafts v50.0.3+ on macOS
- Node.js 18+
- Drafts must be running for MCP to connect

---

## Hotkey Summary

| Tool | Hotkey | Scope |
|------|--------|-------|
| Drafts (quick text capture) | `Control+Spacebar` | macOS global (Drafts built-in) |
| Browser URL Capture (KM) | `Ctrl+Opt+Cmd+Spacebar` | Safari, Chrome |
| Apple Mail Capture (KM) | `Ctrl+Opt+Cmd+Spacebar` | Mail.app only |
| Finder File Capture (KM) | `Ctrl+Opt+Cmd+Spacebar` | Finder only |

The three KM macros share one hotkey — Keyboard Maestro routes to the correct macro based on which app is frontmost. Drafts uses its own built-in hotkey for quick text capture.

---

## Wrapper Note Pattern

When the Finder file capture encounters a non-markdown file, it creates a **wrapper note** -- a markdown companion that lives in the vault and references the binary file in `Attachments/`.

### Wrapper note template

```markdown
---
status: active
source-type: pdf
source-file: "[[document.pdf]]"
tags: []
created: 2026-03-04
---

# Document Name

![[document.pdf]]

## Summary

```

Key fields:
- **`source-type`**: File category (`pdf`, `image`, `audio`, `video`, `document`, `other`)
- **`source-file`**: Wikilink to the actual file in `Attachments/`
- **`## Summary`**: Placeholder that Claude fills during inbox processing

After processing, the wrapper note moves from `Inbox/` to its permanent location (usually `Notes/` or `References/`) with enriched frontmatter.

---

## How Claude Processes Captured Items

During daily inbox review, Claude processes captured items:

**Text captures** (quick notes, URLs, email references): Triaged normally -- decide what it is, where it belongs, what action to take.

**Wrapper notes** (non-markdown files): Claude reads the attachment directly (PDFs up to 20 pages, images via multimodal vision), writes a summary into the `## Summary` section, extracts any action items or key information, then triages the wrapper note like any other inbox item:
- Reference material: Enrich frontmatter (add `categories`, `areas`), add tags, move to `Notes/` or `References/`
- Contains actions: Extract actions to project/Action Pool, file wrapper as reference or delete
- Not needed: Delete the wrapper note (attachment stays in `Attachments/`)

---

## Setup Checklist

### One-time Setup
- [ ] Create `Attachments/` folder and configure Obsidian attachment settings
- [ ] Add `Attachments/` to `.gitignore`
- [ ] Set up Drafts iCloud bookmark pointing to `Inbox/` (on each device)
- [ ] Install/customize the Drafts "Save in Obsidian Vault" action
- [ ] Create the iOS Shortcut for share sheet capture

### Keyboard Maestro Macros
- [ ] Capture Browser URL to Obsidian (`Ctrl+Opt+Cmd+Spacebar`, scoped to browsers)
- [ ] Capture Email to Obsidian (`Ctrl+Opt+Cmd+Spacebar`, scoped to Mail.app)
- [ ] Send File to Obsidian (`Ctrl+Opt+Cmd+Spacebar`, scoped to Finder)

### Drafts MCP Integration
- [ ] Add `drafts` entry to `.mcp.json`
- [ ] Restart Claude Code session to load the MCP server
- [ ] Approve macOS Automation permissions on first MCP call
- [ ] Verify: `mcp__drafts__drafts_list_workspaces` returns results
- [ ] Verify: create a test draft in Drafts, then list drafts via MCP and confirm it appears

### Verification
- [ ] Test iOS share sheet from Safari
- [ ] Test iOS share sheet from another app (Notes, Messages)
- [ ] Test Drafts desktop capture (`Control+Spacebar`)
- [ ] Test URL capture from Safari
- [ ] Test URL capture from Chrome
- [ ] Test email capture from Mail.app -- verify message:// link works
- [ ] Test file capture: `.md` file (direct copy with frontmatter)
- [ ] Test file capture: `.txt` file (converts to `.md`)
- [ ] Test file capture: PDF (wrapper note + attachment)
- [ ] Test file capture: image (wrapper note + attachment)
- [ ] Test file capture: non-embeddable file (wrapper note with link syntax)
- [ ] Verify all captured notes have correct frontmatter
- [ ] Verify all notes appear in Obsidian search
- [ ] Verify Claude can read and archive Drafts inbox items via MCP

---

## Technical Notes

- **Why Drafts for text capture instead of KM?** Drafts is purpose-built for quick capture with `Control+Spacebar` always available, syncs across all Apple devices, and now has an MCP server so Claude can process the inbox programmatically during reviews. KM is better suited for contextual captures that need app-specific data.
- **Why one shared KM hotkey?** Three macros scoped to different apps (browsers, Mail, Finder) can share `Ctrl+Opt+Cmd+Spacebar` — KM routes to the correct macro based on the frontmost app. One hotkey to remember instead of three.
- **Why shell scripts over Obsidian CLI for KM macros?** The Obsidian CLI requires Obsidian to be running and has escaping issues with arbitrary user input. Shell scripts with heredocs handle multiline content cleanly and work regardless of Obsidian's state. Obsidian's filesystem watcher picks up new files within 1-2 seconds.
- **Why subject-based filenames for URL/email capture?** These notes have meaningful titles already. A sanitized subject as filename makes the inbox scannable during review.
- **Why `.txt` to `.md` conversion?** Plain text files are just markdown without the extension. Converting lets Obsidian index and render them properly. Frontmatter is always prepended since `.txt` files never have it.
- **Smart routing logic:** The Finder capture script checks the file extension first. `.md` and `.txt` are text formats that belong directly in the inbox. Everything else is a binary that needs to live in `Attachments/` with a wrapper note for vault integration.
- **One wrapper per file:** Each non-markdown file gets its own wrapper note, even when capturing multiple files at once. This keeps triage atomic -- each item is processed independently during review.
- **message:// URL scheme:** Undocumented but stable since macOS Leopard (2007). Uses the RFC Message-ID header, not Mail.app's internal ID. Percent-encode via Python3 `urllib.parse.quote`.
- **Browser token prerequisite:** Each browser needs "Allow JavaScript from Apple Events" enabled once. Safari: Develop menu; Chrome/Chromium: View > Developer menu. Additionally, the Keyboard Maestro Engine needs macOS Automation permission for each browser (System Settings > Privacy & Security > Automation), and non-standard browsers like Chromium must be registered via `AdditionalWebBrowserBundleIDs`. See the Keyboard Maestro documentation.
- **Drafts bookmarks are device-specific:** The action syncs across devices, but the folder permission must be granted on each device independently.
- **Drafts MCP server:** `@agiletortoise/drafts-mcp-server` (Node.js, npx). Requires Drafts v50.0.3+ on macOS and Node.js 18+. First run triggers Automation permissions.

---

## Related Notes

- [[Weave - System Design Notes]]
- [[Weave - Chapman Framework]]
- [[Self-Management]]
