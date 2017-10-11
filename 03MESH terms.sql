-- MESH terms
-- Top 100 most frequent MESH terms
SELECT UI, COUNT(PMID) AS NUMUI
FROM sampleMesh
GROUP BY UI
ORDER BY NUMUI DESC
LIMIT 100 

