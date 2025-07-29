*******************************************
* UNICEF ASSESSMENT FOR THE BELOW ROLES : 
* Household Survey Data Analyst Consultant
* Microdata Harmonization Consultant
* 
*	 	TASK: Data Visualization    	  *
* 		DATE: July 28th, 2025		      *	
*******************************************

* Calling on dataset created in 012

use "$output/population-weighted indicators.dta", clear

* Generating a document

putdocx begin

putdocx paragraph, style(Heading1) // Or choose other styles like Heading1, etc.
putdocx text ("UNICEF Assessment - July 2025"), linebreak
putdocx text ("Household Survey Data Analyst Consultant"), linebreak
putdocx text ("Microdata Harmonization Consultant"), linebreak
putdocx text (""), linebreak
putdocx text ("Analysing Differences Between On Track and Off Track Countries Outcomes"), linebreak


* Creating visualizations

** Rounding variables for cleaner look
local vars sba anc4

foreach var in `vars' {
	replace `var' = round(`var', 0.1)
}

** Choosing color bling friendly scheme
set scheme plotplain 

** Creating graph for 2 groups
graph hbar sba anc4, by(ontrack) blabel(bar) legend(label(1 " % of deliveries attended by skilled health personnel") label(2 "% of women (aged 15–49) with at least 4 antenatal care visits"))

graph export visual.png, replace
putdocx image visual.png

putdocx text ("The share of deliveries attended by skilled workers were substantially more among countries that showed positive progress in being on track for Under-five mortality classification. A similar trend is seen among those share of women with at leaste 4 antenal visits."), linebreak
putdocx text ("Note: 1. These estimates are weighted using population data from July and may show some variation with population estimates from january. 2. This data does not combine birth projections for 2022 as combining weights from projections and actual population data is complex and requires deeper analytical testing not suitable for the limited time frame of the assessment. If the two were to be comnined, they would be multiplied to be used as a single weight.")
				
putdocx save "$output/Output.docx", replace

putdocx clear
