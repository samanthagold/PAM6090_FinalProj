

use "data/processed/pulse_final_sample.dta", clear 

//make food security dummy  
{
destring curfoodsuf, replace 
//drop missing variables 
drop if curfoodsuf == -99 
drop if curfoodsuf == -88

gen foodsecure = 0
replace foodsecure = 1 if curfoodsuf == 1 
replace foodsecure = 1 if curfoodsuf == 2 
label var foodsecure "=0 if food insecure, =1 if food secure"

gen foodsecure_high = curfoodsuf
recode foodsecure_high (4=0)(3=0)(2=0)(1=1)

gen foodsecure_low = curfoodsuf
recode foodsecure_low (4=1)(3=0)(2=0)(1=0)
}

//make treatment variable 
{
destring tenrollpub tenrollprv tenrollhmsch, replace force

//drop if missing 
drop if tenrollpub == -99 
drop if tenrollpub == -88
drop if tenrollprv == -99 
drop if tenrollprv == -88
drop if tenrollhmsch == -99 
drop if tenrollhmsch == -88

//enerate total number of children in K-12 
gen kids_K_12 = tenrollpub + tenrollprv + tenrollhmsch
label var kids_K_12  "number of children in K-12"

//drop if greater than 5 
drop if kids_K_12 > 5 

//generate number of kids pre-K age by subtracting the number of kids K-12 from the total number of kids in the house 
gen kids_preK = thhld_numkid - kids_K_12 
label var kids_preK "number of children preK or newborn age" 
//drop if negative 
drop if kids_preK < 0 

//generate the percentage of children in the house in pre-K
gen percent_kids_preK = kids_preK / thhld_numkid
label var percent_kids_preK "percentage of children preK age"

//generate a variable that is 1 if all children in the house are pre-K aged 
gen all_preK = 0 
replace all_preK = 1 if kids_K_12 == 0 
label var all_preK "all children pre-school or newborn age"

//generate a variable that is 1 if all children in the house are K-12
gen all_K_12 = 0 
replace all_K_12 = 1 if thhld_numkid == kids_K_12
label var all_K_12 "all children in K-12th grade"

//generate treatment variable 
gen treat = . 
replace treat = 1 if all_preK == 1 
replace treat = 0 if all_K_12 == 1
label var treat "= 1 if all children preK or newborn age, = 0 if all children K-12, missing otherwise"

tab treat, mi

export delimited "data/processed/final_sample_treatment.csv", replace
}

//make event dummies 
//event is week 34 
{
//generate event dummies first equal to week dummies 
tab week, gen(ED) 

//rename for clarity 
rename ED1 EDm5 
rename ED2 EDm4
rename ED3 EDm3
rename ED4 EDm2
rename ED5 EDm1
rename ED6 ED0
rename ED7 ED1
rename ED8 ED2
rename ED9 ED3
rename ED10 ED4
rename ED11 ED5
rename ED12 ED6
rename ED13 ED7
rename ED14 ED8


//replace event dummies as all 0 if units are never treated 
replace EDm5 = 0 if treat == 0 
replace EDm4 = 0 if treat == 0 
replace EDm3 = 0 if treat == 0 
replace EDm2 = 0 if treat == 0 
replace EDm1 = 0 if treat == 0 
replace ED0 = 0 if treat == 0 
replace ED1 = 0 if treat == 0 
replace ED2 = 0 if treat == 0 
replace ED3 = 0 if treat == 0 
replace ED4 = 0 if treat == 0 
replace ED5 = 0 if treat == 0 
replace ED6 = 0 if treat == 0 
replace ED6 = 0 if treat == 0 
replace ED7 = 0 if treat == 0 
replace ED8 = 0 if treat == 0 




}

//expense difficulty variable 
{
destring expns_dif, replace 
recode expns_dif (3=1) (4=1) (1=0) (2=0) (-99 = .)
label var expns_dif "=1 if difficulty paying expenses and = 0 otherwise"

}

