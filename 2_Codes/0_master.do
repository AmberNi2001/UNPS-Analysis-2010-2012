/*******************************************************************************
Program:    0_master.do
Note:		This file runs all the do files necessary for processing national panel survey data for country Uganda from 2010-2011 and 2011-2012
Author:     Amber Ni & Jessie
*******************************************************************************/

*** Setup
	cls
	clear
	macro drop _all
	version 18
	set more off
	set linesize 255


*** Define global macros
global ROOT "/Users/amberni/Desktop/Grad/25Spring/Econometrics/UGA_Assignment1_AmberJessie"
global IN "$ROOT/1_Input"
global WAVE1 "$IN/UGAwave1_2010-2011" 
global WAVE2 "$IN/UGAwave2_2011-2012"
global DO "$ROOT/2_Code"
global OUT "$ROOT/3_Output"

*** create log file
capture log close //close any log file, if open
log using "$OUT/UGA_log_file", smcl replace

	
*** Merge data
	do "$DO/1a_merge_UGA_wave1_IND.do"
	do "$DO/1b_merge_UGA_wave2_IND.do"
	do "$DO/1c_merge_UGA_waves_IND.do"
	do "$DO/1d_merge_UGA_wave1_HH.do"
	do "$DO/1e_merge_UGA_wave2_HH.do"
	do "$DO/1f_merge_UGA_waves_HH.do"

	
*** Generate descriptive statistics
    do "$DO/2_descriptive_statistics.do"

		
*** Erase intermediate data files created earlier
	erase "$OUT/ugaHH_data_2010-2011.dta"
	erase "$OUT/ugaHH_data_2011-2012.dta"
	erase "$OUT/ugaIND_data_2010-2011.dta"
	erase "$OUT/ugaIND_data_2011-2012.dta"


