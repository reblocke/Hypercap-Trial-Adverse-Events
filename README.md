# Hypercap Trial Adverse Events

[![DOI](https://img.shields.io/badge/CHEST%20abstract-10.1016%2Fj.chest.2024.06.3377-blue)](https://doi.org/10.1016/j.chest.2024.06.3377)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Cite with CFF](https://img.shields.io/badge/citation-CFF-blueviolet)](CITATION.cff)

Code and public presentation materials for the CHEST 2024 abstract, **"Hypercapnic respiratory failure is infrequently reported as an adverse event in clinical trials"**.

## Links And Identifiers

| Item | Link |
| --- | --- |
| CHEST abstract | [10.1016/j.chest.2024.06.3377](https://doi.org/10.1016/j.chest.2024.06.3377) |
| Abstract citation | CHEST. 2024;166(4):A5688 |
| Public poster | [abstract/hypercap-trial-ae-chest-2024-poster.pdf](abstract/hypercap-trial-ae-chest-2024-poster.pdf) |
| Poster summary | [abstract/hypercap-trial-ae-chest-2024-summary.md](abstract/hypercap-trial-ae-chest-2024-summary.md) |
| Source-data paper | [Scientific Data. 2024;11:41](https://doi.org/10.1038/s41597-023-02869-7) |
| Source-data collection | [Figshare collection 10.6084/m9.figshare.c.6860254.v1](https://doi.org/10.6084/m9.figshare.c.6860254.v1) |
| Machine-readable index | [llms.txt](llms.txt) |

## Project Summary

This repository evaluates how often hypercapnic respiratory failure, hypoventilation, respiratory depression, or closely related adverse-event terms appear in structured ClinicalTrials.gov results. The primary workflow uses the Du and Shi ClinicalTrials.gov results dataset to aggregate adverse-event reporting at the trial-arm and trial levels.

The repository is an abstract/poster code repository, not a full manuscript repository. It does not contain a peer-reviewed full article, PMCID, or publisher manuscript text for this project.

## Authors, Funding, And Disclosures

| Contributor | Role | Affiliation |
| --- | --- | --- |
| Dustin Anderson-Bell, MD | Abstract author | University of Utah Health, Division of Pulmonary and Critical Care |
| Brian W. Locke, MD, MSc | Abstract author, repository maintainer | University of Utah Health and Intermountain Medical Center, Pulmonary and Critical Care |

Funding/support listed on the poster: ASPIRE Fellowship, NIH NRSA `5T32HL105321`, and Intermountain Fund support for Brian W. Locke. Disclosure listed on the poster: Brian W. Locke has ownership in Mountain Biometrics, unrelated to this project.

## Data Access And Boundaries

The analysis uses public ClinicalTrials.gov-derived structured results from Du and Shi. The repository no longer tracks a bundled `Data.zip` snapshot; download the source data from Figshare and place the CSV files locally as shown below.

```text
data/raw/csv/efficacy_df.csv
data/raw/csv/safety_df.csv
```

Local data extracts, generated `.dta` files, Excel exports, logs, and OpenFDA caches are ignored by git. Do not commit third-party article PDFs, local data mirrors, generated outputs, or notebook execution outputs.

## Quick Start

1. Clone the repository.
2. Download the Du and Shi Figshare data collection.
3. Place `efficacy_df.csv` and `safety_df.csv` under `data/raw/csv/`.
4. Run the Stata workflow from the repository root:

```bash
stata-mp -b do ClinicalTrialsGov.do data/raw outputs/stata
```

The script also accepts omitted arguments:

```bash
stata-mp -b do ClinicalTrialsGov.do
```

With omitted arguments, it expects inputs under `data/raw/` and writes generated files under `outputs/stata/`.

## Workflow And Outputs

| Step | Command or file | Purpose | Outputs |
| --- | --- | --- | --- |
| Source data download | Figshare collection | Obtain public ClinicalTrials.gov result CSVs | Local `data/raw/csv/` files |
| Trial/adverse-event aggregation | `ClinicalTrialsGov.do` | Build trial-level and arm-level adverse-event summaries | `outputs/stata/derived/*.dta`, `outputs/stata/exports/*.xlsx`, dated logs |
| FAERS exploration | `FAERS access.ipynb` | Optional prototype for OpenFDA/FAERS access | Local notebook outputs and caches only |
| Abstract/poster context | `abstract/` | Public poster artifact and author-owned summary | PDF poster and Markdown summary |

## Dependencies

| Component | Requirement |
| --- | --- |
| Stata | Stata 17 or later for the primary `.do` workflow |
| Stata scheme | `cleanplots` is optional; the script continues if unavailable |
| Python/Jupyter | See `environment.yml` or `requirements.txt` for notebook exploration |
| External data | Du and Shi Figshare CSV files |

## Repository Inventory

| Path | Description |
| --- | --- |
| `ClinicalTrialsGov.do` | Primary Stata analysis workflow for ClinicalTrials.gov adverse-event aggregation |
| `FAERS access.ipynb` | Optional exploratory notebook for OpenFDA/FAERS access |
| `abstract/` | Public author-owned CHEST 2024 poster artifact and summary |
| `data_dictionary.md`, `data_dictionary.csv` | Human-readable and machine-readable data dictionary |
| `llms.txt` | Machine-readable repository index for LLMs and search agents |
| `CITATION.cff` | Structured repository and abstract citation metadata |
| `environment.yml`, `requirements.txt` | Notebook/Python environment manifests |

## Data Dictionary

Use [data_dictionary.md](data_dictionary.md) for a human-readable codebook and [data_dictionary.csv](data_dictionary.csv) for a machine-readable variable inventory. The dictionary documents source CSV fields, derived adverse-event flags, arm/trial aggregation variables, output artifacts, and legacy spellings preserved from the analysis code.

## Results Mapping

| Result in abstract/poster | Workflow source |
| --- | --- |
| Counts of completed and unfinished trials | `ClinicalTrialsGov.do`, trial-level aggregation from `efficacy_df.csv` and `safety_df.csv` |
| Definite and possible hypercapnia adverse-event counts | `ClinicalTrialsGov.do`, adverse-event term flags |
| Trial-arm and trial-level event summaries | `outputs/stata/exports/by arm data.xlsx` and `outputs/stata/exports/by trial data.xlsx` after local run |
| Poster narrative and displayed values | `abstract/hypercap-trial-ae-chest-2024-poster.pdf` and Markdown summary |

## Citation

If using the repository code, cite the repository release or commit and the CHEST abstract:

> Anderson-Bell D, Locke BW. Hypercapnic respiratory failure is infrequently reported as an adverse event in clinical trials. CHEST. 2024;166(4):A5688. doi:[10.1016/j.chest.2024.06.3377](https://doi.org/10.1016/j.chest.2024.06.3377)

If using the ClinicalTrials.gov structured results data, also cite:

> Shi X, Du J. Constructing a finer-grained representation of clinical trial results from ClinicalTrials.gov. Scientific Data. 2024;11:41. doi:[10.1038/s41597-023-02869-7](https://doi.org/10.1038/s41597-023-02869-7)

## License

Repository code and author-owned documentation are released under the [MIT License](LICENSE). Third-party source data, article pages, reference papers, and external databases remain under their original terms. The CHEST abstract and source-data records should be linked and cited rather than mirrored as publisher text.

## Contributing And Contact

See [CONTRIBUTING.md](CONTRIBUTING.md). For repository-specific questions, open a GitHub issue or pull request. Maintainer: Brian W. Locke (`@reblocke`, ORCID [`0000-0002-3588-5238`](https://orcid.org/0000-0002-3588-5238)).
