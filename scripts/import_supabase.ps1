# ========================================
# VOFC Supabase Import Script (Windows)
# ========================================

# --- Configuration ---
$Env:PGPASSWORD = "PatriciaF123!!!"
$DB_URL = "postgresql://postgres:$Env:PGPASSWORD@db.https://wivohgbuuwxoyfyzntsd.supabase.co:5432/postgres"

# --- Reset Tables ---
Write-Host "Resetting VOFC tables..."
psql $DB_URL -f "scripts/reset_vofc_tables.sql"

# --- Import Clean Data ---
Write-Host "Importing vulnerabilities..."
psql $DB_URL -c "\copy vulnerabilities FROM 'data/vulnerabilities.csv' CSV HEADER"

Write-Host "Importing options_for_consideration..."
psql $DB_URL -c "\copy options_for_consideration FROM 'data/options_for_consideration.csv' CSV HEADER"

Write-Host "Importing vulnerability_ofc_links..."
psql $DB_URL -c "\copy vulnerability_ofc_links FROM 'data/vulnerability_ofc_links.csv' CSV HEADER"

# --- Verify Integrity ---
Write-Host "Verifying integrity..."
psql $DB_URL -f "scripts/verify_integrity.sql"

Write-Host "`n✅ VOFC data successfully restored!"
