/*******************************************************************************
Program:    	1b_merge_ULFP2_IND.do
Note:			This file merges all the relevant individual-level variables in ULFP Wave 2
Author:     	Jessie Hu
*******************************************************************************/

***********************************************************************************
* Demographics 1 (GSEC2)*
***********************************************************************************
	use "$WAVE2/GSEC2.dta", clear
	ren (h2q3 h2q10 h2q4)(sex married head)
	drop if h2q9c > 1998 | h2q9c < 1900
	gen age = 2012-h2q9c
	label drop df_MARITALSTATUS df_GENDER
	recode sex (2=0)
	label define df_GENDER 1"Male" 0"Female"
	recode married (5=0)(3=0)(4=0)(1=1)(2=2)
	drop if married > 2 
	label define df_MARITALSTATUS 0 "Not Married" 1 "Married Monogamously" 2 "Married Polygamously"
	keep HHID PID sex married age head
	tempfile ulfp2ind
	save `ulfp2ind', replace

***********************************************************************************
* Demographics 2 (GSEC 3)*
***********************************************************************************
	use "$WAVE2/GSEC3.dta", clear
	ren (h3q13_1 h3q16_1 h3q17 h3q20) (region_born region_lived lived_urban camp)
	label drop H3Q17 H3Q20
	recode lived_urban(2=1)(3=0)
	label define H3Q17 1"Urban" 0"Rural"
	recode camp (2=0)
	label define H3Q20 0"No"
	keep HHID PID region_born region_lived lived_urban camp
	tempfile section3
	save`section3', replace

***********************************************************************************
* Education (GSEC 4)*
***********************************************************************************
	use "$WAVE2/GSEC4.dta", clear
	ren (h4q4 h4q5 h4q7)(readwrite formal_edu highest_edu)
	gen eduYrs = highest_edu
	recode eduYrs (2=2) (10=0) (11=1) (12=2) (13=3) (14=4) (15=5) (16=6) (17=7) (21=8) ///
			(22=9) (23=10) (31=11) (32=12) (33=13) (34=14) (35=15) (36=16) (99=.) ///
			(41=8) (51=11) (61=17)
	label drop df_READWRITE df_ATTENDSCHOOL  df_HIGHEDULEVEL df_YN  
	recode readwrite (1=0) (2=1) (3=2) (4=3)
	lab define df_READWRITE 0 "Unable to read and write" 1"Able to read only" 2"Able to write only" 3"Able to read and write"
	recode formal_edu (1=0) (2=1) (3=1)
	lab define df_ATTENDSCHOOL 0 "Never attended" 1"Have attended"
	recode highest_edu (10=0) (11=1) (12=1) (13=1)(14=1)(15=1)(16=1)(17=2) (21=2)(22=2)(23=3) (31=2)(32=2)(33=2)(34=3)(35=3)(36=4) (41=2)(51=4) (61=5) (99=.)
	lab define df_HIGHEDULEVEL 0 "No formal education" 1 "Less than primary" 2 "Completed primary" 3"Completed O-level" 4 " Completed A-level" 5"Completed University"
	keep HHID PID readwrite formal_edu highest_edu eduYrs
	tempfile section4
	save`section4', replace

***********************************************************************************
* Labor (GSEC 8)*
***********************************************************************************
	use "$WAVE2/GSEC8 .dta", clear
	gen hrs_worked = h8q36a+ h8q36b+ h8q36c+ h8q36d+ h8q36e+ h8q36f+ h8q36g
	gen employed =1 if (h8q4 == 1 | h8q6 == 1 | h8q8 == 1 | h8q12 == 1 | h8q15 == 1) & (hrs_worked>=1)
	replace employed=0 if (h8q4 == 2 | h8q6 == 2 | h8q8 == 2 | h8q12 == 2 | h8q15 == 2) & (hrs_worked<1)
	keep HHID PID employed
	tempfile section8
	save`section8', replace

***********************************************************************************
* Merge all data and clean up
***********************************************************************************
	use `ulfp2ind', clear 
	merge 1:1 HHID PID using `section3', nogen
	save `ulf21ind', replace

	use `ulfp2ind', clear 
	merge 1:1 HHID PID using `section4', nogen
	save `ulf21ind', replace

	use `ulfp2ind', clear 
	merge 1:1 HHID PID using `section8', nogen
	save `ulf21ind', replace

	gen wave=2

save "$OUT/ugaIND_data_2011-2012", replace
