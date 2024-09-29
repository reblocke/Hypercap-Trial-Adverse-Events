// Code to explore the clinical trials gov database processing
// Codeset described in https://www.nature.com/articles/s41597-023-02869-7 

clear

/* Location of Data */ 

cd "/Users/blocke/Box Sync/Residency Personal Files/Scholarly Work/Locke Research Projects/Hypercap-Trial-Adverse-Events" //mac 
//cd "C:\Users\reblo\Box\Residency Personal Files\Stats\Clinical Trials Processed" //windows


program define datetime 
end

/* Generate locations for figures and back-up log files for when I forget to save */ 
capture mkdir "Results and Figures"
capture mkdir "Results and Figures/$S_DATE/" //make new folder for figure output if needed
capture mkdir "Results and Figures/$S_DATE/Logs/" //new folder for stata logs
local a1=substr(c(current_time),1,2)
local a2=substr(c(current_time),4,2)
local a3=substr(c(current_time),7,2)
local b = "ClinicalTrialsGov.do" // do file name
copy "`b'" "Results and Figures/$S_DATE/Logs/(`a1'_`a2'_`a3')`b'"

set scheme cleanplots
graph set window fontface "Helvetica"

capture log close
log using "Results and Figures/$S_DATE/Logs/temp.log", append


/* Currently unused data */ 
//import delimited using "Data/csv/ade_sample.csv"
//import delimited using "Data/csv/efficacy_sample.csv"

clear 
import delimited using "Data/csv/efficacy_df.csv"

/* Data cleaning */ 
destring completion_year enrollment_num ci_lower_limit ci_upper_limit, replace force
drop if strpos(study_type, "Interventional") == 0 //all the other ones appear to be junk

/* 
This drops all the data on individual arms, for the purpose of utilizing this 
information for the adverse effects. 
*/ 

//Code to make this a str 11 instead of a strl (= variable length) for merging
gen nct_id2 = ustrtrim(nct_id)
drop nct_id 
rename nct_id2 nct_id

quietly levelsof nct_id, local(unique_nct_ids)
display "Number of unique nct_id values in the efficacy spreadsheet: " `: word count `unique_nct_ids''

sort nct_id
by nct_id: gen arm_outcome_num = _n
keep if arm_outcome_num == 1 // only keep the first arm 

summarize enrollment_num, meanonly
display "Total number of patients included: " r(sum)


/*
//Info on Different Conditions in the data-base. Currently not used. 
//tab condition if strpos(condition, "Respiratory") > 0, plot sort 
//tab intervention if condition == "['Asthma']", plot sort 
//the below command grabs each one the contains Asthma anywhere within
tab intervention if strpos(condition, "Asthma") > 0, plot sort
tab label if strpos(condition, "Asthma") > 0, plot sort 
tab intervention_value if strpos(condition, "Asthma") > 0, plot sort 
tab funder_type if strpos(condition, "Asthma") > 0, plot sort 
tab completion_year if strpos(condition, "Asthma") > 0, plot

tab condition if strpos(condition, "Obesity") > 0, plot sort 
tab funder_type if strpos(condition, "Obesity") > 0, plot sort 
tab completion_year if strpos(condition, "Obesity") > 0, plot

tab condition if strpos(condition, "Sleep") > 0, plot sort 
//TODO: compare sizes of trials on different conditions - would probably want this to be log scale; maybe kdensity
hist enrollment_num if strpos(condition, "Asthma") > 0
hist enrollment_num if  strpos(condition, "Sleep") > 0
hist enrollment_num if  strpos(condition, "Obesity") > 0
*/ 

//drop all columns not to be used for now. 
tab info, missing
drop study_type outcome_id info outcome_type outcome_title p_value method method_desc ci_percent ci_n_sides ci_lower_limit ci_upper_limit param_type param_value split_p p_split label ci_lower_limit_clean ci_upper_limit_clean mesh_terms_mti mapped_mesh_terms tree_level_0 intervention_dict comparator_dict intervention_group intervention_value intervention_similarity comparator_group comparator_value comparator_similarity v1 arm_outcome_num 


/* compare trial types */

save trials_data, replace

clear 
import delimited using "Data/csv/safety_df.csv"

//Data cleaning: 
replace category = lower(category)
replace sub_title = lower(sub_title)

