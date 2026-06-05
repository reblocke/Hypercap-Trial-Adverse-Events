# Data Dictionary

This dictionary documents the public source files, derived variables, and generated artifacts used by `ClinicalTrialsGov.do`. It is intended for reproducibility review and machine indexing; the machine-readable companion is `data_dictionary.csv`.

## Source Data

| File | Source | Expected local path | Git status |
| --- | --- | --- | --- |
| `efficacy_df.csv` | Du and Shi ClinicalTrials.gov structured results dataset | `data/raw/csv/efficacy_df.csv` | Ignored local input |
| `safety_df.csv` | Du and Shi ClinicalTrials.gov structured results dataset | `data/raw/csv/safety_df.csv` | Ignored local input |

Canonical source records:

- Source paper: [10.1038/s41597-023-02869-7](https://doi.org/10.1038/s41597-023-02869-7)
- Figshare collection: [10.6084/m9.figshare.c.6860254.v1](https://doi.org/10.6084/m9.figshare.c.6860254.v1)

The source data are public third-party data. They should be downloaded from the source collection and should not be mirrored in this repository as `Data.zip` or tracked extracted CSV files.

## Key Source Variables

| Variable | Source | Meaning | Notes |
| --- | --- | --- | --- |
| `nct_id` | `efficacy_df.csv`, `safety_df.csv` | ClinicalTrials.gov trial identifier | Trimmed and used as the merge key. |
| `study_type` | `efficacy_df.csv` | ClinicalTrials.gov study type | Used to retain interventional trials; source coding should be reviewed. |
| `completion_year` | `efficacy_df.csv` | Trial completion year | Destringed before output. |
| `enrollment_num` | `efficacy_df.csv` | Trial enrollment count | Used for participant denominator summaries. |
| `condition`, `condition_mesh` | `efficacy_df.csv` | Trial condition text and MeSH terms | Often list-like source text. |
| `trial_phase`, `funder_type`, `funder_name` | `efficacy_df.csv` | Trial metadata fields | Carried to outputs for descriptive summaries. |
| `arm_title` | `safety_df.csv` | Adverse-event trial arm label | Combined with `nct_id` to create `trial_arm_id`. |
| `sub_title` | `safety_df.csv` | Adverse-event term | Lowercased and renamed `ae_name`. |
| `category` | `safety_df.csv` | Adverse-event category | Lowercased and renamed `ae_category`. |
| `events`, `affected`, `at_risk` | `safety_df.csv` | Event count, affected participant count, and arm denominator | `events` and `at_risk` drive derived summaries. |

## Derived Variables

| Variable | Meaning | Derivation |
| --- | --- | --- |
| `trial_arm_id` | Composite trial-arm key | `nct_id + "-" + arm_title` |
| `per_arm_ae_num` | Within-arm adverse-event row number | Generated within `trial_arm_id`; regenerated after filtering. |
| `hypovent_ae` | Definite hypercapnia-related adverse-event row flag | Text rules on `ae_name`, including capnia/hypercarbia/hypoventilation/respiratory acidosis/respiratory depression/type 2 respiratory failure and selected non-sleep apnea terms. |
| `pos_hypovent_ae` | Possible hypercapnia-related adverse-event row flag | Text rules on less-specific terms, including respiratory arrest, ventilator dependence, and chronic respiratory failure variants. |
| `hypovent_events` | Definite event count on flagged rows | `events` if `hypovent_ae == 1`. |
| `pos_hypovent_events` | Possible event count on flagged rows | `events` if `pos_hypovent_ae == 1`. |
| `hypovent_ae_in_arm` | Arm-level definite flag | Maximum `hypovent_ae` within `trial_arm_id`. |
| `pos_hypoven_ae_in_arm` | Arm-level possible flag | Maximum `pos_hypovent_ae` within `trial_arm_id`; legacy spelling omits the `t` in `hypovent`. |
| `num_hypovent_ae_in_arm` | Arm-level definite event total | Sum of `hypovent_events` within `trial_arm_id`. |
| `num_pos_hypoven_ae_in_arm` | Arm-level possible event total | Sum of `pos_hypovent_events` within `trial_arm_id`; legacy spelling preserved. |
| `n_in_arm` | Trial-arm denominator | Maximum `at_risk` within `trial_arm_id`. |
| `n_in_trial` | Trial denominator | Sum of first-row arm denominators within `nct_id`. |
| `hypovent_ae_in_trial` | Trial-level definite flag | Maximum `hypovent_ae` within `nct_id`. |
| `pos_hypoven_ae_in_trial` | Trial-level possible flag | Maximum `pos_hypovent_ae` within `nct_id`; legacy spelling preserved. |
| `num_hypovent_ae_in_trial` | Trial-level definite event total | Sum of arm-level definite event totals within `nct_id`. |
| `num_pos_hypoven_ae_in_trial` | Trial-level possible event total | Sum of arm-level possible event totals within `nct_id`; legacy spelling preserved. |
| `data_source` | Merge category | Renamed from `_merge_trials`: `1 = Adverse Event Only`, `2 = Efficacy Only`, `3 = Both`. |

## Generated Artifacts

| Artifact | Default path after local run | Purpose |
| --- | --- | --- |
| `trials_data.dta` | `outputs/stata/derived/trials_data.dta` | Intermediate trial metadata dataset. |
| `ae_by_arm_data.dta` | `outputs/stata/derived/ae_by_arm_data.dta` | Merged adverse-event and trial metadata before hypercapnia filtering. |
| `by_arm_data.dta` | `outputs/stata/derived/by_arm_data.dta` | Filtered arm-level derived dataset. |
| `by_trial_data.dta` | `outputs/stata/derived/by_trial_data.dta` | Trial-level derived dataset. |
| `by arm data.xlsx` | `outputs/stata/exports/by arm data.xlsx` | Arm-level Excel export. |
| `by trial data.xlsx` | `outputs/stata/exports/by trial data.xlsx` | Trial-level Excel export. |
| `temp.log` | `outputs/stata/<date>/Logs/temp.log` | Stata run log. |

Generated datasets, logs, and exports should remain local and ignored. Recreate them from the public source data rather than committing them.

## Review Flags

- Several source variables have `needs_review` status in the CSV because the exact source schema should be verified against the Du and Shi documentation before formal data reuse.
- The `pos_hypoven_*` spelling is a legacy code spelling. It is documented intentionally so downstream users can find the variables produced by the current workflow.
- Adverse-event term rules are code-defined and were used for the CHEST abstract. Review and version the rules before using the workflow for a new manuscript or policy-facing analysis.
