# Background Agent Environment Setup

This guide walks you through setting up a Cursor Background Agent environment for this Rails app. Follow the steps in order; it should take only a few minutes.

## Files in this directory
- `snapshot.sh`: Installs base OS packages (apt) needed to build Ruby/Node/gems. One-time image step.
- `install.sh`: Installs Ruby/Node and project deps from version files, Creates and Seeds DB; avoids re-snapshotting on version changes; cached by Cursor.
- `start.sh`: Starts Postgres/Redis services, checks for app dependency changes, ensures the app is ready to run.
- `environment.json`: Background Agent config (auto-updated when you save a snapshot)

## Step-by-step
1) Copy the helper scripts into your repo's `.cursor/` directory
   - Ensure these files exist in `.cursor/`:
     - `snapshot.sh`
     - `install.sh`
     - `start.sh`
   - Make them executable if needed:
     ```bash
     chmod +x .cursor/snapshot.sh .cursor/install.sh .cursor/start.sh
     ```

2) Open Cursor Settings
   - Go to: Cursor → Cursor Settings → Background Agents

3) Expand the "Base Environment" section

4) Start the interactive Snapshot Creator
   - Click the button to launch the remote snapshot environment
   - Wait for the remote server terminal to become ready

5) In the remote server terminal, run the snapshot script
   - This installs apt packages and required OS libraries:
     ```bash
     bash snapshot.sh
     ```

6) Save the snapshot
   - Click "Save snapshot"
   - Confirm `environment.json` shows a new `snapshot` value

7) Add the install and start commands to `environment.json`
   - Example configuration (the `snapshot` value will be set by step 6):
     ```json
     {
       "snapshot": "snapshot-YYYYMMDD-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
       "install": "bash .cursor/install.sh",
       "start": "bash .cursor/start.sh",
       "terminals": [
         { "name": "Tests", "command": "bin/rails test" }
       ]
     }
     ```

8) Add any additional terminals you find useful
   - Examples:
     ```json
     {
       "name": "Server",
       "command": "bin/rails s"
     }
     ```

9) Add required secrets in Background Agent Settings → Secrets
   - Add:
     - `RAILS_MASTER_KEY=xxxxxx`
     - `RAILS_ENV=test`
   - If you use private gems, also add:
     - `BUNDLE_GITHUB__COM=ghp_…` (GitHub token for Bundler)

10) Commit and push the changes
    ```bash
    git add .cursor/
    git commit -m "docs(cursor): add Background Agent setup files and config"
    git push
    ```

11) Start a new Background Agent chat
    - Ensure the correct branch (with the updated `.cursor` files) is selected
    - Ask it to perform a task to verify, e.g.:
      "Run the test suite using `bin/rails test`"

## Tips
- The `snapshot` entry in `environment.json` is auto-populated when you click "Save snapshot"; you only need to add `install`, `start`, and any `terminals`.
- Use the provided `install.sh`/`start.sh` scripts unchanged unless you know you need to customize environment steps.
- If Postgres/Redis are needed, the scripts will start them automatically.