quietly levelsof nct_id, local(unique_nct_ids)
display "Number of unique nct_id values in the AE spreadsheet: " `: word count `unique_nct_ids''

//convert to strl11
gen nct_id2 = ustrtrim(nct_id)
drop nct_id 
rename nct_id2 nct_id

drop v1 similarity edge_type ratio seriousother //junk variables

rename sub_title ae_name 
rename category ae_category
gen trial_arm_id = nct_id + "-" + arm_title

sort trial_arm_id
by trial_arm_id: gen per_arm_ae_num = _n

// Definitive - Hypercapnia / Hypoventilation / Respiratory Depression 

// # Trial arms looking various forms of hypoventilation 
gen hypovent_ae = 0 
tab ae_name if strpos(ae_name, "respiratory insufficiency") > 0, plot sort  //16 trial arms
replace hypovent_ae = 1 if strpos(ae_name, "respiratory insufficiency") > 0
tab ae_name if strpos(ae_name, "depressed respiration") > 0, plot sort  //1
replace hypovent_ae = 1 if strpos(ae_name, "depressed respiration") > 0
tab ae_name if strpos(ae_name, "capni") > 0, plot sort  //140
replace hypovent_ae = 1 if strpos(ae_name, "capni") > 0
tab ae_name if strpos(ae_name, "hypercarb") > 0, plot sort  //2
replace hypovent_ae = 1 if strpos(ae_name, "hypercarb")
tab ae_name if strpos(ae_name, "hypovent") > 0, plot sort  //50
replace hypovent_ae = 1 if strpos(ae_name, "hypovent")
tab ae_name if strpos(ae_name, "respiratory acidosis") > 0, plot sort  //141
replace hypovent_ae = 1 if strpos(ae_name, "respiratory acidosis")
tab ae_name if (strpos(ae_name, "respiratory") > 0 & strpos(ae_name, "depression") > 0), plot sort // e.g. respiratory depression 85
replace hypovent_ae = 1 if (strpos(ae_category, "respiratory") > 0 & strpos(ae_name, "depression") > 0)
tab ae_name if strpos(ae_name, "type 2 respiratory failure") > 0, plot sort  //2
replace hypovent_ae = 1 if strpos(ae_name, "type 2 respiratory failure")
tab ae_name if strpos(ae_name, "respiratory muscle weakness") > 0, plot sort  //3
replace hypovent_ae = 1 if strpos(ae_name, "respiratory muscle weakness")
tab ae_name if (strpos(ae_name, "sleep") == 0 & strpos(ae_name, "apnea") > 0), plot sort // non-sleep apnea 36
replace hypovent_ae = 1 if (strpos(ae_name, "sleep") == 0 & strpos(ae_name, "apnea") > 0)
tab ae_name if (strpos(ae_name, "sleep") == 0 & strpos(ae_name, "apnoea") > 0), plot sort // non-sleep apnea 108
replace hypovent_ae = 1 if (strpos(ae_name, "sleep") == 0 & strpos(ae_name, "apnoea") > 0)
tab ae_name if (strpos(ae_name, "sleep") == 0 & strpos(ae_name, "hypopnoea") > 0), plot sort // non-sleep apnea 2
replace hypovent_ae = 1 if (strpos(ae_name, "sleep") == 0 & strpos(ae_name, "hypopnoea") > 0)

