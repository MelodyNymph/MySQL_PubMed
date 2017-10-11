-- 1.	Average number of MESH terms per paper
CREATE table CountMesh
SELECT
    PMID, COUNT(*) as NUM 
FROM
    PubMed.sampleMesh
GROUP BY
    PMID
HAVING 
    COUNT(*) >= 1

SELECT avg(NUM)
FROM CountMesh

-- a. SD of number 
SELECT STDDEV(NUM)
FROM CountMesh

-- 2. Average number of MESH terms per paper BY YEAR
CREATE TABLE sampleMeshWITHYEAR
SELECT sampleMesh.PMID, sampleMesh.UI, MASTER.PubDateYear
FROM sampleMesh
LEFT JOIN MASTER ON sampleMesh.PMID=MASTER.PMID;

CREATE TABLE PMIDYEARUICOUNT
SELECT
    PMID, PubDateYear, COUNT(*) as NUM 
FROM
	sampleMeshWITHYEAR
GROUP BY
    PMID, PubDateYear
HAVING 
    COUNT(*) >= 1


SELECT PubDateYear, avg(NUM) 
FROM PMIDYEARUICOUNT
GROUP BY PubDateYear

