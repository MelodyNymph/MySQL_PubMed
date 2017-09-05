--create descMaster table: DescriptorUI，DescriptorName
CREATE TABLE descMaster (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    DescriptorUI varchar(255) NOT NULL,
    DescriptorName varchar(255) NOT NULL
);

LOAD DATA LOCAL INFILE "/Users/ruizhao/Desktop/MYSQL/PUBMEDFILE/desc2017master.csv"
INTO TABLE descMaster
COLUMNS TERMINATED BY ','
LINES TERMINATED BY '\n';
