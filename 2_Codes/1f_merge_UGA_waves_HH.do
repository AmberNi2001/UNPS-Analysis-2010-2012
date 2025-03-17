/*******************************************************************************
Program:    	1f_merge_LSMS_waves_HH.do
Note:			This file appends household-level variables from Waves 1 and 2 of Uganda National Panel Survey from 2010 to 2012 
Author:     	Amber Ni
*******************************************************************************/
	* append cleaned datasets from two waves to one dataset 
	use "$OUT/ugaHH_data_2010-2011", clear
	append using "$OUT/ugaHH_data_2011-2012"
	drop head
	
	* Label variables
		lab var hhsize "Household size"
		lab var hhMeanAge  "Mean age of HH members"
		lab var depRatio "Dependency ratio"
		lab var hhMeanEduYrs "Mean years of education in HH"
		lab var hhhSex "Sex of HH head"
		lab var hhhAge "Age of HH head"
		lab var hhhEduYrs "Years of education of HH head"
		lab var hhhHighestEdu "Highest education received of HH head"
		lab var logged_water "How many litres of water do your household use per per day (logged)"
		lab var ypce "Real per capita household consumption yearly"
		lab var ypceLn "Real per capita household consumption yearly, log"
		lab var poor "Household is poor under the 25th percentile poverty line"
		
	* label the dataset
	lab data "Household-level variables from from Waves 1 and 2 of Uganda National Panel Survey from 2010 to 2012"
	order HHID PID wave // reorder variables 
	save "$OUT/uga_all_households", replace
	