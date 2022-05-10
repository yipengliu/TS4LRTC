# TS4LRTC: Trainable Subspaces for Low Rank Tensor Completion: Model and Analysis

With the help of auxiliary data, tensor completion may better recover a low rank multidimensional array from limited observation entries. Most existing methods, including coupled matrix-tensor factorization and coupled tensor rank minimization, mainly focus on how to extract and incorporate subspace or directly use auxiliary data for tensor completion. They are either sensitive to a given rank or lack of physical interpretations of subspace information. In addition, the shared subspace information receives little attention in current tensor completion methods, especially there is no analysis of its impact on sample complexity. In this paper, we propose to separately explore and exploit shared subspaces for tensor completion. Specifically, dictionary learning takes the subspace from auxiliary data in the first step. Then a low rank optimization model for tensor completion is provided to incorporate the trained subspace by assuming that the recovered tensor is composed of two low rank components where one shares the subspace information with auxiliary data and the other is outside the shared space. Based on this optimization model, we make a quantitative analysis to illustrate the effect of subspace information on sample complexity, and provide theoretical insights into the usefulness of subspace information. Finally, experiments on simulated data are conducted to validate the theoretical analysis on the impact of subspace information. Experiments in two realworld applications including color image and multispectral image recovery show that the proposed method outperforms state-ofthe-art ones in terms of prediction accuracy and CPU time.

# data sources

You can try just run the 

1. demo_RGB.m for RGB-IR image completion

2. demo_MSI.m for MSI completion

MSI testing Datasets （Toy and Flowers）are downloaded from https://www.cs.columbia.edu/CAVE/databases/multispectral/stuff/

For setting up, we can add path by the following sentence.

addpath('mylib');

# reference

Z. Long, C. Zhu, J. Liu, P. Comon, Y. Liu, "Trainable Subspaces for Low Rank Tensor Completion: Model and Analysis," IEEE Transactions on Signal Processing, 2022.
