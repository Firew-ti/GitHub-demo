import delimited "C:\Users\tiyafi\Downloads\mch_referral_11.05.2026 (2).csv"
import delimited "C:\Users\tiyafi\Downloads\mch_referral_revised (16).csv", clear 
br
ds
drop if 150 obs
import delimited "C:\Users\tiyafi\Downloads\mch_referral_revised (16).csv", clear bindquote(strict)
save "C:\Users\tiyafi\Downloads\1.dta", replace
import delimited "C:\Users\tiyafi\Downloads\mch_referral_11.05.2026 (2).csv", clear 
merge 1:1 instanceid using "C:\Users\tiyafi\Downloads\1.dta"
gen ID= _n
label variable ID "Unique identification"
label variable facility "catchment referal facility"
graph box age_years
hist  age_years, norm
gen lastdigit = mod( age_years ,10)
tab lastdigit
summarize age_years, detail
count if inrange(age_years,25,49)
local N = r(N)
count if inrange(age_years,25,49) & (mod(age_years,5)==0) 
local H = r(N)
display "Whipple's Index = " 500*(`H'/`N')
label variable age_years "maternal age"
tab marital_status
gen married = .
gen married_dummy = .
replace married = 1 if marital_status == "married"
replace married = 0 if marital_status != "married" & !missing(marital_status)
tab married
order ID facility age_years married
tab religion
tab ethnicity
tab respondent_education
tab respondent_occupation
gen maternal_occupation=.
replace  maternal_occupation = 1 if respondent_occupation== "housewife"
replace  maternal_occupation = 2 if respondent_occupation== "farmer" | respondent_occupation== "other" | respondent_occupation== "student" | respondent_occupation== "unemployed"
replace  maternal_occupation = 3 if respondent_occupation== "government_employee" | respondent_occupation== "private_employee" | respondent_occupation== "self_employed"
tab maternal_occupation
label define m_occup 1 "housewife" 2 "farmer" 3 "employee"
label value maternal_occupation m_occup
tab maternal_occupation
order ID facility age_years married religion ethnicity respondent_education maternal_occupation
tab partner_education
tab partner_occupation
gen partner_occup=.
replace  partner_occup = 1 if partner_occupation == "farmer"
replace partner_occup = 0 if partner_occupation != "farmer" & !missing(partner_occupation)
tab partner_occup
label define p_occup 1 "farmer" 0 "employee"
label value partner_occup p_occup
tab partner_occup
order ID facility age_years married religion ethnicity respondent_education maternal_occupation partner_occup
tab partner_education
order ID facility age_years married religion ethnicity respondent_education maternal_occupation partner_education partner_occup
tab household_size
tab household_size partner_occupation
summarize  monthly_income, detail
histogram monthly_income, percent
graph box monthly_income
hist monthly_income, norm
ssc install winsor2
winsor2 monthly_income, cuts(1 99) replace
hist monthly_income, norm
graph box monthly_income
summarize  monthly_income, detail
tab monthly_income
tab monthly_income partner_occupation
order ID facility age_years married religion ethnicity respondent_education maternal_occupation partner_education partner_occup monthly_income household_size residence
global sociodemography age_years i.married i.religion i.ethnicity i.respondent_education i.maternal_occupation i.partner_education i.partner_occup monthly_income household_size i.residence
logistic referral_compliance $sociodemography

ds, has(type string)
local stringvars `r(varlist)'

foreach var of local stringvars {
    tempvar encoded
    encode `var', gen(`encoded')
    drop `var'
    rename `encoded' `var'
}

