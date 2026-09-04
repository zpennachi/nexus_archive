# Map & Manuscript Digital Archive

A high-performance digital archive and curatorial explorer for historical cartography, Ottoman manuscripts, and archival fieldwork records (4,903 items across 48 research collections).

---

## 🏛 Architecture

* **Frontend**: Vanilla JavaScript with Tailwind CSS & Google Fonts (*Cormorant Garamond*, *Poppins*, *Amiri*).
* **Database & Search**: **Supabase (PostgreSQL)** with Full-Text Search (FTS) & Vector Indexing.
* **Hosting & Edge CDN**: **Vercel** with edge caching.
* **Vision & Palaeography Pipeline**: Gemini 3.5 Flash Vision AI with automatic checkpointing and language normalization.

---

## 🚀 Deployment Guide

### 1. Supabase Database Setup (2 Minutes)

1. Create a free project at [supabase.com](https://supabase.com).
2. In the Supabase Dashboard, open the **SQL Editor** on the left menu.
3. Open [`supabase_schema.sql`](./supabase_schema.sql), copy its contents, paste into the SQL editor, and click **Run**.
   * *This creates the `collections` and `artifacts` tables with full-text search indexes and Row Level Security (RLS).*
4. Run the automated data sync script locally to populate the database:
   ```bash
   python ../image_processor/sync_to_supabase.py
   ```
   *(Enter your Supabase Project URL and Service Role Key when prompted).*

---

### 2. Push to GitHub

Initialize the Git repository and push to your GitHub account:

```bash
cd Maps_Web
git init
git add .
git commit -m "Initial commit: Map & Manuscript Digital Archive"
git branch -M main
git remote add origin https://github.com/<YOUR_USERNAME>/<YOUR_REPO_NAME>.git
git push -u origin main
```

---

### 3. Deploy to Vercel (1 Click)

1. Go to [vercel.com](https://vercel.com) and click **"Add New Project"**.
2. Select your GitHub repository (`map-manuscript-digital-archive`).
3. Leave build settings as default (Framework Preset: **Other** / Root Directory: `./`).
4. Click **Deploy**.
5. Your archive will be live on a global CDN URL (e.g. `https://your-archive.vercel.app`)!

---

## ⚙ Continuous Extraction Pipeline

To process additional archive files or run scheduled batches:
* Double-click `run_ai_enrichment.bat` or run:
  ```bash
  python ../image_processor/gemini_vision_enricher.py 1500
  ```
