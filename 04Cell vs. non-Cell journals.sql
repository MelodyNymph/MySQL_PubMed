-- Cell vs. non-Cell journals
-- 1.	Average number of MESH terms
-- use MASTER table: newpub; MESH table: medline17n0001PMIDMESH

-- CELL
CREATE TABLE CELLmedline17n0001
SELECT * FROM newpub
WHERE JournalTitle = 'Cell'

----- cell's PMID AND UI
CREATE TABLE CELLmedline17n0001UI
SELECT CELLmedline17n0001.PMID, medline17n0001PMIDMESH.UI, CELLmedline17n0001.JournalTitle
FROM CELLmedline17n0001
LEFT JOIN medline17n0001PMIDMESH ON CELLmedline17n0001.PMID=medline17n0001PMIDMESH.PMID;

----- cell's PMID and UI'S COUNT
CREATE TABLE CELLmedline17n0001UINUM
SELECT
    PMID, COUNT(*) as NUM 
FROM
    CELLmedline17n0001UI
GROUP BY
    PMID
HAVING 
    COUNT(*) >= 1

SELECT avg(NUM)
FROM CELLmedline17n0001UINUM


-- NONCELL
CREATE TABLE NONCELLmedline17n0001
SELECT * FROM newpub
WHERE JournalTitle != 'Cell'

CREATE TABLE NONCELLmedline17n0001UI
SELECT NONCELLmedline17n0001.PMID, medline17n0001PMIDMESH.UI, JournalTitle
FROM NONCELLmedline17n0001
LEFT JOIN medline17n0001PMIDMESH ON NONCELLmedline17n0001.PMID=medline17n0001PMIDMESH.PMID;


CREATE TABLE NONCELLmedline17n0001UINUM
SELECT
    PMID, COUNT(*) as NUM 
FROM
    NONCELLmedline17n0001UI
GROUP BY
    PMID
HAVING 
    COUNT(*) >= 1

SELECT avg(NUM)
FROM NONCELLmedline17n0001UINUM


-- 2.	Percent of papers in Cell or non-Cell that use each tree (A, B, …)

-- CELL
-- use CELLmedline17n0001UI and descTree
CREATE TABLE cellPMIDUITREE
SELECT CELLmedline17n0001UI.PMID, CELLmedline17n0001UI.UI, descTree.TreeNumber
FROM CELLmedline17n0001UI
LEFT JOIN descTree ON CELLmedline17n0001UI.UI=descTree.DescriptorUI
ORDER BY PMID;

-- get the label (A, B, ...) for all the items 
CREATE TABLE cellPMIDUITREEPREFIX
SELECT *, SUBSTRING(TreeNumber, 1, 1) AS Prefix
FROM cellPMIDUITREE
ORDER BY PMID

-- COUNT the number of articles for each tree
SELECT Prefix, COUNT(DISTINCT PMID) as numPMID
from cellPMIDUITREEPREFIX
GROUP BY Prefix


-- NONCELL
-- use NONCELLmedline17n0001 and descTree
CREATE TABLE noncellPMIDUITREE
SELECT NONCELLmedline17n0001.PMID, NONCELLmedline17n0001.UI, descTree.TreeNumber
FROM NONCELLmedline17n0001
LEFT JOIN descTree ON NONCELLmedline17n0001.UI=descTree.DescriptorUI
ORDER BY PMID;

-- get the label (A, B, ...) for all the items 
CREATE TABLE noncellPMIDUITREEPREFIX
SELECT *, SUBSTRING(TreeNumber, 1, 1) AS Prefix
FROM noncellPMIDUITREE
ORDER BY PMID

-- COUNT the number of articles for each tree
SELECT Prefix, COUNT(DISTINCT PMID) as numPMID
from noncellPMIDUITREEPREFIX
GROUP BY Prefix


