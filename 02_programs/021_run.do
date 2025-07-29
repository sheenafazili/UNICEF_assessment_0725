*******************************************
* UNICEF ASSESSMENT FOR THE BELOW ROLES : 
* Household Survey Data Analyst Consultant
* Microdata Harmonization Consultant
* 
*	 		TASK: Master Run File     *
* 			DATE: July 28th, 2025		  *	
*******************************************

* Setting up paths

global path "/Users/irfaanhafeez/Documents/GitHub/UNICEF_assessment_0725"
global raw "$path/01_rawdata"
global do "$path/02_programs"
global output "$path/03_output"

*************************************************
/* Installing commands needed for analysis/checks
*************************************************

ssc install fre, replace
ssc install blindschemes, replace all
ssc install whereis
*/

* Run files in the following sequence:

* 022 Cleaning and Analysis

do "$do/022_cleaning.do"

* 023 Generating Outputs

do "$do/023_output.do"
