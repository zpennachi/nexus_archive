-- ====================================================================
-- Map & Manuscript Digital Archive — Supabase PostgreSQL Schema
-- ====================================================================

-- 1. Create Collections Table
CREATE TABLE IF NOT EXISTS public.collections (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT UNIQUE NOT NULL,
    category TEXT NOT NULL,
    item_count INTEGER DEFAULT 0,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 2. Create Artifacts Catalog Table
CREATE TABLE IF NOT EXISTS public.artifacts (
    id TEXT PRIMARY KEY, -- Hash ID e.g. '0cc6c0c9f371bc1e'
    filename TEXT NOT NULL,
    collection TEXT NOT NULL REFERENCES public.collections(name) ON UPDATE CASCADE ON DELETE CASCADE,
    category TEXT NOT NULL,
    title TEXT NOT NULL,
    date_depicted TEXT,
    format TEXT DEFAULT 'jpg',
    file_size BIGINT DEFAULT 0,
    preview_url TEXT,
    thumbnail_url TEXT,
    language TEXT,
    entities TEXT[] DEFAULT '{}',
    overview TEXT,
    script_text TEXT,
    ai_content JSONB DEFAULT '{}'::jsonb,
    fts TSVECTOR,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- 3. Trigger Function for Full-Text Search (FTS) Vector Generation
CREATE OR REPLACE FUNCTION public.handle_artifacts_fts()
RETURNS TRIGGER AS $$
BEGIN
    NEW.fts := 
        setweight(to_tsvector('simple', coalesce(NEW.title, '')), 'A') ||
        setweight(to_tsvector('simple', coalesce(NEW.collection, '')), 'B') ||
        setweight(to_tsvector('simple', coalesce(array_to_string(NEW.entities, ' '), '')), 'B') ||
        setweight(to_tsvector('simple', coalesce(NEW.overview, '')), 'C') ||
        setweight(to_tsvector('simple', coalesce(NEW.script_text, '')), 'C');
    NEW.updated_at := now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 4. Create Trigger to Auto-Update FTS Column on Insert / Update
DROP TRIGGER IF EXISTS trg_artifacts_fts ON public.artifacts;
CREATE TRIGGER trg_artifacts_fts
    BEFORE INSERT OR UPDATE ON public.artifacts
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_artifacts_fts();

-- 5. Create High-Performance GIN & B-Tree Indexes
CREATE INDEX IF NOT EXISTS idx_artifacts_collection ON public.artifacts(collection);
CREATE INDEX IF NOT EXISTS idx_artifacts_category ON public.artifacts(category);
CREATE INDEX IF NOT EXISTS idx_artifacts_language ON public.artifacts(language);
CREATE INDEX IF NOT EXISTS idx_artifacts_created_at ON public.artifacts(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_artifacts_fts ON public.artifacts USING GIN(fts);

-- 6. Enable Row Level Security (RLS)
ALTER TABLE public.collections ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.artifacts ENABLE ROW LEVEL SECURITY;

-- 7. Public Read-Only Access Policies (For Museum Visitors)
DROP POLICY IF EXISTS "Allow public read-only access to collections" ON public.collections;
CREATE POLICY "Allow public read-only access to collections" 
    ON public.collections FOR SELECT 
    USING (true);

DROP POLICY IF EXISTS "Allow public read-only access to artifacts" ON public.artifacts;
CREATE POLICY "Allow public read-only access to artifacts" 
    ON public.artifacts FOR SELECT 
    USING (true);

-- 8. Service Role Full Access (For Automated Batch Sync Scripts)
DROP POLICY IF EXISTS "Allow service role full access to collections" ON public.collections;
CREATE POLICY "Allow service role full access to collections" 
    ON public.collections FOR ALL 
    TO service_role 
    USING (true) 
    WITH CHECK (true);

DROP POLICY IF EXISTS "Allow service role full access to artifacts" ON public.artifacts;
CREATE POLICY "Allow service role full access to artifacts" 
    ON public.artifacts FOR ALL 
    TO service_role 
    USING (true) 
    WITH CHECK (true);
