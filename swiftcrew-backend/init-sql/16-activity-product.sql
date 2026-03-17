ALTER TABLE activities ADD COLUMN IF NOT EXISTS product_id UUID REFERENCES products(id);
CREATE INDEX IF NOT EXISTS idx_activities_product_id ON activities(product_id);
