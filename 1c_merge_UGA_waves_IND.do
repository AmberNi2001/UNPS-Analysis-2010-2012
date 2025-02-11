/*******************************************************************************
Program:    	1c_merge_ULFP_waves_IND.do
Note:			This file appends individual-level variables from Waves 1 and 2 of ULFP
Author:     	Jessie Hu
*******************************************************************************/

*Merging two waves*
	use "$OUT/ugaIND_data_2010-2011.dta", clear
	append using "$OUT/ugaIND_data_2011-2012"

*Label data*
	lab var sex "Sex"
	lab var married "Marital Status"
	lab var age "Age"
	lab var region_born "Region Born In"
	lab var region_lived "Region Lived In (Before Moving tu Current Region)"
	lab var lived_urban "Was Place Lived In Urban or Rural"
	lab var camp "If Lived in Camp in Past 5 Years"
	lab var readwrite "Ability to Read or/and Write"
	lab var formal_edu "Attendance of any Formal School"
	lab var highest_edu "Highest Level of Education Completed"
	lab var employed "Employment Status"
	lab var wave "Wave"

*Organiza data*
	lab data "Individual-level variables from from Waves 1 and 2 of Uganda National Panel Survey from 2010 to 2012"
	order HHID PID wave 
	save "$OUT/uga_all_individuals", replace