//generate household type buckets 
{
//each household type is a bucket that is family size(1-5 kids), income category (1-6), and treatment status (0-1)
//there is probably a much more efficient way to do this but oh well 
gen household_type = . 
//treatment = 0 
replace household_type = 1 if thhld_numkid == 1 & income == 1 & treat == 0 
replace household_type = 2 if thhld_numkid == 1 & income == 2 & treat == 0
replace household_type = 3 if thhld_numkid == 1 & income == 3 & treat == 0
replace household_type = 4 if thhld_numkid == 1 & income == 4 & treat == 0
replace household_type = 5 if thhld_numkid == 1 & income == 5 & treat == 0
replace household_type = 6 if thhld_numkid == 1 & income == 6 & treat == 0

replace household_type = 7 if thhld_numkid == 2 & income == 1 & treat == 0 
replace household_type = 8 if thhld_numkid == 2 & income == 2 & treat == 0 
replace household_type = 9 if thhld_numkid == 2 & income == 3 & treat == 0 
replace household_type = 10 if thhld_numkid == 2 & income == 4 & treat == 0 
replace household_type = 11 if thhld_numkid == 2 & income == 5 & treat == 0 
replace household_type = 12 if thhld_numkid == 2 & income == 6 & treat == 0 

replace household_type = 13 if thhld_numkid == 3 & income == 1 & treat == 0 
replace household_type = 14 if thhld_numkid == 3 & income == 2 & treat == 0 
replace household_type = 15 if thhld_numkid == 3 & income == 3 & treat == 0 
replace household_type = 16 if thhld_numkid == 3 & income == 4 & treat == 0 
replace household_type = 17 if thhld_numkid == 3 & income == 5 & treat == 0 
replace household_type = 18 if thhld_numkid == 3 & income == 6 & treat == 0 

replace household_type = 19 if thhld_numkid == 4 & income == 1 & treat == 0 
replace household_type = 20 if thhld_numkid == 4 & income == 2 & treat == 0 
replace household_type = 21 if thhld_numkid == 4 & income == 3 & treat == 0 
replace household_type = 22 if thhld_numkid == 4 & income == 4 & treat == 0 
replace household_type = 23 if thhld_numkid == 4 & income == 5 & treat == 0 
replace household_type = 24 if thhld_numkid == 4 & income == 6 & treat == 0 

//treatment = 1 
replace household_type = 25 if thhld_numkid == 1 & income == 1 & treat == 1 
replace household_type = 26 if thhld_numkid == 1 & income == 2 & treat == 1
replace household_type = 27 if thhld_numkid == 1 & income == 3 & treat == 1
replace household_type = 28 if thhld_numkid == 1 & income == 4 & treat == 1
replace household_type = 29 if thhld_numkid == 1 & income == 5 & treat == 1
replace household_type = 30 if thhld_numkid == 1 & income == 6 & treat == 1

replace household_type = 31 if thhld_numkid == 2 & income == 1 & treat == 1 
replace household_type = 32 if thhld_numkid == 2 & income == 2 & treat == 1 
replace household_type = 33 if thhld_numkid == 2 & income == 3 & treat == 1 
replace household_type = 34 if thhld_numkid == 2 & income == 4 & treat == 1 
replace household_type = 35 if thhld_numkid == 2 & income == 5 & treat == 1 
replace household_type = 36 if thhld_numkid == 2 & income == 6 & treat == 1 

replace household_type = 37 if thhld_numkid == 3 & income == 1 & treat == 1 
replace household_type = 38 if thhld_numkid == 3 & income == 2 & treat == 1 
replace household_type = 39 if thhld_numkid == 3 & income == 3 & treat == 1 
replace household_type = 40 if thhld_numkid == 3 & income == 4 & treat == 1 
replace household_type = 41 if thhld_numkid == 3 & income == 5 & treat == 1 
replace household_type = 42 if thhld_numkid == 3 & income == 6 & treat == 1 

replace household_type = 43 if thhld_numkid == 4 & income == 1 & treat == 1 
replace household_type = 44 if thhld_numkid == 4 & income == 2 & treat == 1 
replace household_type = 45 if thhld_numkid == 4 & income == 3 & treat == 1 
replace household_type = 46 if thhld_numkid == 4 & income == 4 & treat == 1 
replace household_type = 47 if thhld_numkid == 4 & income == 5 & treat == 1 
replace household_type = 48 if thhld_numkid == 4 & income == 6 & treat == 1 

tab household_type, gen(household_type)
}

