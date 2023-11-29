-- Load data from HDFS
inputDia4 = LOAD 'hdfs:///user/nikki/inputs/episodeIV_dialogues.txt' USING PigStorage('\t') AS (name:chararray, line:chararray);
inputDia5 = LOAD 'hdfs:///user/nikki/inputs/episodeV_dialogues.txt' USING PigStorage('\t') AS (name:chararray, line:chararray);
inputDia6 = LOAD 'hdfs:///user/nikki/inputs/episodeVI_dialogues.txt' USING PigStorage('\t') AS (name:chararray, line:chararray);

-- Filter out the first 2 lines from each file
ranked4 = RANK inputDia4;
OnlyDialogues4 = FILTER ranked4 BY (rank_inputDia4 > 2);
ranked5 = RANK inputDia5;
OnlyDialogues5 = FILTER ranked5 BY (rank_inputDia5 > 2);
ranked6 = RANK inputDia6;
OnlyDialogues6 = FILTER ranked6 BY (rank_inputDia6 > 2);

-- Merge the three inputs
inputData = UNION OnlyDialogues4, OnlyDialogues5, OnlyDialogues6;

-- Group by name
groupByName = GROUP inputData BY name;

-- Count the number of lines by each character
names = FOREACH groupByName GENERATE $0 as name, COUNT($1) as no_of_lines;
namesOrdered = ORDER names BY no_of_lines DESC;

-- Remove the outputs folder
rmf hdfs:///user/nikki/outputs;

-- Store result in HDFS
STORE namesOrdered INTO 'hdfs:///user/nikki/outputs' USING PigStorage('|');
