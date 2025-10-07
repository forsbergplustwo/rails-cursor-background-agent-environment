# Cursor - Background Agents Environment - for Ruby on Rails

This guide walks you through setting up a Cursor Background Agent environment for Ruby on Rails apps. Follow the steps in order.

Note: This is a working prototype setup, YMMV (your milage may vary)!

## Files in this directory
- `snapshot.sh`: Installs base OS packages (apt) needed to build Ruby/Node/gems. One-time image step.
- `install.sh`: Installs Ruby/Node and project deps from project version files; avoids re-snapshotting on version changes; cached by Cursor. Creates and Seeds database.
- `start.sh`: Starts Postgres/Redis, checks for dependency changes, ensures the app is ready to run.
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
6) Install any Extensions to the editor, that are not automatically enabled on the remote server instance.

7) Save the snapshot
   - Click "Save snapshot", and contineu the interactive Snapshot Creator steps.
   - When asked for Install command, add: `bash .cursor/install.sh`
   - When asked for Start command, add: `bash .cursor/start.sh`
   - When asked for Terminal command, add any needed, such as `Tests` => `bin/rails test`
   - When asked to verify the setup (a new VM starts), click "Everything Works" even though it doesn't (yet!). *This is because Ruby, Node etc. aren't installed yet, they are added by `install.sh` later so we get correct versions for our project. Some extensions will crash, like Ruby-SLP, again for the same reason.. ignore it and just click "Everything Works" (YOLO!)*
   - Once the interactive session is finished, confirm `environment.json` shows a new `snapshot` value

8) Add the install and start commands to `environment.json` if you did not do it earlier.
   - Example configuration (the `snapshot` value will be set by step 7):
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

9)  Add any additional terminals you find useful
   - Examples:
     ```json
     {
       "name": "Server",
       "command": "bin/rails s"
     }
     ```

10) Add required secrets in Background Agent Settings → Secrets
   - Add:
     - `RAILS_MASTER_KEY=xxxxxx`
     - `RAILS_ENV=test` (default env setup is for test, because it's simpler)
   - If you use private gems, also add:
     - `BUNDLE_GITHUB__COM=ghp_…` (GitHub token for Bundler)

11) Commit and push the changes
    ```bash
    git add .cursor/
    git commit -m "docs(cursor): add Background Agent setup files and config"
    git push
    ```

12) Start a new Background Agent chat
    - Ensure the correct branch (with the updated `.cursor` files) is selected
    - Ask it to perform a task to verify, e.g.:
      "Run the test suite using `bin/rails test`"
    - Note: It's easier to watch the VM boot sequence (and any errors) in the browser Cursor Agents (https://cursor.com/agents) UI, not in Cursor IDE.
