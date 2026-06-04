# AGENTS

## Project Purpose

This public repository supports the CHEST 2024 abstract, "Hypercapnic respiratory failure is infrequently reported as an adverse event in clinical trials" (doi:10.1016/j.chest.2024.06.3377). It contains Stata code for ClinicalTrials.gov adverse-event aggregation plus optional exploratory FAERS notebook work.

## Public And Data-Safety Rules

- Treat the repository as public. Do not add credentials, private drafts, local caches, generated outputs, or publisher-formatted article/reference PDFs.
- The primary ClinicalTrials.gov-derived inputs are public third-party source data from Du and Shi/Figshare. Link and cite the source records instead of committing mirrored data archives.
- Keep `data/`, `Data/`, `outputs/`, `.dta`, generated Excel files, Stata logs, OpenFDA caches, and notebook checkpoints ignored.
- The final poster PDF and author-owned Markdown summary are acceptable public abstract artifacts. Editable poster/source decks and draft DOCX files should remain local only.

## How To Orient Quickly

- Start with `README.md`, then `llms.txt` for the machine-readable summary.
- Use `CITATION.cff` for structured citation metadata. The preferred scholarly citation is the CHEST abstract DOI, not the repository URL alone.
- Use `data_dictionary.md` and `data_dictionary.csv` when editing `ClinicalTrialsGov.do`; add dictionary rows for any new source, derived, or output variables.

## Workflow

Run the primary workflow from the repository root:

```bash
stata-mp -b do ClinicalTrialsGov.do data/raw outputs/stata
```

Expected local inputs:

```text
data/raw/csv/efficacy_df.csv
data/raw/csv/safety_df.csv
```

The FAERS notebook is exploratory. Strip notebook outputs before committing, and keep OpenFDA cache/database files local.

## Stata Conventions

- Preserve the existing analysis logic unless a scientific correction is explicitly requested.
- Do not reintroduce hard-coded personal, cloud-sync, Desktop, or absolute project paths.
- Write logs, derived `.dta` files, and Excel exports under the caller-provided output root.
- `cleanplots` is optional; use `capture set scheme cleanplots` or document the dependency rather than making the run fail only because a scheme is unavailable.

## Verification Before Publishing Changes

- Run `git diff --check`.
- Validate `CITATION.cff` with CFF tooling and a YAML parse after citation edits.
- Search for generic readiness appendices, placeholder ORCIDs, blank DOI fields, hard-coded local paths, and root-level generated-output writes.
- Confirm no third-party PDFs, private drafts, generated `.dta`/Excel outputs, local data archives, notebook outputs, or cache files are staged.
