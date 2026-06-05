# Hypercapnic Respiratory Failure Adverse Events In Clinical Trials

This is an author-owned summary of the CHEST 2024 abstract and poster:

Anderson-Bell D, Locke BW. Hypercapnic respiratory failure is infrequently reported as an adverse event in clinical trials. CHEST. 2024;166(4):A5688. doi: [10.1016/j.chest.2024.06.3377](https://doi.org/10.1016/j.chest.2024.06.3377)

## Study Question

The project examined how often hypercapnic respiratory failure and related adverse-event terms are reported in structured ClinicalTrials.gov results. The motivation was that trial adverse-event reporting may not consistently capture ventilatory failure, hypoventilation, respiratory depression, or type 2 respiratory failure even when these outcomes are clinically relevant.

## Data Source

The analysis used the ClinicalTrials.gov structured results dataset curated by Du and Shi:

- Source paper: [10.1038/s41597-023-02869-7](https://doi.org/10.1038/s41597-023-02869-7)
- Figshare collection: [10.6084/m9.figshare.c.6860254.v1](https://doi.org/10.6084/m9.figshare.c.6860254.v1)

The repository Stata workflow reads the `efficacy_df.csv` and `safety_df.csv` files from that public dataset and derives trial-level and trial-arm-level indicators for definite and possible hypercapnia-related adverse-event terms.

## Methods Summary

The analysis flagged adverse-event terms that appeared consistent with definite hypercapnia, hypoventilation, respiratory depression, or related ventilatory failure. It also flagged possible hypercapnia-related terms that could reflect respiratory failure or ventilatory dependence but may be less specific. Results were summarized at the trial-arm and trial levels.

## Poster Results Summary

The CHEST poster reported that hypercapnia-related adverse events were uncommon in structured trial reporting:

- 6,429 finished trials included 4,863,170 participants.
- 5,300 unfinished trials included 4,097,827 participants.
- At least one definite hypercapnia-related adverse event was present in 242 completed trials and 139 unfinished trials.
- At least one possible hypercapnia-related adverse event was present in 663 completed trials and 355 unfinished trials.
- The poster reported 815 definite and 3,539 possible hypercapnia-related events in the analyzed reporting structure.

These values are historical abstract/poster results and should be reproduced from the current workflow before being reused in a new manuscript or analysis.

## Funding And Disclosure

Funding/support listed on the poster: ASPIRE Fellowship, NIH NRSA `5T32HL105321`, and Intermountain Fund support for Brian W. Locke. Disclosure listed on the poster: Brian W. Locke has ownership in Mountain Biometrics, unrelated to this project.

## Repository Relationship

This repository is the code and public-presentation repository for the abstract/poster. It is not a full manuscript repository and does not contain publisher article text.
