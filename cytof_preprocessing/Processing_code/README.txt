1. runNormalization.m - read data, find beads, interpolate signal, remove beads
. Make sure that the 'filenames' 
and 'prefixes' match the files you want to process (prefixes includes the filename without .FCS). Also, make 
sure that the directories for the files you're processing are set in lines 69 and 71.
2. readData.m - loads normalized data files, applies arcSin transform. Make sure the filenames here work as well.
You should follow the pattern given (make sure that the argument in strcat ends in "_standard_0_normalized.fcs".
3. populateIntercalationIntervals.m - plots DNA1 vs DNA2, allows you to draw single cell gate
 by drawing a box.
4. runProcess.m - isolate single-nucleated events based on gates from step 3, isolate living cells using cisplatin 
threshold. You'll need to set this threshold for each file in line 34.

5. readProcessedData.m - You can run this to read in the processed data into matlab.  You'll need to change the filenames.