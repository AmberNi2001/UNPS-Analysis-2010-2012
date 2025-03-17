/*******************************************************************************
Program:    	1a_merge_UGA_HH.do
Note:			This file merges all the relevant household-level variables in UGA Wave 1 (2010-2011)
Author:     	Amber Ni
*******************************************************************************/

***********************************************************************************
* HH demographic characteristics
***********************************************************************************

	* Household size/Mean age/Dependency ratio 
	use "$WAVE1/GSEC2.dta", clear
	rename h2q8 age
	gen workingAge = (age>14 & age <65)	//WB definition of working age: 15-64 years. Source: http://data.worldbank.org/indicator/SP.POP.DPND
	gen one = 1
	collapse (count) one (sum) workingAge (mean) age, by(HHID)
	ren (one age) (hhsize hhMeanAge)
	gen depRatio=1-(workingAge/hhsize) 
	drop workingAge
	tempfile ugahhDemographics
	save `ugahhDemographics', replace
	
	* Mean educational years 
	use "$WAVE1/GSEC4.dta", clear
	rename h4q7 edu
	recode edu (10=0) (11=1) (12=2) (13=3) (14=4) (15=5) (16=6) (17=7) (21=8) (22=9) ///
			(23=10) (31=11) (32=12) (33=13) (34=14) (35=15) (36=16) (41=8) (51=17) (61=17) (99=.) (52=.) , /// recode highest grades completed to education years 
			gen(eduYrs)
	collapse (mean) eduYrs, by(HHID) // compute mean education years by household
	ren eduYrs hhMeanEduYrs
	tempfile ugahhmeanedu
	save `ugahhmeanedu', replace

	* Region/Urban 
	use "$WAVE1/GSEC1.dta", clear 
	keep HHID region urban
	tempfile ugaregionurban
	save `ugaregionurban', replace 
	
	* Merge all HH demographic characteristics 
	use `ugahhDemographics', clear
	merge 1:1 HHID using `ugahhmeanedu', nogen 
	merge 1:1 HHID using `ugaregionurban', nogen
	tempfile ugahhinfo
	save `ugahhinfo', replace
	
***********************************************************************************
* HHH characteristics: Age/Sex/Maritalal Status/Edu
***********************************************************************************

	use "$OUT/ugaIND_data_2010-2011.dta", clear
	keep if head == 1
	keep HHID PID sex head age married highest_edu eduYrs
	rename (sex age married highest_edu eduYrs) (hhhSex hhhAge hhhMarital hhhHighestEdu hhhEduYrs)
	tempfile ugaHHH
	save `ugaHHH', replace
	
/*******************************************************************************	
	* Age/Sex/Maritalal Status (2713, it is HH-level var showing HHH characteristics in each HH)
	use "$WAVE1/GSEC2.dta", clear
	rename (h2q3 h2q4 h2q8 h2q10) (hhhSex head hhhAge hhhMarital)
	keep if head == 1 // filter all household head
	keep HHID PID hhhSex head hhhAge hhhMarita
	tempfile ugahead1
	save `ugahead1', replace
	
	* Education years (12836, it contains education years for all individuals)
	use "$WAVE1/GSEC4.dta", clear
	rename h4q7 edu
	recode edu (10=0) (11=1) (12=2) (13=3) (14=4) (15=5) (16=6) (17=7) (21=8) (22=9) /// 
			(23=10) (31=11) (32=12) (33=13) (34=14) (35=15) (36=16) /// 
			(41=8) (51=17) (61=17) (99=.) , gen(hhhEduYrs)
	keep HHID PID hhhEduYrs
	tempfile ugahead2
	save `ugahead2', replace 
	
	* Merge all HHH characteristics 
	use `ugahead1', clear
	merge 1:1 PID using `ugahead2', keep(match master) nogen
	tempfile ugaHHH
	save `ugaHHH', replace
*******************************************************************************/
	
***********************************************************************************
* Electricity
***********************************************************************************
	
	use "$WAVE1/GSEC10A.dta", clear 
	rename h10q1 elec
	recode elec (1=1) (2=0)
	label define yesno 1 "Yes" 0 "No"
	label values elec yesno // recode Yes to 1 and No to 0
	keep HHID elec
	tempfile ugaelec
	save `ugaelec', replace
	
***********************************************************************************
* Housing condition, water and sanitation: Number of rooms/hand-washing facility/water 
***********************************************************************************

	use "$WAVE1/GSEC9A.dta", clear
	rename (h9q3 h9q23 h9q11a h9q11b) (room_count handwash_toilet water_unit water_quant) 
	recode handwash_toilet (1=0) (2=1) (3=2)
	label define handwashing 0 "No" 1 "Yes with water only" 2 "Yes with water and soup", replace
	label values handwash_toilet handwashing // recode Yes to 1 or 2 and No to 0
	gen water_litres = water_quant
	replace water_litres = water_quant * 20 if water_unit == 2 // standardize all water units to litres 
	replace water_litres = . if water_unit == 8 // deal with missing data
	gen logged_water = ln(water_litres) // log water litres
	replace room_count = . if room_count == 12000 // remove an outlier
	keep HHID room_count handwash_toilet logged_water
	tempfile ugahousingetc
	save `ugahousingetc', replace
	
***********************************************************************************
* Food security
***********************************************************************************

	use "$WAVE1/GSEC17A.dta", clear
	rename h17q05 meals_day
	keep HHID meals_day
	tempfile ugafoodsec
	save `ugafoodsec', replace
	

***********************************************************************************
* Consumption
***********************************************************************************
	
	use "$WAVE1/GSEC2.dta", clear
	gen one = 1
	collapse (count) one, by(HHID)
	ren one hhsize
	tempfile hhsize
	save `hhsize', replace // extract household size variable
	
	use "$WAVE1/pov2010_11.dta", clear
	ren hh HHID
	tostring HHID, replace format(%20.0g) force
	merge 1:1 HHID using `hhsize', nogen // merge household size variable with the dataset that contains consumption information
	ren cpexp30 mexp
	gen yexp = mexp * 12 // convert it to yearly consumption 
	gen ypce = yexp/hhsize // compute consumption per capita
	sum ypce // get poverty line 
	gen ypceLn=ln(yexp/hhsize) // log consumption per capita
	keep HHID ypceLn ypce 
	gen poor=ypce<175023.6 // arbitrarily set the poverty line at the 25th percentile of annual consumption
	lab var poor "Household is poor under the national poverty line"
	tempfile consumption
	save `consumption', replace
	
***********************************************************************************
* Merge all HH-level data
***********************************************************************************
	
	use `ugahhinfo', clear
	merge 1:1 HHID using `ugaHHH', nogen
	merge 1:1 HHID using `ugaelec', nogen
	merge 1:1 HHID using `ugahousingetc', nogen	
	merge 1:1 HHID using `ugafoodsec', nogen
	merge 1:1 HHID using `consumption', nogen
	gen wave=1
	save "$OUT/ugaHH_data_2010-2011", replace
	
	
