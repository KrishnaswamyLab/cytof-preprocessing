Code for preprocessing fcs files for cytof data. See cytofPipelineExample.m for an example of how to run the various scripts and more details on the processes.

The exact order for processing may vary from dataset to dataset. However, the general process should be as follows:

1. Do bead normalization (runNormalization.m)
2. Perform arcsin transform (readNormalizedData.m)
3. If a spike-in sample has been included for normalizing between samples, then the spike-in normalization should probably happen here. Right now, the code uses a linear method (linearNormSpikein.m). For immune cells (and other cells?), it can also just be useful to gate using CD45  to get rid of debris.
4. Filter out doublets using DNA1 and DNA2.
5. Filter for live/dead cells using Cisplatin.

There are a few other functions that read or save data from or into fcs files. See cytofPipelineExample.m for more details.
