# VOFC Library Database Schema

## Database Overview
**Database Type:** PostgreSQL (Supabase)  
**Connection:** `postgresql://postgres:PatriciaF123!!!@db.wivohgbuuwxoyfyzntsd.supabase.co:5432/postgres`

## Table Structure

### 1. `vulnerabilities` Table
**Purpose:** Stores security and resilience vulnerabilities

| Column | Type | Description |
|--------|------|-------------|
| `id` | UUID | Primary key (from CSV: 5519cf3b-17a8-4337-9e19-26d3cf97255d) |
| `vulnerability` | TEXT | Description of the vulnerability |
| `discipline` | TEXT | Category/domain (e.g., "Facility Information", "Security Management") |
| `source` | TEXT | Source of the vulnerability data |
| `created_at` | TIMESTAMP | Record creation timestamp |
| `updated_at` | TIMESTAMP | Last update timestamp |
| `sector_id` | TEXT | Associated sector identifier |
| `subsector_id` | TEXT | Associated subsector identifier |

**Sample Data:**
- 108 vulnerability records
- Disciplines include: Facility Information, First Preventers-Responders, Information Sharing, Security Management, Resilience Management, Security Force, Perimeter Security, Entry Controls, Barriers, Building Envelope, Electronic Security Systems, Illumination

### 2. `options_for_consideration` Table
**Purpose:** Stores mitigation options and recommendations for vulnerabilities

| Column | Type | Description |
|--------|------|-------------|
| `id` | UUID | Primary key (from CSV: 6adffe1b-c935-4d62-a5e6-7556533cf227) |
| `option_text` | TEXT | Detailed description of the option for consideration |
| `discipline` | TEXT | Category/domain (matches vulnerability disciplines) |
| `source` | TEXT | Source of the option data |
| `created_at` | TIMESTAMP | Record creation timestamp |
| `updated_at` | TIMESTAMP | Last update timestamp |
| `sector_id` | TEXT | Associated sector identifier |
| `subsector_id` | TEXT | Associated subsector identifier |

**Sample Data:**
- 289 options for consideration records
- Provides actionable recommendations for each vulnerability type

### 3. `vulnerability_ofc_links` Table
**Purpose:** Links vulnerabilities to their corresponding options for consideration

| Column | Type | Description |
|--------|------|-------------|
| `vulnerability_id` | UUID | Foreign key to vulnerabilities.id |
| `ofc_id` | UUID | Foreign key to options_for_consideration.id |
| `link_type` | TEXT | Type of relationship (e.g., "direct") |
| `confidence_score` | DECIMAL | Confidence level of the link (0.0-1.0) |
| `created_at` | TIMESTAMP | Record creation timestamp |

**Sample Data:**
- 315 linking records
- All links are "direct" type with confidence_score of 1.0
- Establishes many-to-many relationships between vulnerabilities and options

## Relationships

```
vulnerabilities (1) ←→ (M) vulnerability_ofc_links (M) ←→ (1) options_for_consideration
```

- **One-to-Many:** One vulnerability can have multiple options for consideration
- **Many-to-One:** Multiple vulnerabilities can share the same option for consideration
- **Link Table:** `vulnerability_ofc_links` manages the many-to-many relationship

## Data Integrity

### Foreign Key Constraints
- `vulnerability_ofc_links.vulnerability_id` → `vulnerabilities.id`
- `vulnerability_ofc_links.ofc_id` → `options_for_consideration.id`

### Data Validation
- All links should have valid foreign key references
- Integrity check query: `SELECT COUNT(*) AS broken_links FROM vulnerability_ofc_links l LEFT JOIN vulnerabilities v ON v.id = l.vulnerability_id LEFT JOIN options_for_consideration o ON o.id = l.ofc_id WHERE v.id IS NULL OR o.id IS NULL;`

## Discipline Categories

### Vulnerabilities Disciplines:
1. **Facility Information** - Awareness and information sharing
2. **First Preventers-Responders** - Emergency response coordination
3. **Information Sharing** - Intelligence and communication networks
4. **Security Management** - Policies, plans, and procedures
5. **Resilience Management - Business Continuity** - Operational continuity
6. **Resilience Management - Emergency Action Plan** - Emergency response
7. **Security Force** - Personnel and training
8. **Perimeter Security** - Physical barriers and fencing
9. **Entry Controls** - Access management
10. **Barriers** - Physical protection measures
11. **Building Envelope** - Structural security
12. **Electronic Security Systems - IDS** - Intrusion detection
13. **Electronic Security Systems - CCTV** - Video surveillance
14. **Illumination** - Lighting security

## Data Import Process

### Reset Process:
1. Truncate `vulnerability_ofc_links` (child table first)
2. Truncate `options_for_consideration` with IDENTITY restart
3. Truncate `vulnerabilities` with IDENTITY restart
4. Drop IDENTITY constraints to allow explicit UUID imports

### Import Process:
1. Import `vulnerabilities.csv` → `vulnerabilities` table
2. Import `options_for_consideration.csv` → `options_for_consideration` table
3. Import `vulnerability_ofc_links.csv` → `vulnerability_ofc_links` table
4. Verify data integrity

## Sample Queries

### Get all vulnerabilities with their options:
```sql
SELECT 
    v.vulnerability,
    v.discipline,
    o.option_text
FROM vulnerabilities v
JOIN vulnerability_ofc_links l ON v.id = l.vulnerability_id
JOIN options_for_consideration o ON o.id = l.ofc_id
ORDER BY v.discipline, v.vulnerability;
```

### Count vulnerabilities by discipline:
```sql
SELECT 
    discipline,
    COUNT(*) as vulnerability_count
FROM vulnerabilities
GROUP BY discipline
ORDER BY vulnerability_count DESC;
```

### Get options for a specific vulnerability:
```sql
SELECT 
    o.option_text,
    l.confidence_score
FROM options_for_consideration o
JOIN vulnerability_ofc_links l ON o.id = l.ofc_id
WHERE l.vulnerability_id = '5519cf3b-17a8-4337-9e19-26d3cf97255d';
```

## Security Considerations
- Database credentials are stored in PowerShell environment variables
- Connection string includes password authentication
- All data is stored in a managed Supabase PostgreSQL instance
- UUID primary keys provide security through obscurity
