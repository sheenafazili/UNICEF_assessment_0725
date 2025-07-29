*******************************************
* UNICEF ASSESSMENT FOR THE BELOW ROLES : 
* Household Survey Data Analyst Consultant
* Microdata Harmonization Consultant
* 
*	 TASK: Data Cleaning and Analysis     *
* 			DATE: July 28th, 2025		  *	
*******************************************


**********************
* Importing raw data *
**********************


** 1. Importing Population data 
import excel "$raw/WPP2022_GEN_F01_DEMOGRAPHIC_INDICATORS_COMPACT_REV1.xlsx", sheet("Estimates") cellrange(A17:BM20613) firstrow clear

tempfile dataset1

** 1.1. Cleaning variables

rename *, lower
rename regionsubregioncountryorar countryname
rename iso3alphacode countrycode

** 1.2. Saving as temp file to merge later

save `dataset1', replace


** 2. Importing under-five mortality classification

import excel "$raw/On-track and off-track countries.xlsx", sheet("Sheet1") firstrow clear

tempfile dataset2

** 2.1. Cleaning variables

rename *, lower
rename iso3code countrycode
rename officialname countryname

** 2.2. Saving as temp file to merge later

save `dataset2', replace

** 3. Importing ANC4 and SBA

import excel "$raw/GLOBAL_DATAFLOW_2018-2022.xlsx", sheet("Unicef data") firstrow clear

tempfile dataset3

** 3.1. Cleaning variables

rename *, lower
rename geographicarea countryname
rename time_period year
destring year, replace
drop if missing(countryname)

** 3.2. Saving as temp file to merge later

save `dataset3', replace

** 4. Importing Population Projection data 
import excel "$raw/WPP2022_GEN_F01_DEMOGRAPHIC_INDICATORS_COMPACT_REV1.xlsx", sheet("Projections") cellrange(A17:BM20613) firstrow clear

tempfile dataset4

** 4.1. Cleaning variables

rename *, lower
rename regionsubregioncountryorar countryname
rename iso3alphacode countrycode

keep if year == 2022
keep countrycode countryname year birth*
duplicates drop countrycode, force

** 4.2. Saving as temp file to merge later

save `dataset4', replace

********************
* Merging datasets *
********************

use `dataset1', clear
merge m:1 countryname year using `dataset4', gen(m3)
merge m:1 countrycode using `dataset2', gen(m1)
keep if year >=2018 & year <=2022

keep if m1 == 3 | year == 2022 //keeping observations with countrycode 
drop if missing(countrycode)
isid countrycode year //confirming data is unique by country year

merge m:m countryname using `dataset3', gen(m2)
keep if m2 == 3 | year == 2022 //keeping observations from the primary indicators dataset with a country code, meaning regional level observations are dropped to ensure data is at country level and data from projections to be used for birth projections in 2022

drop m1 m2 m3

************
* Analysis *
************

* Create and label dummy for on and off track 

gen ontrack = .
replace ontrack = 1 if inlist(statusu5mr, "Achieved", "On Track")
replace ontrack = 0 if inlist(statusu5mr, "Acceleration Needed")

label define ontrack 1 "On-track" 0 "Off-track"
label value ontrack ontrack

* Create dummy variables for SBA and ANC4

gen sba = obs_value if indicator == "Skilled birth attendant - percentage of deliveries attended by skilled health personnel"
gen anc4 = obs_value if indicator == "Antenatal care 4+ visits - percentage of women (aged 15-49 years) attended at least four times during pregnancy by any provider"

* Converting all relavant variables to numeric
destring totalpopulationasof1july, replace
destring sba, replace
destring anc4, replace
destring birthsthousands, replace
save "$output/clean_data.dta", replace

* Creating population weighted averages for on track vs off track groups

preserve
collapse (mean) sba anc4 [pw=totalpopulationasof1july], by(ontrack)
save "$output/population-weighted indicators.dta", replace
restore






