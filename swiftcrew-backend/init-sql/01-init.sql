-- SwiftCrew CRM Database Initialization
-- This script runs automatically on first container startup

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users (Owner / Technician)
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(30),
    role VARCHAR(20) NOT NULL DEFAULT 'TECHNICIAN',
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Customers
CREATE TABLE IF NOT EXISTS customers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(150) NOT NULL,
    email VARCHAR(150),
    phone VARCHAR(30),
    address TEXT,
    notes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Jobs
CREATE TABLE IF NOT EXISTS jobs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(200) NOT NULL,
    description TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    scheduled_date DATE,
    scheduled_time TIME,
    estimated_hours NUMERIC(5,2),
    address TEXT,
    amount NUMERIC(12,2) DEFAULT 0,
    customer_id UUID REFERENCES customers(id),
    technician_id UUID REFERENCES users(id),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_jobs_status ON jobs(status);
CREATE INDEX IF NOT EXISTS idx_jobs_customer ON jobs(customer_id);
CREATE INDEX IF NOT EXISTS idx_jobs_technician ON jobs(technician_id);
CREATE INDEX IF NOT EXISTS idx_jobs_scheduled_date ON jobs(scheduled_date);

-- Seed data
INSERT INTO users (id, name, email, password, phone, role) VALUES
    ('a0000000-0000-0000-0000-000000000001', 'Kahou Lei', 'kahou@swiftcrew.com', '$2a$10$placeholder', '(555) 100-0001', 'OWNER'),
    ('a0000000-0000-0000-0000-000000000010', 'Mike Rodriguez', 'mike@swiftcrew.com', '$2a$10$placeholder', '(555) 111-2222', 'TECHNICIAN'),
    ('a0000000-0000-0000-0000-000000000011', 'Sarah Chen', 'sarah@swiftcrew.com', '$2a$10$placeholder', '(555) 222-3333', 'TECHNICIAN'),
    ('a0000000-0000-0000-0000-000000000012', 'James Wilson', 'james@swiftcrew.com', '$2a$10$placeholder', '(555) 333-4444', 'TECHNICIAN'),
    ('a0000000-0000-0000-0000-000000000013', 'Emily Davis', 'emily@swiftcrew.com', '$2a$10$placeholder', '(555) 444-5555', 'TECHNICIAN')
ON CONFLICT (email) DO NOTHING;

INSERT INTO customers (id, name, email, phone, address) VALUES
    ('b0000000-0000-0000-0000-000000000001', 'Johnson Residence', 'mjohnson@email.com', '(555) 234-5678', '1234 Oak St, Austin, TX 78701'),
    ('b0000000-0000-0000-0000-000000000002', 'Riverside Office Park', 'admin@riverside.com', '(555) 345-6789', '500 Commerce Dr, Austin, TX 78702'),
    ('b0000000-0000-0000-0000-000000000003', 'Martinez Family', 'carlos.m@email.com', '(555) 456-7890', '789 Elm Ave, Round Rock, TX 78664'),
    ('b0000000-0000-0000-0000-000000000004', 'Greenfield HOA', 'board@greenfield.org', '(555) 567-8901', '2100 Green Blvd, Cedar Park, TX 78613'),
    ('b0000000-0000-0000-0000-000000000005', 'Summit Dental Clinic', 'ops@summitdental.com', '(555) 678-9012', '3400 Medical Pkwy, Austin, TX 78756')
ON CONFLICT DO NOTHING;

INSERT INTO jobs (id, title, description, status, scheduled_date, scheduled_time, estimated_hours, address, amount, customer_id, technician_id) VALUES
    (uuid_generate_v4(), 'HVAC Annual Maintenance', 'Full system inspection and filter replacement', 'IN_PROGRESS', '2026-03-06', '09:00', 3, '1234 Oak St, Austin, TX 78701', 450, 'b0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000010'),
    (uuid_generate_v4(), 'Electrical Panel Upgrade', 'Replace 100A panel with 200A panel', 'SCHEDULED', '2026-03-07', '08:00', 6, '500 Commerce Dr, Austin, TX 78702', 2800, 'b0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000011'),
    (uuid_generate_v4(), 'Plumbing Leak Repair', 'Kitchen sink pipe replacement and inspection', 'PENDING', '2026-03-08', '10:00', 2, '789 Elm Ave, Round Rock, TX 78664', 320, 'b0000000-0000-0000-0000-000000000003', 'a0000000-0000-0000-0000-000000000012'),
    (uuid_generate_v4(), 'Landscape Irrigation Install', 'Install new sprinkler system for common area', 'SCHEDULED', '2026-03-07', '07:00', 8, '2100 Green Blvd, Cedar Park, TX 78613', 4200, 'b0000000-0000-0000-0000-000000000004', 'a0000000-0000-0000-0000-000000000013'),
    (uuid_generate_v4(), 'AC Unit Replacement', 'Remove old unit, install new 3-ton AC', 'COMPLETED', '2026-03-05', '08:30', 5, '3400 Medical Pkwy, Austin, TX 78756', 5600, 'b0000000-0000-0000-0000-000000000005', 'a0000000-0000-0000-0000-000000000010')
ON CONFLICT DO NOTHING;
