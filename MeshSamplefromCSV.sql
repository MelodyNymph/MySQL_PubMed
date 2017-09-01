CREATE table sampleMesh (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    PMID int NOT NULL,
    UI varchar(255),
    Major varchar(255)
);

LOAD DATA LOCAL INFILE "/Users/ruizhao/Desktop/MYSQL/PUBMEDFILE/sampleMesh.csv"
INTO TABLE sampleMesh
COLUMNS TERMINATED BY ','
LINES TERMINATED BY '\n';
--IGNORE 1 rows;
