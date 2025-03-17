/*******************************************************************************
Program:    	3_analysis.do
Note:			This file generates regression analysis for Uganda National Panel Survey Waves 1 and 2 from 2010-2011 to 2011-2012
Author:     	Amber Ni 
*******************************************************************************/

use "$OUT/uga_all_households", clear 

***********************************************************************
* Summary statistics
***********************************************************************
	summarize
	codebook, c
	destring HHID, replace
	xtset HHID wave
	xtdescribe
	
* Generate pair-wise correlation 
	asdoc pwcorr  hhsize hhMeanAge hhMeanEduYrs depRatio ypce ypceLn poor, sig save($OUT/correlation1.doc) replace // Check correlation between basic HH characteristics and poverty
	asdoc pwcorr  hhhSex hhhMarital hhhAge hhhHighest~u hhhEduYrs ypce ypceLn poor, sig save($OUT/correlation2.doc) replace // Check correlation between HHH characteristics and poverty
	asdoc pwcorr  region urban elec room_count handwash_t~t logged_water meals_day ypce ypceLn poor, sig save($OUT/correlation3.doc) replace // Check correlation between more HH characteristics and poverty 
	
	** Variables that are highly correlated with consumption expenditure: hhsize, hhMeanEduYrs,depRatio, hhhAge, hhhHighest~u, hhhEduYrs, region, urban, elec, room_count, handwash_t~t, meals_day
	** Independent variables that are highly correlated with each other: hhhEduYrs and hhhHighest~u
	** Independent variables that are moderately related with each other: hhsize and hhMeanAge; hhhMarital and hhhSex; elec and region 
	
***********************************************************************
* Machine learning for model selection
***********************************************************************

* Install necessary commands
	ssc install vselect, replace
	ssc install estout, replace
	ssc install lassopack, replace
	
* Stepwise model selection
	set seed 123
	gen random=runiform() //Generate a random variable with no meaning
	gl povertyVars "hhsize hhMeanAge hhMeanEduYrs depRatio hhhSex hhhMarital hhhAge hhhHighest~u hhhEduYrs region urban elec room_count handwash_t~t logged_water meals_day" // All candidate variables
	
	eststo clear //Clear any stored estimates
	eststo ols: reg ypceLn $povertyVars //Kitchen-sink regression
	eststo backward_ar2: vselect ypceLn $povertyVars, backward r2adj //Stepwise backward using adjusted R-squared
	eststo backward_aic: vselect ypceLn $povertyVars, backward aic //Stepwise backward using AIC
	eststo forward_ar2: vselect ypceLn $povertyVars, forward r2adj //Stepwise forward using adjusted R-squared
	eststo forward_aic: vselect ypceLn $povertyVars, forward aic //Stepwise forward using adjusted AIC
	
	** Tabulate stored estimates
	esttab ols backward_ar2 backward_aic forward_ar2 forward_aic /*using "test.rtf"*/, ///
	not lab mti(Full_model SW_B_ar2 SW_B_aic SW_B_ar2 SW_F_aic) ///
	stats(r2 r2_a N df_m, labels("R-squared" "Adjusted R-squared" "Number of observations" "Number of covariates"))
	
	** Stepwise model's results: stepwise backward using AIC, forward using adjusted R-squared and forward using AIC all suggest to remove "hhhMarital"

	
* Shrinkage methods (lasso)
	gl povertyVars "hhsize hhMeanAge hhMeanEduYrs depRatio hhhSex hhhMarital hhhAge hhhHighest~u hhhEduYrs region urban elec room_count handwash_t~t logged_water meals_day" //All candidate variables
	
	** Implement lasso and ridge regressions using diffrent values of lambda
	lasso2 ypceLn $povertyVars,  alpha(1) //Alpha=1 corresponds to the lasso regression
	lasso2, lic(ebic) //Optimal lasso model selected using EBIC
	
	** Choose optimal lambda for lasso through cross-validation
	cvlasso ypceLn $povertyVars, seed(123) lopt alpha(1) postest
	gl lassoVars=e(selected) //Save variables selected by lasso
	
	** Post-lasso estimation
	eststo clear //Clear any saved estimates
	eststo ols: reg ypceLn $povertyVars
	eststo lasso: reg ypceLn $lassoVars
	
	** Lasso's results: nothing needs to be removed from the model

