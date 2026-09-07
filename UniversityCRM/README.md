# Salesforce DX Project: Next Steps

## Docker_Supabase setup

### Local Docker + Supabase Workflow

Quick reference for running this project's local Postgres/Supabase stack, troubleshooting Docker connection issues, and running one-off SQL files.

#### Starting the stack

1. **Start Docker Desktop.** Open it from the Start menu and wait until it's fully loaded (the RAM/CPU/Disk stats at the bottom of the Docker Desktop window populate once the engine is running).
2. **Verify Docker is reachable:**
   ```powershell
   docker ps
   ```
   This should return a table of running containers with no errors. If you see:
   ```
   failed to connect to the docker API at npipe:////./pipe/dockerDesktopLinuxEngine
   ```
   Docker Desktop isn't running yet — go back to step 1 and make sure the engine has finished starting before retrying.
3. **Start the project (if not already running):**
   ```powershell
   cd path\to\this-project
   supabase start
   ```
   This spins up Postgres, Studio, auth, storage, realtime, and related containers. First run downloads the images and can take a few minutes.
4. **Open Supabase Studio** at the URL printed by `supabase start` (typically `http://127.0.0.1:54323`) to browse tables or run SQL.

#### Running a one-off SQL file (not part of tracked migrations)

If you have a `.sql` file that creates tables/seeds data but isn't meant to be tracked in `supabase/migrations/` (so it won't rerun on `supabase db reset`):

**Option A — psql (if installed):**
```powershell
psql "postgresql://postgres:postgres@127.0.0.1:54322/postgres" -f "path\to\your\file.sql"
```

**Option B — Supabase Studio SQL Editor (no install needed):**
1. Open Studio (`http://127.0.0.1:54323`) → **SQL Editor** → new query.
2. Copy the full contents of your `.sql` file and paste them in.
3. Click **Run**.
4. If Studio flags the query as *destructive* or *missing Row Level Security (RLS)*:
   - **Destructive** just means it creates/drops tables — expected for a setup script.
   - **Missing RLS** matters only if the tables will be exposed through Supabase's public REST/API layer to `anon`/`authenticated` keys. For internal-only tables (e.g. a data warehouse schema populated by a backend integration), it's safe to choose **Run without RLS**.

> Note: SQL run this way is **not tracked** — it won't survive a `supabase db reset`. To persist it across resets, add it as a numbered file in `supabase/migrations/` instead.

#### Stopping the stack

```powershell
supabase stop
```
Shuts down that project's containers to free up RAM/CPU. Docker Desktop itself stays installed and running.