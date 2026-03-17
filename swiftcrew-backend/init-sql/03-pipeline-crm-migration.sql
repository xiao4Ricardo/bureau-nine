-- SwiftCrew CRM Migration: Field-Service → Pipeline CRM
-- This script transforms the schema from job-based to deal/pipeline-based

-- ============================================================
-- 1. Create new tables
-- ============================================================

-- Companies
CREATE TABLE IF NOT EXISTS companies (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(200) NOT NULL,
    phone VARCHAR(30),
    website VARCHAR(255),
    owner_id UUID REFERENCES users(id),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_companies_owner ON companies(owner_id);

-- Pipelines
CREATE TABLE IF NOT EXISTS pipelines (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    owner_id UUID REFERENCES users(id),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Pipeline Stages
CREATE TABLE IF NOT EXISTS pipeline_stages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    pipeline_id UUID NOT NULL REFERENCES pipelines(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    position INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_pipeline_stages_pipeline ON pipeline_stages(pipeline_id);

-- ============================================================
-- 2. Migrate customers → contacts
-- ============================================================
ALTER TABLE customers RENAME TO contacts;
ALTER TABLE contacts ADD COLUMN IF NOT EXISTS company_id UUID REFERENCES companies(id);
ALTER TABLE contacts ADD COLUMN IF NOT EXISTS owner_id UUID REFERENCES users(id);
CREATE INDEX IF NOT EXISTS idx_contacts_company ON contacts(company_id);
CREATE INDEX IF NOT EXISTS idx_contacts_owner ON contacts(owner_id);

-- ============================================================
-- 3. Create deals table (replaces jobs)
-- ============================================================
CREATE TABLE IF NOT EXISTS deals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(200) NOT NULL,
    amount NUMERIC(14,2) DEFAULT 0,
    pipeline_id UUID NOT NULL REFERENCES pipelines(id),
    stage_id UUID NOT NULL REFERENCES pipeline_stages(id),
    contact_id UUID REFERENCES contacts(id),
    company_id UUID REFERENCES companies(id),
    owner_id UUID REFERENCES users(id),
    expected_close_date DATE,
    description TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_deals_pipeline ON deals(pipeline_id);
CREATE INDEX IF NOT EXISTS idx_deals_stage ON deals(stage_id);
CREATE INDEX IF NOT EXISTS idx_deals_contact ON deals(contact_id);
CREATE INDEX IF NOT EXISTS idx_deals_company ON deals(company_id);
CREATE INDEX IF NOT EXISTS idx_deals_owner ON deals(owner_id);

-- Products
CREATE TABLE IF NOT EXISTS products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(200) NOT NULL,
    code VARCHAR(50),
    category VARCHAR(100),
    unit_price NUMERIC(12,2) DEFAULT 0,
    active BOOLEAN NOT NULL DEFAULT true,
    description TEXT,
    tags TEXT,
    owner_id UUID REFERENCES users(id),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Activities
CREATE TABLE IF NOT EXISTS activities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    type VARCHAR(20) NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    due_date DATE,
    due_time TIME,
    completed BOOLEAN NOT NULL DEFAULT false,
    contact_id UUID REFERENCES contacts(id),
    deal_id UUID REFERENCES deals(id),
    owner_id UUID REFERENCES users(id),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_activities_type ON activities(type);
CREATE INDEX IF NOT EXISTS idx_activities_due_date ON activities(due_date);
CREATE INDEX IF NOT EXISTS idx_activities_deal ON activities(deal_id);
CREATE INDEX IF NOT EXISTS idx_activities_owner ON activities(owner_id);

-- ============================================================
-- 4. Drop old jobs table
-- ============================================================
DROP TABLE IF EXISTS jobs;

-- ============================================================
-- 5. Seed data
-- ============================================================

-- Sample company
INSERT INTO companies (id, name, phone, website, owner_id) VALUES
    ('c0000000-0000-0000-0000-000000000001', 'Zykler Corp', '609-281-3662', 'https://zykler.com', 'a0000000-0000-0000-0000-000000000001'),
    ('c0000000-0000-0000-0000-000000000002', 'Riverside Office Park', '(555) 345-6789', 'https://riverside.com', 'a0000000-0000-0000-0000-000000000001'),
    ('c0000000-0000-0000-0000-000000000003', 'Summit Dental Clinic', '(555) 678-9012', 'https://summitdental.com', 'a0000000-0000-0000-0000-000000000001')
ON CONFLICT DO NOTHING;

-- Update existing contacts with owner and company
UPDATE contacts SET owner_id = 'a0000000-0000-0000-0000-000000000001' WHERE owner_id IS NULL;
UPDATE contacts SET company_id = 'c0000000-0000-0000-0000-000000000001' WHERE id = 'b0000000-0000-0000-0000-000000000001';
UPDATE contacts SET company_id = 'c0000000-0000-0000-0000-000000000002' WHERE id = 'b0000000-0000-0000-0000-000000000002';
UPDATE contacts SET company_id = 'c0000000-0000-0000-0000-000000000003' WHERE id = 'b0000000-0000-0000-0000-000000000005';

-- Default Sales Pipeline
INSERT INTO pipelines (id, name, owner_id) VALUES
    ('d0000000-0000-0000-0000-000000000001', 'Sales Pipeline', 'a0000000-0000-0000-0000-000000000001')
ON CONFLICT DO NOTHING;

-- Pipeline stages
INSERT INTO pipeline_stages (id, pipeline_id, name, position) VALUES
    ('e0000000-0000-0000-0000-000000000001', 'd0000000-0000-0000-0000-000000000001', 'Qualification', 0),
    ('e0000000-0000-0000-0000-000000000002', 'd0000000-0000-0000-0000-000000000001', 'Needs Analysis', 1),
    ('e0000000-0000-0000-0000-000000000003', 'd0000000-0000-0000-0000-000000000001', 'Proposal/Price Quote', 2),
    ('e0000000-0000-0000-0000-000000000004', 'd0000000-0000-0000-0000-000000000001', 'Negotiation/Review', 3),
    ('e0000000-0000-0000-0000-000000000005', 'd0000000-0000-0000-0000-000000000001', 'Closed Won', 4),
    ('e0000000-0000-0000-0000-000000000006', 'd0000000-0000-0000-0000-000000000001', 'Closed Lost', 5)
ON CONFLICT DO NOTHING;

-- Sample deals
INSERT INTO deals (id, name, amount, pipeline_id, stage_id, contact_id, company_id, owner_id, expected_close_date, description) VALUES
    ('f0000000-0000-0000-0000-000000000001', 'Zykler Yearly Subscription', 5671.00, 'd0000000-0000-0000-0000-000000000001', 'e0000000-0000-0000-0000-000000000001', 'b0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000001', '2026-03-16', 'Annual subscription renewal for Zykler Corp'),
    ('f0000000-0000-0000-0000-000000000002', 'Riverside Office Renovation', 12500.00, 'd0000000-0000-0000-0000-000000000001', 'e0000000-0000-0000-0000-000000000002', 'b0000000-0000-0000-0000-000000000002', 'c0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000001', '2026-04-01', 'Office renovation project proposal'),
    ('f0000000-0000-0000-0000-000000000003', 'Summit Dental Equipment', 8900.00, 'd0000000-0000-0000-0000-000000000001', 'e0000000-0000-0000-0000-000000000003', 'b0000000-0000-0000-0000-000000000005', 'c0000000-0000-0000-0000-000000000003', 'a0000000-0000-0000-0000-000000000001', '2026-03-25', 'New dental equipment purchase')
ON CONFLICT DO NOTHING;

-- Sample product
INSERT INTO products (id, name, code, category, unit_price, active, description, tags, owner_id) VALUES
    ('00000000-0000-0000-0000-p00000000001', 'asdas', 'asdas', 'Hardware', 122.00, true, 'wae', 'hardware,equipment', 'a0000000-0000-0000-0000-000000000001')
ON CONFLICT DO NOTHING;

-- Sample activities
INSERT INTO activities (id, type, title, description, due_date, due_time, completed, owner_id) VALUES
    (uuid_generate_v4(), 'TASK', 'Prepare a presentation', 'Prepare slides for client meeting', '2026-03-17', '10:00', false, 'a0000000-0000-0000-0000-000000000001'),
    (uuid_generate_v4(), 'EVENT', 'Client Meeting', 'Meet with Zykler Corp team', '2026-03-10', '14:00', true, 'a0000000-0000-0000-0000-000000000001'),
    (uuid_generate_v4(), 'CALL', 'Follow up call', 'Follow up on Riverside proposal', '2026-03-12', '11:00', false, 'a0000000-0000-0000-0000-000000000001')
ON CONFLICT DO NOTHING;
