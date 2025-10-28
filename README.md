# Official Matlab Implementation of Fuzzy Natural Neighbors for Outlier Detection

This is the official Matlab implementation of the *Fuzzy Natural Neighbors for Outlier Detection* (FuNaN) method based on the paper by Saltos, R., Weber, R., and Pedrycz, W., "Fuzzy natural neighbors for outlier detection,"
Applied Soft Computing, 2025, 114114, ISSN 1568-4946, https://doi.org/10.1016/j.asoc.2025.114114.

## Overview

FuNaN methods are unsupervised anomaly detection algorithms that combines the strengths of natural neihbors with fuzzy sets to leverage the uncertainty in outlier definitions. The algorithms use different strategies to compute the outlier scores based on the local and global information of the data.

The project includes:
- Implementation of the FuNaN methods described in the paper.
- Implementation of other NaN outlier detection algorithms.
- The datasets used in the computational experiments.

## Requirements
- Matlab 2024b or higher.

## Installation

1. Download the repository
2. Add to Matlab Path.

### Input Data Format

The code expects data in MATLAB .mat format with:
- 'Data': Matrix where rows are samples and columns are features
- 'y': Vector of labels where anomalies are labeled as 2

## References

- FuNaN Paper: Saltos, R., Weber, R., & Pedrycz, W. (2025). Fuzzy natural neighbors for outlier detection. Applied Soft Computing, 114114. https://doi.org/10.1016/j.asoc.2025.114114.

## License

MIT

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
