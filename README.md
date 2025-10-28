# 🔎 Official MATLAB Implementation: Fuzzy Natural Neighbors for Outlier Detection (FuNaN)

This repository contains the **official MATLAB implementation** of the **Fuzzy Natural Neighbors for Outlier Detection (FuNaN)** method.

FuNaN is a novel, unsupervised anomaly detection algorithm that leverages the mathematical structure of **Natural Neighbors** alongside the robustness of **fuzzy sets** to effectively model the inherent uncertainty in outlier definitions. It computes outlier scores based on both the local and global characteristics of the data.

---

## 📚 Reference Paper

If you use this code in your research, please cite the following paper:

> Saltos, R., Weber, R., & Pedrycz, W. (2025). **Fuzzy natural neighbors for outlier detection.** *Applied Soft Computing*, 114114, ISSN 1568-4946.
>
> **DOI:** `https://doi.org/10.1016/j.asoc.2025.114114`

---

## ✨ Key Features

This project provides a comprehensive package for Natural Neighbor-based outlier detection:

* **FuNaN Methods:** Full implementation of the various FuNaN strategies described in the paper.
* **Other NaN Algorithms:** Implementations of comparable Natural Neighbors-based outlier detection algorithms for benchmarking.
* **Computational Datasets:** The same datasets used in the paper's computational experiments are included for direct replication of results.

---

## ⚙️ Requirements & Installation

### Requirements

* **MATLAB R2024b** or higher.

### Installation

1.  **Download:** Clone this repository or download the ZIP file.
2.  **Add to Path:** In MATLAB, navigate to the main directory and select **Set Path** (or use the `addpath` command) to include the entire repository folder structure.

---

## 🚀 Input Data Format

The FuNaN code expects input data in a **MATLAB `.mat` file** with the following two variables:

| Variable | Description | Format |
| :--- | :--- | :--- |
| `'Data'` | The data matrix where **rows are samples** and **columns are features**. | $N \times D$ Matrix |
| `'y'` | The corresponding label vector. **Anomalies must be labeled as `2`** and normal data as `1` (or any other value). | $N \times 1$ Vector |

---

## 🤝 Contributing

We welcome contributions to the FuNaN project!

* Feel free to submit an **Issue** for any bug reports or feature suggestions.
* Please submit a **Pull Request** for any code improvements.

---

## 📝 License

This project is licensed under the **MIT License**.

---

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
