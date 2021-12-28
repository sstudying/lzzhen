# Epileptic Seizure Classification

# Dataset
(1) Bonn dataset has been used in the experiment is from the EEG database of the Epilepsy Research Center of the University of Bonn, Germany.
(2) CHB-MIT was recorded from Boston Childrens Hospital, which collected continuous, long-term and multi-channel EEG signals from 23 pediatric patients at a 256Hz sampling rate. 
CHB-MIT dataset is available from https://physionet.org/content/chbmit/1.0.0/.

# Feature extraction
GLCM and LBP descriptors were used to extract the global and local features of time-frequency images respectively.  

# Harris hawks optimization Algorithm
HHO code has be publicly proviede in https://aliasgharheidari.com/HHO.html

# Improved Harris hawks optimization
A key novelty of this work is to introduce two search strategies on the original HHO, namely, hierarchy mechanism 
and transfer function. The former can divide the population into hierarchical structure to enhance the local search ability 
of HHO algorithm and avoid falling into local optimum. The latter can enhance the diversity of the population and 
accelerate the rate of convergence in the search phase of the population.

# Signals classification
The k-nearest neighbor (KNN) classifier is used in this paper to classify epileptic EEG signals.