// Possible - Hypercapnia / Hypoventilation / Respiratory Depression 
gen pos_hypovent_ae = 0 
tab ae_name if strpos(ae_name, "acute repiratory failure") > 0, plot sort  //1
replace pos_hypovent_ae = 1 if strpos(ae_name, "acute repiratory failure") > 0
tab ae_name if strpos(ae_name, "respiratory arrest") > 0, plot sort  //1592 trial arms
replace pos_hypovent_ae = 1 if strpos(ae_name, "respiratory arrest") > 0
tab ae_name if strpos(ae_name, "respiratory status compromised") > 0, plot sort  //
replace pos_hypovent_ae = 1 if strpos(ae_name, "respiratory status compromised") > 0
tab ae_name if strpos(ae_name, "respiratory failure -other") > 0, plot sort  //
replace pos_hypovent_ae = 1 if strpos(ae_name, "respiratory failure -other") > 0
tab ae_name if strpos(ae_name, "respiratory failure -copd") > 0, plot sort  //
replace pos_hypovent_ae = 1 if strpos(ae_name, "respiratory failure -copd") > 0
tab ae_name if strpos(ae_name, "failure respiratory") > 0, plot sort  //
replace pos_hypovent_ae = 1 if strpos(ae_name, "failure respiratory") > 0
tab ae_name if strpos(ae_name, "dependence on respirator") > 0, plot sort  //
replace pos_hypovent_ae = 1 if strpos(ae_name, "dependence on respirator") > 0
tab ae_name if strpos(ae_name, "dependence on ventilator") > 0, plot sort  //
replace pos_hypovent_ae = 1 if strpos(ae_name, "dependence on ventilator") > 0
tab ae_name if strpos(ae_name, "chronic respiratory failure") > 0, plot sort  //
replace pos_hypovent_ae = 1 if strpos(ae_name, "chronic respiratory failure") > 0
tab ae_name if strpos(ae_name, "chronic respitory failure") > 0, plot sort  //
replace pos_hypovent_ae = 1 if strpos(ae_name, "chronic respitory failure") > 0

tab ae_name if hypovent_ae == 1, sort
tab ae_name if pos_hypovent_ae == 1, sort

//Generate info on which trial arms reported any hypovent adverse effects 
bysort trial_arm_id: egen hypovent_ae_in_arm = max(hypovent_ae)
bysort trial_arm_id: egen pos_hypoven_ae_in_arm = max(pos_hypovent_ae)
gen hypovent_events = events if hypovent_ae == 1
bysort trial_arm_id: egen num_hypovent_ae_in_arm = total(hypovent_events) 

//sort trial_arm_id
list trial_arm_id events hypovent_ae num_hypovent_ae_in_arm if hypovent_ae == 1

gen pos_hypovent_events = events if pos_hypovent_ae == 1
bysort trial_arm_id: egen num_pos_hypoven_ae_in_arm = total(pos_hypovent_events)


//Generate info on the number of patients in each arm and trial
bysort trial_arm_id: egen n_in_arm = max(at_risk)
bysort nct_id: egen temp_n_in_trial = sum(n_in_arm) if per_arm_ae_num == 1 
bysort nct_id: egen n_in_trial = max(temp_n_in_trial) 
list nct_id arm_title at_risk n_in_arm temp_n_in_trial n_in_trial in 1/200
drop temp_n_in_trial

//Generate info on which trials reported any hypovent adverse events in any of their arms
bysort nct_id: egen hypovent_ae_in_trial = max(hypovent_ae)
bysort nct_id: egen pos_hypoven_ae_in_trial = max(pos_hypovent_ae)

//Merge data from trials data
merge m:1 nct_id using trials_data, update generate(_merge_trials) force

//Why so many missing from the efficacy document? 
quietly levelsof nct_id, local(unique_nct_ids)
display "Number of unique nct_id values in the combined spreadsheet: " `: word count `unique_nct_ids''

quietly levelsof nct_id if _merge_trials == 1, local(unique_nct_ids_only_ae)
display "Number of trials only reporting AE: " `: word count `unique_nct_ids_only_ae''

quietly levelsof nct_id if _merge_trials == 2, local(unique_nct_ids_only_eff)
display "Number of trials only reporting efficacy: " `: word count `unique_nct_ids_only_eff''

quietly levelsof nct_id if _merge_trials == 3, local(unique_nct_ids_both)
display "Number of trials reporting both AE and efficacy: " `: word count `unique_nct_ids_both''

rename _merge_trials data_source
label define data_source_lab 1 "Adverse Event Only" 2 "Efficacy Only" 3 "Both"
label values data_source data_source_lab

sort hypovent_ae_in_trial pos_hypoven_ae_in_trial

drop if data_source == 2 // drop trials with only efficacy data 

//Export

save ae_by_arm_data, replace
//export excel using "ae by arm data.xlsx", firstrow(varlabels) keepcellfmt replace 
use ae_by_arm_data, clear
// Split into a "by trial dataset" and a "by-arm" dataset for later use

summarize events, meanonly
display "Total number of reported adverse events: " r(sum)


drop if hypovent_ae_in_arm != 1 & pos_hypoven_ae_in_arm != 1

