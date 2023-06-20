/*Replication code for "The economic costs of temperature volatility: Evidence from US firms"
Luca Bettarelli, Davide Furceri, Michael Ganslmeier, Marc Tobias Schiffbauer
Submitted to Science.
/*Correspondence: Davide Furceri, DFurceri@imf.org*/
/******************************************************************************/
/******************************************************************************/
/*This file replicates the results presented in the paper, specifically Figs. 2-4 in "main text".*/
*/
******************************************************************
****************************Fig.2*********************************
******************************************************************
/*use the dataset compustat_temperature.dta and add Compustat variable "capxy"
*/
xtset gvkey2 yq
gen lncap=ln( capxy)
gen fcap=lncap-l.lncap
gen f1cap=f1.lncap-l.lncap
gen f2cap=f2.lncap-l.lncap
gen f3cap=f3.lncap-l.lncap
gen f4cap=f4.lncap-l.lncap
gen f5cap=f5.lncap-l.lncap
gen f6cap=f6.lncap-l.lncap
gen f7cap=f7.lncap-l.lncap
gen f8cap=f8.lncap-l.lncap
gen f9cap=f9.lncap-l.lncap
gen f10cap=f10.lncap-l.lncap
gen f11cap=f11.lncap-l.lncap
gen f12cap=f12.lncap-l.lncap
gen f13cap=f13.lncap-l.lncap
gen f14cap=f14.lncap-l.lncap
gen f15cap=f15.lncap-l.lncap
gen f16cap=f16.lncap-l.lncap
gen f17cap=f17.lncap-l.lncap
gen f18cap=f18.lncap-l.lncap
gen f19cap=f19.lncap-l.lncap
gen f20cap=f20.lncap-l.lncap

local shock "sdtemp"
local depvar "fcap"
foreach shock of local shock {
foreach v of local depvar {
foreach t in "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20"  {
xi: statsby _b _se e(r2_a), clear: reghdfe `v'_`t'  l(1/4)`shock' l(1/4)meantemp  l(1/4)`v'_0, absorb(gvkey2 yq) cluster(gvkey2)
}
}
}
******************************************************************
****************************Fig.3*********************************
******************************************************************
/*use the dataset compustat_temperature.dta and add Compustat variable "saleq"
*/
xtset gvkey2 yq
gen lnsale=ln(saleq)
gen fsale=lnsale-l.lnsale
gen f1sale=f.lnsale-l.lnsale
gen f2sale=f2.lnsale-l.lnsale
gen f3sale=f3.lnsale-l.lnsale
gen f4sale=f4.lnsale-l.lnsale
gen f5sale=f5.lnsale-l.lnsale
gen f6sale=f6.lnsale-l.lnsale
gen f7sale=f7.lnsale-l.lnsale
gen f8sale=f8.lnsale-l.lnsale
gen f9sale=f9.lnsale-l.lnsale
gen f10sale=f10.lnsale-l.lnsale
gen f11sale=f11.lnsale-l.lnsale
gen f12sale=f12.lnsale-l.lnsale
gen f13sale=f13.lnsale-l.lnsale
gen f14sale=f14.lnsale-l.lnsale
gen f15sale=f15.lnsale-l.lnsale
gen f16sale=f16.lnsale-l.lnsale
gen f17sale=f17.lnsale-l.lnsale
gen f18sale=f18.lnsale-l.lnsale
gen f19sale=f19.lnsale-l.lnsale
gen f20sale=f20.lnsale-l.lnsale

local shock "sdtemp"
local depvar "fsale"
foreach shock of local shock {
foreach v of local depvar {
foreach t in "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20"  {
xi: statsby _b _se e(r2_a), clear: reghdfe `v'_`t'  l(1/4)`shock' l(1/4)meantemp  l(1/4)`v'_0, absorb(gvkey2 yq) cluster(gvkey2)
}
}
}