//clean other control variables 
{
//race
gen black = 0 
replace black = 1 if rrace == 2 

gen asian = 0 
replace asian = 1 if rrace == 3 

gen other_race = 0 
replace other_race = 1 if rrace == 4 

gen hispanic = 0
replace hispanic = 1 if rhispanic == 2

//educ 
tab eeduc, gen(educ)

//in person learning 
destring teach1, replace force
gen in_person_school = 0 
replace in_person_school = 1 if teach1 == 1 
label var in_person_school "=1 if recived in person educ"

//recieved free food 
destring freefood, replace 
replace freefood = 0 if freefood == 2 
label var freefood "= 1 if recieved free food"

//recieved snap 
destring snap_yn, replace 
rename snap_yn snap 
replace snap = 0 if snap == 2 
label var snap "= 1 if recieved snap"

//employment 
destring anywork, replace 
gen employed = 0 
replace employed = 1 if anywork == 2

//parent age 
gen parent_age = 2022 - tbirth_year

//educ 
rename eeduc educ 

//family size 
rename thhld_numper family_size

}

//total CTC eligible for 
{
gen ctc_eligible = kids_K_12*3000 + kids_preK*3600
label var ctc_eligible "total dollar amount of ctc HH eligible for based on number of kids and child age"

}

//generate post dummmy and treatXpost dummy for DiD 
{
gen post = 0 
replace post = 1 if week >= 33
label var post "=1 if after the start of expanded ctc"

gen treatXpost = treat*post 
gen percent_kids_preKXpost = percent_kids_preK*post

}

//child food security variable
{
destring childfood, replace 
rename childfood child_foodsecure
recode child_foodsecure (-88=.) (-99=.) (3=1) (2=0) (1=0)
label var child_foodsecure "=1 if the parent reports child is NEVER not eating enough bc HH can't afford it"
}

////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////Final Specs/////////////////////////////////// 
////////////////////////////////////////////////////////////////////////////////

sum foodsecure_high

////////DiD///////
//DiD no controls - LHS = foodsecure
reg foodsecure treatXpost post treat [pweight = pweight]
outreg2 using "tables/Main_Regression_Specs.doc", replace 
//DiD with controls - LHS = foodsecure
reg foodsecure treatXpost post treat i.income i.family_size black asian other_race hispanic i.educ snap freefood in_person_school parent_age employed [pweight = pweight]
outreg2 using "tables/Main_Regression_Specs.doc", replace 

/////////Event Study//////

//set constraints 
//pre period avg to zero 
constraint define 1 EDm1 + EDm2 + EDm3 + EDm4 + EDm5 = 0 

//EDm1 = EDm2 
constraint 2 EDm4 = EDm5


//ES no controls, LHS = food secure 
cnsreg foodsecure ED* i.week treat [pweight = pweight], nocons constraints(1)
outreg2 using "tables/Main_Regression_Specs.doc", append



/* EVENT STUDY PLOT 1 */ 
//ES with all controls (treat, income, and family size included seperate), LHS = food secure 
cnsreg foodsecure ED* treat i.week i.income i.family_size black asian ///
	other_race hispanic i.educ snap freefood in_person_school parent_age ///
	[pweight = pweight], nocons constraints(1) collinear 
outreg2 using "tables/Main_Regression_Specs.doc", append
outreg2 using "tables/main_reg_spec.xlsx", replace 

//ES no controls, LHS = high food secure 
cnsreg foodsecure_high ED* i.week treat [pweight = pweight], nocons constraints(1)
outreg2 using "tables/Main_Regression_Specs.doc", append


/* EVENT STUDY PLOT 2 */ 
//ES with all controls (treat, income, and family size included seperate), LHS = high food secure 
cnsreg foodsecure_high ED* treat i.week i.income i.family_size black asian ///
	other_race hispanic i.educ snap freefood in_person_school parent_age ///
	[pweight = pweight], nocons constraints(1) collinear 
	
outreg2 using "tables/Main_Regression_Specs.doc", append
outreg2 using "tables/main_reg_spec.xlsx", append 





