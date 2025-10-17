-- ========================================
-- VERIFY VOFC LINK INTEGRITY
-- ========================================

SELECT
  COUNT(*) AS broken_links
FROM vulnerability_ofc_links l
LEFT JOIN vulnerabilities v ON v.id = l.vulnerability_id
LEFT JOIN options_for_consideration o ON o.id = l.ofc_id
WHERE v.id IS NULL OR o.id IS NULL;

-- Should return 0 if all relationships are valid
