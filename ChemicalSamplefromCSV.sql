CREATE table sampleChemical (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    PMID int NOT NULL,
    RegistryNumber varchar(255),
    NameOfSubstanceUI varchar(255)
);

LOAD DATA LOCAL INFILE "/Users/ruizhao/Desktop/MYSQL/PUBMEDFILE/sampleChemical.csv"
INTO TABLE sampleChemical
COLUMNS TERMINATED BY ','
LINES TERMINATED BY '\n';