/*------------------------------------------------------------------------------
goal: Generate event study plots for deliverable 2 

------------------------------------------------------------------------------*/


use "data/processed/event_study_plots.dta", clear 

rename ES_b FoodSecure
rename ES_b2 FoodSecureHigh
rename etime EventTime

graph twoway (connected FoodSecure EventTime ,  msize(medsmall) ///
	msymbol(o) mcolor(blue) lpattern(solid))		  ///
	(connected FoodSecureHigh EventTime ,  msize(medsmall) ///
	msymbol(o) mcolor(red) lpattern(solid))	///
	, xline(-0.5, lpattern("dash") lwidth("vthin")) ///
	yline(0, lpattern("dash") lwidth("vthin")) /// 
	note("Estimated treatment effects.") ///
	xlabel(-5(1)8)


drop if EventTime > 5

graph twoway (connected FoodSecure EventTime ,  msize(medsmall) ///
	msymbol(o) mcolor(blue) lpattern(solid))		  ///
	(connected FoodSecureHigh EventTime ,  msize(medsmall) ///
	msymbol(o) mcolor(red) lpattern(solid))	///
	, xline(-0.5, lpattern("dash") lwidth("vthin")) ///
	yline(0, lpattern("dash") lwidth("vthin")) /// 
	note("Estimated treatment effects.") /// 
	xlabel(-5(1)5)

use "data/processed/event_study_plots_w_CI.dta", clear 
rename ES_b FoodSecure
rename ES_b2 FoodSecureHigh
rename etime EventTime

graph twoway (connected FoodSecure EventTime ,  msize(medsmall) ///
	msymbol(o) mcolor(blue) lpattern(solid))		  ///
	(rcap ES_b_lower ES_b_upper EventTime), 		  ///
	xline(-0.5, lpattern("dash") lwidth("vthin")) ///
	yline(0, lpattern("dash") lwidth("vthin")) ///
	note("Estimated treatment effects with 90% Confidence Interval.") /// 
	legend(order(1 "FoodSecure")) xlabel(-5(1)8)

	
graph twoway (connected FoodSecureHigh EventTime ,  msize(medsmall) ///
	msymbol(o) mcolor(red) lpattern(solid))		  ///
	(rcap ES_b2_lower ES_b2_upper EventTime, ), 		  ///
	xline(-0.5, lpattern("dash") lwidth("vthin")) ///
	yline(0, lpattern("dash") lwidth("vthin")) ///
	note("Estimated treatment effects with 90% Confidence Interval.") /// 
	legend(order(1 "FoodSecureHigh")) xlabel(-5(1)8)


	

