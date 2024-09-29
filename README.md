# Hypercap Trial Adverse Events
 Code analysis for CHEST Abstract and possible future comparison to VAERS database rates. 

ipynb files are the unifinished FAERS analayisis. 

ClinicalTrialGov.do is the stata file for the main analysis. 

must replace '/Users/blocke/Box Sync/Residency Personal Files/Scholarly Work/Locke Research Projects/Hypercap-Trial-Adverse-Events/' with the directory where you download the folder to. 


You also must extract the data from Du and Shi (2024) Sci Data - https://doi.org/10.6084/m9.figshare.c.6860254.v1 [paper @ https://www.nature.com/articles/s41597-023-02869-7 ] into the Data folder such that there is the following structure: 

/<your pathname>/Data

├── biobert_validation.xlsx

├── csv

│   ├── ade_sample.csv

│   ├── efficacy_df.csv

│   ├── efficacy_sample.csv

│   └── safety_df.csv

├── json

│   ├── ade_sample.json

│   ├── efficacy_df.json

│   ├── efficacy_sample.json

│   └── safety_df.json

└── pickle

    ├── efficacy_df.pickle

    └── safety_df.pickle


4 directories, 11 files


the code currently uses the .csv files but will likely be updated to use the json files in the future. 
there is currently a zip file that contains the needed csv files (Data.csv) that can be used for easy access (just unzip it in the working folder)