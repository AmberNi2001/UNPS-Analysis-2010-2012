/*******************************************************************************
Program:    	1a_merge_ULFP1_IND.do
Note:			This file merges all the relevant individual-level variables in ULFP Wave 1
Author:     	Jessie Hu
*******************************************************************************/

***********************************************************************************
* Demographics Part 1 (GSEC2)*
***********************************************************************************
	use "$WAVE1/GSEC2.dta",clear
	ren (h2q3 h2q10 h2q4)(sex married head)
	drop if h2q9c > 1997 | h2q9c < 1900
	gen age = 2011-h2q9c
	label drop h2q10
	recode married (5=0)(3=0)(4=0)(1=1)(2=2)
	label define h2q10 0 "Not Married" 1 "Married Monogamously" 2 "Married Polygamously"
	keep HHID PID sex married age head
	tempfile ulfp1ind
	save `ulfp1ind', replace

***********************************************************************************
* Demographics Part 2 (GSEC 3)*
***********************************************************************************
	use "$WAVE1/GSEC3.dta",clear
	ren (h3q13_1 h3q16_1 h3q17 h3q20) (region_born region_lived lived_urban camp)
	label drop h3q17 h3q20
	recode lived_urban(2=1)(3=0)
	label define h3q17 1"Urban" 0"Rural"
	recode camp (2=0)
	label define h3q20 0"No"
	keep HHID PID region_born region_lived lived_urban camp
	tempfile section3
	save`section3', replace

***********************************************************************************
* Education (GSEC 4)*
***********************************************************************************
	use "$WAVE1/GSEC4.dta",clear
	ren (h4q4 h4q5 h4q7)(readwrite formal_edu highest_edu)
	gen eduYrs = highest_edu
	recode eduYrs (1=1) (3=3) (10=0) (11=1) (12=2) (13=3) (14=4) (15=5) (16=6) (17=7) (21=8) ///
			(22=9) (23=10) (31=11) (32=12) (33=13) (34=14) (35=15) (36=16) (99=.) ///
			(41=8) (51=11) (61=17) (52=.)
	label drop h4q4 h4q5 h4q7 h4q16 
	recode readwrite (1=0) (2=1) (3=2) (4=3)
	lab define h4q4 0 "Unable to read and write" 1"Able to read only" 2"Able to write only" 3"Able to read and write"
	recode formal_edu (1=0) (2=1) (3=1)
	lab define h4q5 0 "Never attended" 1"Have attended"
	recode highest_edu (10=0) (11=1) (12=1) (13=1)(14=1)(15=1)(16=1)(17=2) (21=2)(22=2)(23=3) (31=2)(32=2)(33=2)(34=3)(35=3)(35=3)(36=4) (41=2)(51=4) (61=5) (52=5) (99=.)
	lab define h4q7 0 "No formal education" 1 "Less than primary" 2 "Completed primary" 3"Completed O-level" 4 "Completed A-level" 5"Completed University" 
	keep HHID PID readwrite formal_edu highest_edu eduYrs
	tempfile section4
	save`section4', replace

***********************************************************************************
* Disability (GSEC 7a)*
***********************************************************************************
	use "$WAVE1/GSEC7a.dta",clear
	ren (h7q2a h7q3a h7q4a h7q5a h7q6a h7q7a) (vision_impair hearing_impair mobility_impair concen_impair selfcare_impair comms_impair)
	label drop h7q2a h7q3a h7q4a h7q5a h7q6a h7q7a
	recode vision_impair (1=0)(2=1)(3=1)(4=1)
	lab define h7q2a 0"No" 1"Yes"
	recode hearing_impair (1=0)(2=1)(3=1)(4=1)
	lab define h7q3a 0"No" 1"Yes"
	recode mobility_impair (1=0)(2=1)(3=1)(4=1)
	lab define h7q4a 0"No" 1"Yes"
	recode concen_impair (1=0)(2=1)(3=1)(4=1)
	lab define h7q5a 0"No" 1"Yes"
	recode selfcare_impair (1=0)(2=1)(3=1)(4=1)
	lab define h7q6a 0"No" 1"Yes"
	recode comms_impair (1=0)(2=1)(3=1)(4=1)
	lab define h7q7a 0"No" 1"Yes"
	keep HHID PID vision_impair hearing_impair mobility_impair concen_impair selfcare_impair comms_impair 
	tempfile section7a
	save`section7a', replace

***********************************************************************************
* Labor Force Participation (GSEC 8)*
***********************************************************************************
	use "$WAVE1/GSEC8.dta",clear
	gen hrs_worked = h8q36a+ h8q36b+ h8q36c+ h8q36d+ h8q36e+ h8q36f+ h8q36g
	gen employed =1 if (h8q4 == 1 | h8q6 == 1 | h8q8 == 1 | h8q12 == 1 | h8q15 == 1) & (hrs_worked>=1)
	replace employed=0 if (h8q4 == 2 | h8q6 == 2 | h8q8 == 2 | h8q12 == 2 | h8q15 == 2) & (hrs_worked<1)
	keep HHID PID employed 
	tempfile section8
	save`section8', replace

***********************************************************************************
* Merge all data and clean up
***********************************************************************************
	use `ulfp1ind', clear 
	merge 1:1 HHID PID using `section3', nogen
	save `ulfp1ind', replace

	use `ulfp1ind', clear 
	merge 1:1 HHID PID using `section4', nogen
	save `ulfp1ind', replace

	use `ulfp1ind', clear
	merge 1:1 HHID PID using `section7a', nogen
	save `ulfp1ind', replace

	use `ulfp1ind', clear
	merge 1:1 HHID PID using `section8', nogen
	save `ulfp1ind', replace

	gen wave=1

save "$OUT/ugaIND_data_2010-2011", replace