quietly levelsof trial_arm_id, local(unique_trial_arm_ids)
display "Number of unique trial_arm_id values: " r(r)

drop per_arm_ae_num
bysort trial_arm_id: gen per_arm_ae_num = _n
drop if per_arm_ae_num != 1
summarize num_hypovent_ae_in_arm if hypovent_ae_in_arm, detail
display "Total number of hypercapnia AEs: " r(sum) //815

summarize num_pos_hypoven_ae_in_arm if pos_hypoven_ae_in_arm, detail
display "Total number of pos hypercapnia AEs: " r(sum)

gen hypovent_ae_name = ae_name if hypovent_ae == 1 | pos_hypovent_ae == 1
drop ae_name
rename hypovent_ae_name ae_name

drop per_arm_ae_num // regenerate duplicates now with only hypovent AEs
sort trial_arm_id
by trial_arm_id: gen per_arm_ae_num = _n

reshape wide ae_name ae_category affected at_risk events hypovent_ae pos_hypovent_ae, i(trial_arm_id) j(per_arm_ae_num) 

tab arm_title if hypovent_ae_in_arm == 1, sort missing
tab arm_title if pos_hypoven_ae_in_arm == 1, sort missing

tab condition if hypovent_ae_in_arm == 1, sort missing
tab condition if pos_hypoven_ae_in_arm == 1, sort missing

summarize num_hypovent_ae_in_arm if hypovent_ae_in_arm == 1, detail
display "Total number of hypercapnia AEs: " r(sum)

summarize num_pos_hypoven_ae_in_arm if pos_hypoven_ae_in_arm == 1, detail
display "Total number of pos hypercapnia AEs: " r(sum)

//TODO: num aes by trial 
bysort nct_id: egen num_hypovent_ae_in_trial = total(num_hypovent_ae_in_arm) 
bysort nct_id: egen num_pos_hypoven_ae_in_trial = total(num_pos_hypoven_ae_in_arm) 

save by_arm_data, replace

preserve
keep arm_title nct_id hypovent_ae_in_arm pos_hypoven_ae_in_arm num_hypovent_ae_in_arm num_pos_hypoven_ae_in_arm n_in_arm n_in_trial hypovent_ae_in_trial num_hypovent_ae_in_trial pos_hypoven_ae_in_trial num_pos_hypoven_ae_in_trial completion_year trial_phase funder_type condition_mesh condition 
export excel using "by arm data.xlsx", firstrow(varlabels) keepcellfmt replace 
restore

keep allocation age all_inters completion_year enrollment_num countries condition_mesh condition funder_name funder_type groups intervention_mesh intervention_type intervention nct_id n_in_trial pos_hypoven_ae_in_trial num_pos_hypoven_ae_in_trial hypovent_ae_in_trial num_hypovent_ae_in_trial trial_phase

duplicates report
duplicates drop


//total trials 

summarize num_hypovent_ae_in_trial, detail
display "Total number of hypercapnia AEs: " r(sum)

summarize num_pos_hypoven_ae_in_trial, detail
display "Total number of pos hypercapnia AEs: " r(sum)

save by_trial_data, replace
export excel using "by trial data.xlsx", firstrow(varlabels) keepcellfmt replace 

summarize n_in_trial, meanonly
display "Total number of patients included: " r(sum)

tab hypovent_ae_in_trial

summarize n_in_trial if hypovent_ae_in_trial == 1, meanonly
display "Total number of patients in trials with hypovent AE: " r(sum)

tab pos_hypoven_ae_in_trial

summarize n_in_trial if pos_hypoven_ae_in_trial == 1, meanonly
display "Total number of patients in trials with pos hypovent AE: " r(sum)



// Calculate Summary Statistics for ALL trials, not just those reporting efficacy outcomes: 

use ae_by_arm_data, clear

keep nct_id n_in_trial hypovent_ae_in_trial pos_hypoven_ae_in_trial data_source
duplicates report
duplicates drop

summarize n_in_trial, meanonly
display "Total number of patients in trials reporting adverse events: " r(sum)

summarize n_in_trial if data_source == 1, meanonly
display "Total number of patients in trials only reporting adverse events: " r(sum)

summarize n_in_trial if data_source == 3, meanonly
display "Total number of patients in trials reporting adverse events and efficacy: " r(sum)