order ID facility age_years married religion ethnicity respondent_education maternal_occupation partner_education partner_occup monthly_income household_size residence
global sociodemography age_years i.married i.religion i.ethnicity i.respondent_education i.maternal_occupation i.partner_education i.partner_occup monthly_income household_size i.residence
tab referral_compliance
tab referral_stage
tab referred_person
tab maternal_reason
tab newborn_reason
tab baby_sex
tab referral_purpose
gen purpose_referral=.
replace purpose_referral= 1 if referral_purpose == 2
replace purpose_referral= 2 if referral_purpose == 3
replace purpose_referral= 3 if referral_purpose == 5 | referral_purpose == 8
replace purpose_referral= 2 if referral_purpose == 3 |referral_purpose == 7
replace purpose_referral= 4 if referral_purpose == 1 |referral_purpose == 6 |referral_purpose == 9 | referral_purpose == 4
tab purpose_referral
label define ref_p 1 "emergency" 2 "diagnosis" 3 "treatment" 4 "follow up and others"
tab purpose_referral
label values purpose_referral  ref_p
tab purpose_referral
order ID facility age_years married religion ethnicity respondent_education maternal_occupation partner_education partner_occup monthly_income household_size residence referral_stage referred_person maternal_reason newborn_reason baby_sex baby_ga referral_source source_f referral_destination purpose_referral
tab decision_maker
tab explain_clarity
tab involved_in_decision
tab referral_slip
tab facility_communication
tab facility_communication, missing
tab pre_referral_treatment
tab pre_referral_treatment purpose_referral
tab transport_arranged
tab accompanied_by_hw
tab accompanied_by_hw purpose_referral
tab transfer_instructions
tab noncompliance_reason
order ID facility age_years married religion ethnicity respondent_education maternal_occupation partner_education partner_occup monthly_income household_size residence referral_stage referred_person maternal_reason newborn_reason baby_sex baby_ga referral_source source_f referral_destination purpose_referral decision_maker explain_clarity involved_in_decision referral_slip facility_communication pre_referral_treatment transport_arranged accompanied_by_hw transfer_instructions referral_compliance noncompliance_reason
tab arrival_attended
tab waiting_time_cat
tab all_services_available
tab referred_again
order ID facility age_years married religion ethnicity respondent_education maternal_occupation partner_education partner_occup monthly_income household_size residence referral_stage referred_person maternal_reason newborn_reason baby_sex baby_ga referral_source source_f referral_destination purpose_referral decision_maker explain_clarity involved_in_decision referral_slip facility_communication pre_referral_treatment transport_arranged accompanied_by_hw transfer_instructions referral_compliance noncompliance_reason arrival_attended waiting_time_cat all_services_available referred_again maternal_outcome maternal_complication preg_outcomes newborn_outcome newborn_complication
tab self_decide_seek
tab final_decision_maker
tab money_required
tab cost_influence
tab insurance
tab home_to_referral_time
order ID facility age_years married religion ethnicity respondent_education maternal_occupation partner_education partner_occup monthly_income household_size residence referral_stage referred_person maternal_reason newborn_reason baby_sex baby_ga referral_source source_f referral_destination purpose_referral decision_maker explain_clarity involved_in_decision referral_slip facility_communication pre_referral_treatment transport_arranged accompanied_by_hw transfer_instructions time_to_depart_min travel_time_min referral_compliance noncompliance_reason arrival_attended waiting_time_cat all_services_available referred_again maternal_outcome maternal_complication preg_outcomes newborn_outcome newborn_complication
tab reach_difficulty
tab trans_acces
tab perceived_severity
tab understand_consequence
tab prioregative_experience
tab responsibilities_affected
tab treatment_confidence
tab dx_m
tab dx_b
tab satsfn
tab recomdn
tab postdischarge_advice
order ID facility age_years married religion ethnicity respondent_education maternal_occupation partner_education partner_occup monthly_income household_size residence referral_stage referred_person maternal_reason newborn_reason baby_sex baby_ga referral_source source_f referral_destination purpose_referral decision_maker explain_clarity involved_in_decision referral_slip facility_communication pre_referral_treatment transport_arranged accompanied_by_hw transfer_instructions referral_compliance noncompliance_reason arrival_attended waiting_time_cat all_services_available referred_again maternal_outcome maternal_complication preg_outcomes newborn_outcome newborn_complication self_decide_seek final_decision_maker money_required cost_influence insurance home_to_referral_time reach_difficulty trans_acces perceived_severity understand_consequence prioregative_experience responsibilities_affected treatment_confidence dx_m dx_b satsfn recomdn postdischarge_advice
save "C:\Users\tiyafi\Downloads\1.dta", replace
tab maternal_outcome
tab preg_outcomes
tab newborn_outcome
gen adverse_outcome = 0
label define advlbl 0 "No adverse outcome" 1 "Adverse outcome"
label values adverse_outcome advlbl
label variable adverse_outcome "Composite adverse maternal/newborn outcome"
tab adverse_outcome
codebook maternal_outcome preg_outcomes newborn_outcome
replace adverse_outcome = 1 if  maternal_outcome == 1 | maternal_outcome == 2
replace adverse_outcome = 1 if  preg_outcomes == 1 |  preg_outcomes == 2
replace adverse_outcome = 1 if newborn_outcome == 1 |  newborn_outcome == 3
tab adverse_outcome
order ID facility age_years married religion ethnicity respondent_education maternal_occupation partner_education partner_occup monthly_income household_size residence referral_stage referred_person maternal_reason newborn_reason baby_sex baby_ga referral_source source_f referral_destination purpose_referral decision_maker explain_clarity involved_in_decision referral_slip facility_communication pre_referral_treatment transport_arranged accompanied_by_hw transfer_instructions referral_compliance noncompliance_reason arrival_attended waiting_time_cat all_services_available referred_again adverse_outcome maternal_outcome maternal_complication preg_outcomes newborn_outcome newborn_complication self_decide_seek final_decision_maker money_required cost_influence insurance home_to_referral_time reach_difficulty trans_acces perceived_severity understand_consequence prioregative_experience responsibilities_affected treatment_confidence dx_m dx_b satsfn recomdn postdischarge_advice
logistic adverse_outcome age_years
logistic adverse_outcome married
logistic adverse_outcome religion
logistic adverse_outcome ethnicity
logistic adverse_outcome respondent_education
logistic adverse_outcome maternal_occupation
logistic adverse_outcome i.maternal_occupation
logistic adverse_outcome partner_education
logistic adverse_outcome partner_occup
logistic adverse_outcome monthly_income
logistic adverse_outcome household_size
logistic adverse_outcome residence
logistic adverse_outcome i.residence
logistic adverse_outcome referral_stage
logistic adverse_outcome i.referral_stage
tab referral_stage
logistic adverse_outcome maternal_reason
logistic adverse_outcome newborn_reason
tab maternal_reason
tab newborn_reason
codebook maternal_reason newborn_reason
gen clinical_condition = .
replace clinical_condition = 1 if   maternal_reason == 1 | newborn_reason == 1
replace clinical_condition = 2 if  missing(clinical_condition) &   (maternal_reason == 2 | newborn_reason == 2)
replace clinical_condition = 3 if   missing(clinical_condition) &  (maternal_reason == 3 | newborn_reason == 3)
replace clinical_condition = 4 if  missing(clinical_condition) &  (maternal_reason == 4 | newborn_reason == 4)
label values clinical_condition maternal_reason_n
label variable clinical_condition "Highest maternal/newborn clinical severity"
tab clinical_condition, missing
order ID facility age_years married religion ethnicity respondent_education maternal_occupation partner_education partner_occup monthly_income household_size residence referral_stage referred_person clinical_condition maternal_reason newborn_reason baby_sex baby_ga referral_source source_f referral_destination purpose_referral decision_maker explain_clarity involved_in_decision referral_slip facility_communication pre_referral_treatment transport_arranged accompanied_by_hw transfer_instructions referral_compliance noncompliance_reason arrival_attended waiting_time_cat all_services_available referred_again adverse_outcome maternal_outcome maternal_complication preg_outcomes newborn_outcome newborn_complication self_decide_seek final_decision_maker money_required cost_influence insurance home_to_referral_time reach_difficulty trans_acces perceived_severity understand_consequence prioregative_experience responsibilities_affected treatment_confidence dx_m dx_b satsfn recomdn postdischarge_advice
logistic adverse_outcome clinical_condition
logistic adverse_outcome purpose_referral
logistic adverse_outcome i.purpose_referral
tab purpose_referral
codebook purpose_referral
logistic adverse_outcome ib4.purpose_referral
logistic adverse_outcome explain_clarity
logistic adverse_outcome referral_slip
logistic adverse_outcome i.explain_clarity
logistic adverse_outcome ib2.explain_clarity
logistic adverse_outcome facility_communication
logistic adverse_outcome pre_referral_treatment
logistic adverse_outcome i.pre_referral_treatment
logistic adverse_outcome ib3.pre_referral_treatment
logistic adverse_outcome transport_arranged
logistic adverse_outcome i.transport_arranged
logistic adverse_outcome i2.transport_arranged
logistic adverse_outcome ib2.transport_arranged
logistic adverse_outcome accompanied_by_hw
logistic adverse_outcome transfer_instructions
logistic adverse_outcome i.transfer_instructions
logistic adverse_outcome referral_compliance
logistic adverse_outcome arrival_attended
logistic adverse_outcome waiting_time_cat
logistic adverse_outcome time_to_depart_min
logistic adverse_outcome travel_time_min
logistic adverse_outcome self_decide_seek
logistic adverse_outcome i.self_decide_seek
logistic adverse_outcome money_required
logistic adverse_outcome cost_influence
logistic adverse_outcome insurance
logistic adverse_outcome home_to_referral_time
logistic adverse_outcome i.home_to_referral_time
logistic adverse_outcome reach_difficulty
logistic adverse_outcome trans_acces
logistic adverse_outcome perceived_severity
logistic adverse_outcome understand_consequence
logistic adverse_outcome treatment_confidence

logistic adverse_outcome trans_acces age_years





coefplot M1, ///
    eform ///
    drop(_cons) ///
    xline(1, lcolor(red) lpattern(dash)) ///
    xscale(log) ///
    xlabel(0.001 0.01 0.1 1 10) ///
    ciopts(lwidth(medium)) ///
    msymbol(circle) ///
    msize(medium) ///
    graphregion(color(white)) ///
    plotregion(color(white)) ///
    title("Multivariable Logistic Regression") ///
    subtitle("Referral Non-compliance") ///
    xtitle("Adjusted Odds Ratio (95% CI)")


























