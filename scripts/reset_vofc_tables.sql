-- ========================================
-- RESET AND PREPARE VOFC TABLES
-- ========================================

BEGIN;

-- 1) Clear child table first
TRUNCATE TABLE vulnerability_ofc_links;

-- 2) Clear parents and reset ID sequences
TRUNCATE TABLE options_for_consideration RESTART IDENTITY;
TRUNCATE TABLE vulnerabilities RESTART IDENTITY;

-- 3) Allow explicit IDs for CSV imports
ALTER TABLE vulnerabilities ALTER COLUMN id DROP IDENTITY IF EXISTS;
ALTER TABLE options_for_consideration ALTER COLUMN id DROP IDENTITY IF EXISTS;

COMMIT;
