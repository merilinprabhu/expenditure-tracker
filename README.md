# Personal Expenditure Tracking System

A premium expenditure tracking system built as a Single Page Application (SPA) using HTML, CSS, and JavaScript. Integrated with Supabase for user authentication and database storage.

## Features

1. **Dashboard Snapshots**: Consolidated net worth, total bank balances, net monthly salaries, investment distributions, cashflow trends, and recent transaction feeds.
2. **Yono Bank Management**: Statement entries tracking deposits/withdrawals, categories, ref IDs, and running balances.
3. **SIP Statements**: Investment logs tracking mutual funds capital allocations, unit balances, and NAV values.
4. **Salary Account Management**: Pay sheet logging and analytics.
5. **Secure Local Settings**: Enter your Supabase credentials securely; they are saved in browser cache (`localStorage`) and never committed to Git.

## How to Run

Since the application is a plain client-side SPA, you can run it using any static server.

### Option 1: Python HTTP Server (Recommended)
If you have Python installed, run this command in your terminal from this directory:
```bash
python -m http.server 8000
```
Then open [http://localhost:8000](http://localhost:8000) in your browser.

### Option 2: Double Click
You can also simply double-click the `index.html` file to open it directly in your web browser.

## Database Setup

1. Log in to your [Supabase Dashboard](https://supabase.com/).
2. Create a new project.
3. Go to the **SQL Editor** from the left panel.
4. Click **New Query**, paste the contents of the `schema.sql` file, and click **Run**.
5. Go to your project's **Settings** -> **API**, and copy the **Project URL** and **anon public** key.
6. Open the local website, click on **Settings** (or the gear icon in the sidebar), and enter your copied credentials to connect!