***********************************************************************
* VIF for multicollinearity
***********************************************************************

	eststo ols: reg ypceLn $povertyVars
	vif, uncentered // variables "logged_water hhhAge meals_day hhhEduYrs hhhHighest~u hhMeanAge depRatio hhsize " have a vif > 10
	
	* try again: delete all variables with vif > 10 
	gl adjustedVars "hhMeanEduYrs hhhSex hhhMarital region urban elec room_count handwash_t~t"  
	eststo ols: reg ypceLn $adjustedVars
	vif, uncentered

***********************************************************************
* Finalized chosen variables for analysis
***********************************************************************
	
* hhsize hhMeanEduYrs depRatio hhhSex hhhAge hhhHighest~u region urban elec room_count handwash_t~t meals_day wave
	
	* Generate quadratic terms
	gen hhsize2 = hhsize^2
	gen hhMeanEduYrs2 = hhMeanEduYrs^2
	gen hhhAge2 = hhhAge^2
	
	* Create a finalized chosen variable list for regression 
	gl chosenVars "hhsize hhsize2 hhMeanEduYrs hhMeanEduYrs2 depRatio hhhSex hhhAge hhhAge2 i.hhhHighest~u i.region urban elec room_count i.handwash_t~t meals_day wave"  

***********************************************************************
* Pooled OLS
***********************************************************************
	* Install a necessary package 
	ssc install outreg2
	
	eststo ols: reg ypceLn $chosenVars, robust
	vif // Check VIF 
	predict res_ols, resid // Generate residuals 
	
	* Check the normality of residuals 
	kdensity res_ols, normal 
	qnorm res_ols
	
***********************************************************************
* Fixed-Effects Model
***********************************************************************
	destring HHID, replace 
	xtset HHID wave // Specify panel data
	
	eststo fe: xtreg ypceLn $chosenVars, robust fe i(HHID)
	vif, uncentered // Check VIF 
	predict res_fe, resid // Generate residuals 
	
	* Check the normality of residuals 
	kdensity res_fe, normal
	qnorm res_fe
	
***********************************************************************
* Random-Effects Model
***********************************************************************
	eststo re: xtreg ypceLn $chosenVars, robust re i(HHID)
	vif, uncentered
	
	* Check the normality of within household residuals 
	predict res_re, e // Get within household residuals
	kdensity res_re, normal
	qnorm res_re
	
	* Check the normality of between household residuals 
	predict res_re2, ue // Get between household residuals 
	kdensity res_re2, normal
	qnorm  res_re2 
	
	* plot three regression results for comparison
	esttab ols fe re using "$OUT/Reg_Outputs", se star(* 0.1 ** 0.05 *** 0.01) label replace ///
		mtitles("OLS" "Fixed Effects" "Random Effects") ///
		title("Regression Results Comparison") ///
		rtf

***********************************************************************
* the Hausman Test 
***********************************************************************
	xtreg ypceLn $chosenVars, fe i(HHID)
	est store fixed
	xtreg ypceLn $chosenVars, re i(HHID)
	hausman fixed 
	* The p-value of the Hausman statistic here is 0.0000(<0.05), suggesting FE model is preferable in this context.
	
***********************************************************************
* Save the new dataset
***********************************************************************
	preserve
	keep hhsize hhsize2 hhMeanEduYrs hhMeanEduYrs2 depRatio hhhSex hhhAge hhhAge2 hhhHighest~u region urban elec room_count handwash_t~t meals_day wave
	save "$OUT/uga_HHanalysis", replace
	restore


	
	