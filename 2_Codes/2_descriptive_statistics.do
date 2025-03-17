/*******************************************************************************
Program:    	2_descriptive_statistics.do
Note:			This file generates descriptive statistics for Uganda National Panel Survey Waves 1 and 2 from 2010-2011 to 2011-2012
Author:     	Amber Ni & Jessie Hu
*******************************************************************************/

*** Summary statistics at the individual level
 use "$OUT/uga_all_individuals", clear
 
	summarize
	describe
	describe, short
	codebook, compact
	codebook sex
	codebook married
	codebook age
	codebook region_born
	codebook region_lived
	codebook lived_urban
	codebook camp
	codebook readwrite
	codebook formal_edu
	codebook highest_edu
	codebook employed
	*summary statistics for variables that only appeared in wave 1*
		codebook vision_impair
		codebook mobility_impair
		codebook hearing_impair
		codebook concen_impair
		codebook selfcare_impair
		codebook comms_impair 

* Summary table by year	
	*Demographic variables*
	forvalues i =1/2{
		di "Wave = " `i'
		su sex married age region_born region_lived lived_urban camp if wave== `i'
	}	
	
	*Education variables*
		forvalues i =1/2{
		di "Wave = " `i'
		su readwrite formal_edu highest_edu if wave== `i'
	}	
	
	*Labor variable (variable of interest)
	forvalues i =1/2{
		di "Wave = " `i'
		su employed if wave== `i'
	}	


* Summary table by variable*
	*Demographic variables*
	foreach i of varlist sex married age region_born region_lived lived_urban camp {
		di "Variable = " "`i'" ", Wave=1"
		su `i' if wave== 1
		
		di "Variable = " "`i'" ", Wave=2"
		su `i' if wave== 2
	}
	
	*Education variables*
	foreach i of varlist readwrite formal_edu highest_edu {
		di "Variable = " "`i'" ", Wave=1"
		su `i' if wave== 1
		
		di "Variable = " "`i'" ", Wave=2"
		su `i' if wave== 2
	}
	
	*Labor variable (variable of interest)*
	foreach i of varlist employed {
		di "Variable = " "`i'" ", Wave=1"
		su `i' if wave== 1
		
		di "Variable = " "`i'" ", Wave=2"
		su `i' if wave== 2
	}


*** Summary statistics at the household level
	use "$OUT/uga_all_households", clear
		destring HHID, replace
		xtset HHID wave
		xtdescribe
		codebook hh** depRatio region urban elec room hand logged_water meals ypce ypceLn poor if wave == 1, c
		codebook hh** depRatio region urban elec room hand logged_water meals ypce ypceLn poor if wave  == 2, c
		
		ssc install asdoc
		asdoc summarize hhsiz hhMeanAge hhMeanEduYrs hhhSex hhhMarital hhhAge hhhHighest~u ///
           hhhEduYrs depRatio region urban elec room_count handwash_t~t ///
           logged_water meals_day ypce ypceLn poor if wave == 1, save($OUT/des_stats_w1.doc) replace
		asdoc summarize hhsiz hhMeanAge hhMeanEduYrs hhhSex hhhMarital hhhAge hhhHighest~u ///
           hhhEduYrs depRatio region urban elec room_count handwash_t~t ///
           logged_water meals_day ypce ypceLn poor if wave == 2, save($OUT/des_stats_w2.doc) replace

