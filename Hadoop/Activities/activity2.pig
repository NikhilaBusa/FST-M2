-- Load input file from HDFS
inputFile = LOAD 'hdfs:///user/nikki/input.txt' AS (line);
-- Tokeize each word in the file (Map)
words = FOREACH inputFile GENERATE FLATTEN(TOKENIZE(line)) AS word;
-- Combine the words from the above stage
grpd = GROUP words BY word;
-- Count the occurence of each word (Reduce)
cntd = FOREACH grpd GENERATE group, COUNT(words);
-- Store the result in HDFS
STORE cntd INTO 'hdfs:///user/nikki/results';