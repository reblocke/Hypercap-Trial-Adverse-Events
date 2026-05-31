# Hypercap Trial Adverse Events

> **Work in progress.** Analytic code and notes for examining how often **hypercapnic respiratory failure** is reported as a (serious) adverse event in clinical trials results on ClinicalTrials.gov, with exploratory comparisons to spontaneous reporting systems (FAERS now; VAERS possibly later).

---

## Links & IDs
- **Project repo:** https://github.com/reblocke/Hypercap-Trial-Adverse-Events  
- **Poster/abstract (CHEST 2024):** see `Hypoventilation poster CHEST 2024.pdf` (in repo) and citation in *Cite this work* below.  
- **Source data (CT.gov structured results):** Du & Shi dataset (Scientific Data, 2024) and Figshare collection  
  - Paper: https://www.nature.com/articles/s41597-023-02869-7  
  - Dataset: https://doi.org/10.6084/m9.figshare.c.6860254.v1  

---

## Status & scope

- This repository currently contains:
  - **Stata analysis** for trial‑level and arm‑level counts from the Du & Shi CT.gov results dataset (`ClinicalTrialsGov.do`).
  - **Jupyter notebook(s)** for exploratory **FAERS** access (`FAERS access.ipynb`).
  - **Poster files** from the CHEST 2024 presentation (`Hypoventilation poster CHEST 2024.pdf` / `.pptx`).

- **Planned**: finalize FAERS import/aggregation and consider **VAERS** rate comparisons; add figure‑/table‑generation scripts; cut a tagged release and archive to Zenodo; add tests and environment files.

---

## Quick start

### Option A — Use the small convenience archive in this repo
1. **Clone** the repo and **unzip** `Data.zip` at the repository root (creates a `Data/` folder with required CSVs).
2. Run Stata (see *Running the Stata analysis* below) or open the notebook(s) for exploratory FAERS steps.

### Option B — Pull the full CT.gov results dataset from Figshare
1. Download the **Figshare collection** for Du & Shi (see link above) and place files under `Data/` with this structure:
   ```
   Data/
   ├── biobert_validation.xlsx
   ├── csv/
   │   ├── ade_sample.csv
   │   ├── efficacy_df.csv
   │   ├── efficacy_sample.csv
   │   └── safety_df.csv
   ├── json/
   │   ├── ade_sample.json
   │   ├── efficacy_df.json
   │   ├── efficacy_sample.json
   │   └── safety_df.json
   └── pickle/
       ├── efficacy_df.pickle
       └── safety_df.pickle
   ```
   > **Note:** current code reads the **CSV** files; JSON support is intended later.

---

## Running the Stata analysis

1. Open `ClinicalTrialsGov.do` in Stata.
2. **Edit the local path** near the top of the file to point to your local clone.
3. Run the `.do` file.  
   - Expected outputs: `by_arm_data.dta`, `by_trial_data.dta`, `trials_data.dta` plus Excel exports.

> **Requirements:** Stata (v16+ recommended). No PHI/PII is included.

---

## Running the FAERS exploration (prototype)

- Open `FAERS access.ipynb` in Jupyter.  
- Prototype only; may require installing packages manually.  
- **Planned:** scripted ingestion and harmonization with CT.gov AE categories.

---

## Repository layout

```
├── ClinicalTrialsGov.do
├── Data.zip
├── FAERS access.ipynb
├── Hypoventilation poster CHEST 2024.pdf / .pptx
├── How FDA defines ADE.pdf
├── ML for ADE.pdf
├── Drug Safety 2023 EHR for safety.pdf
├── SE-table_Update-7_FINAL_022822.xlsx
├── by_arm_data.dta / by_trial_data.dta / trials_data.dta
├── by arm data.xlsx / by trial data.xlsx
├── LICENSE
└── README.md
```

---

## Data notes

- **Primary source**: CT.gov results dataset curated by Du & Shi (2024, *Scientific Data*).  
- **Convenience**: `Data.zip` contains CSVs; for full replication, use Figshare.

**Ethics & privacy.** All data are **public**; no PHI/PII included.

---

## Results mapping

| Output / artifact | Script/notebook | Notes |
|-------------------|-----------------|-------|
| Trial‑level counts | `ClinicalTrialsGov.do` | Produces `by_trial_data.*` |
| Arm‑level AE counts | `ClinicalTrialsGov.do` | Produces `by_arm_data.*` |
| Poster (CHEST 2024) | `Hypoventilation poster CHEST 2024.*` | Presentation materials |

---

## Cite this work

- **CHEST 2024 abstract/poster**  
  Anderson‑Bell D, Locke BW. *Hypercapnic respiratory failure is infrequently reported as an adverse event in clinical trials.* CHEST. 2024;166(4):A5688.

- **CT.gov dataset**  
  Shi X, Du J. *Constructing a finer‑grained representation of clinical trial results from ClinicalTrials.gov.* *Scientific Data.* 2024;11:41. https://doi.org/10.6084/m9.figshare.c.6860254.v1

---

## Contributing & collaboration

We welcome contributions to:
- Finalize FAERS ingestion and harmonization.  
- Explore VAERS comparisons.  
- Add reproducible figure/table scripts.

See [`CONTRIBUTING.md`](./CONTRIBUTING.md).

---

## License

See [`LICENSE`](./LICENSE).

---

## Maintainer

Maintainer: @reblocke (via GitHub Issues)

## LLM and Repository Readiness Notes

### Description
Hypercapnic Respiratory Failure is Infrequently Reported as an Adverse Event in Clinical Trials

### Instructions
Start with this README, then inspect the files listed under Repository Layout. For computational workflows, run commands from the repository root and avoid committing generated outputs unless a release explicitly calls for them.

### Authors, Funding, and Acknowledgments
Maintainer: Brian W. Locke (`@reblocke`, ORCID 0000-0002-3588-5238). Preserve any project-specific author, funding, and acknowledgment details already listed elsewhere in the repository or accompanying publication.

### Repository Layout
- `CITATION.cff`
- `CONTRIBUTING.md`
- `ClinicalTrialsGov.do`
- `Data.zip`
- `Drafts/2024-3-11 Data Output.docx`
- `Drafts/2024-3-11 Hypercap Outcome Abs Draft.docx`
- `Drafts/Hypoventilation poster CHEST 2024.pptx  -  Read-Only.pptx`
- `Drug Safety 2023 EHR for safety.pdf`
- `FAERS access.ipynb`
- `How FDA defines ADE.pdf`
- `Hypoventilation poster CHEST 2024.pdf`
- `Hypoventilation poster CHEST 2024.pptx`
- `LICENSE`
- `ML for ADE.pdf`

### Data and Codebook
Trial-registry/public extracted data; verify source licensing

### Workflow / Script Order
Review notebook workflow

### Dependencies / Environment
Jupyter requirements if present

### Citation
No publication DOI is assigned to this repository. Cite the GitHub repository URL and the commit or release used.

### License
Repository license status: MIT. See the root license file when present. Third-party and publisher materials remain under their original terms.

### Manuscript Status
No manuscript version expected yet; use abstract/repo summary Do not add unpublished manuscript text

### Contact
Maintainer: Brian W. Locke (`@reblocke`). Use GitHub issues or pull requests for repository-specific questions when the repository is public.