******************************************************************
****************************Fig.4*********************************
******************************************************************
/*use the dataset compustat_temperature.dta and add Compustat variables "capxy, atq, chechy, lctq, ltq, cshoq, prccq, ceqq. 

AT: Total Assets; CHE: Cash and Short-Term Investment; LCT: Current Liabilities; LT: Total Liabilities; CSHO: Common Shares Outstanding; PRCC_F: Price Close-Annual-Fiscal; CEQ: Total Common/Ordinary Equity. All variables have been retrieved from Compustat, except age from Worldscope

*generate mediating variables (z in "nonlinear estimations" in Material and Methods in supplementary materials).

gen size=ln(atq)
gen liquidity=chechy/atq
gen maturity=lctq/ltq
gen tobinq=(atq+prccq*cshoq-ceqq)/atq
To compute "age", we use Worldscope age variables (incorpyear) and merge with Compustat.
We compute age as the difference between current period and incorpyear
*/
xtset gvkey2 yq
gen lncap=ln( capxy)
gen fcap=lncap-l.lncap
gen f1cap=f1.lncap-l.lncap
gen f2cap=f2.lncap-l.lncap
gen f3cap=f3.lncap-l.lncap
gen f4cap=f4.lncap-l.lncap
gen f5cap=f5.lncap-l.lncap
gen f6cap=f6.lncap-l.lncap
gen f7cap=f7.lncap-l.lncap
gen f8cap=f8.lncap-l.lncap
gen f9cap=f9.lncap-l.lncap
gen f10cap=f10.lncap-l.lncap
gen f11cap=f11.lncap-l.lncap
gen f12cap=f12.lncap-l.lncap
gen f13cap=f13.lncap-l.lncap
gen f14cap=f14.lncap-l.lncap
gen f15cap=f15.lncap-l.lncap
gen f16cap=f16.lncap-l.lncap
gen f17cap=f17.lncap-l.lncap
gen f18cap=f18.lncap-l.lncap
gen f19cap=f19.lncap-l.lncap
gen f20cap=f20.lncap-l.lncap

local smooth "age liquidity maturity size tobinq"
xtset gvkey2 yq
*********cross-firm normalization, with gamma=1.5
foreach var of local smooth {
bysort gvkey2: egen `var'_mean_time = mean(`var') 
egen `var'_mean_all = mean(`var'_mean_time)
bysort year: egen `var'_sd_time = sd(`var'_mean_time)
bysort gvkey2 (yq): gen `var'_norm = (`var'_mean_time - `var'_mean_all)/`var'_sd_time  	//  normalized z
bysort gvkey2 (yq): gen `var'_low = exp(-1.5*`var'_norm)/(1+exp(-1.5*`var'_norm))  	//  F(z)
bysort gvkey2 (yq): gen `var'_high = 1 - `var'_low      							//  [1-F(z)]
**********generate interactions between F(z) and shock and dependent variable
foreach shock in  "sdtemp" {
bysort gvkey2 (yq): gen `var'_h_`shock'=`var'_high*`shock'
bysort gvkey2 (yq): gen `var'_l_`shock'=`var'_low*`shock'
foreach dep in "fcap" {
bysort gvkey2 (yq): gen `dep'`var'_h_`shock'=`var'_high*`dep'_0
bysort gvkey2 (yq): gen `dep'`var'_l_`shock'=`var'_low*`dep'_0
}
}
}
***********estimations
foreach shock in  "sdtemp" {
foreach p of local smooth {
foreach dep in "fcap" {
forvalues k = 0/20 {

statsby _b _se e(r2_a), clear: reghdfe `dep'_`k'  l(1/4)`p'_l_`shock' l(1/4)`p'_h_`shock'  l(1/4)`dep'`p'_l_`shock' l(1/4)`dep'`p'_h_`shock' l(1/4)meantemp,  absorb(gvkey2 yq) cluster(gvkey2)
