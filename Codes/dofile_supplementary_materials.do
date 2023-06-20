/*Replication code for "The economic costs of temperature volatility: Evidence from US firms"
Luca Bettarelli, Davide Furceri, Michael Ganslmeier, Marc Tobias Schiffbauer
Submitted to Science.
/*Correspondence: Davide Furceri, DFurceri@imf.org*/
/******************************************************************************/
/******************************************************************************/
/*This file replicates results presented in the paper, specifically tables S1,S2,S4 and Figs. S2-32 in "supplementary materials"*/
*/
*****************************************************************
****************************table S1*****************************
*****************************************************************
/*use the dataset firm_uncertainty.dta 
we report regressions from column 1 to column 10
Coefficients are then multiplied by 100 in the article (as the variable is annual growth rate of firm-level uncertainty between t and t+1)
*/
reghdfe shock_realized_vol sdtemp_year , noabsorb  cluster(idcode)
reghdfe shock_realized_vol sdtemp_year , absorb(sic_2_digit) cluster(idcode)
reghdfe shock_realized_vol sdtemp_year , absorb(sic_2_digit year) cluster(idcode)
reghdfe shock_realized_vol sdtemp_year , absorb(gvkey) cluster(idcode)
reghdfe shock_realized_vol sdtemp_year , absorb(gvkey year) cluster(idcode)

reghdfe shock_realized_vol sdtemp_year meantemp_year, noabsorb  cluster(idcode)
reghdfe shock_realized_vol sdtemp_year meantemp_year, absorb(sic_2_digit) cluster(idcode)
reghdfe shock_realized_vol sdtemp_year meantemp_year, absorb(sic_2_digit year) cluster(idcode)
reghdfe shock_realized_vol sdtemp_year meantemp_year, absorb(gvkey) cluster(idcode)
reghdfe shock_realized_vol sdtemp_year meantemp_year, absorb(gvkey year) cluster(idcode)
*****************************************************************
****************************table S3*****************************
*****************************************************************
/*use the dataset compustat_temperature.dta and add Compustat variables "capxy, atq, chechy, lctq, ltq, cshoq, prccq, ceqq. 

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
********Compute f(z) by mean of cross firm normalization, and multiply it with temperature volatility
local smooth "size agenew liquidity mat tobin"
xtset gvkey2 yq
foreach var of local smooth {
bysort gvkey2: egen `var'_mean_time = mean(`var') 
egen `var'_mean_all = mean(`var'_mean_time)
bysort year: egen `var'_sd_time = sd(`var'_mean_time)
bysort gvkey2 (yq): gen `var'_norm = (`var'_mean_time - `var'_mean_all)/`var'_sd_time  	//  normalized z
bysort gvkey2 (yq): gen `var'_low = exp(-1.5*`var'_norm)/(1+exp(-1.5*`var'_norm))    		//  F(z)
}
local smooth "size agenew liquidity mat tobin"
xtset gvkey2 yq
foreach var of local smooth {
bysort gvkey2: gen l`var'=sdtemp*`var'_low
}
**********Estimations
local smooth "age liquidity matutiry size tobinq"
foreach shock in  "sdtemp" {
foreach p of local smooth {
foreach dep in "fcap" {
forvalues t = 0/20 {
xtset gvkey2 yq
statsby _b _se e(r2_a), clear: reghdfe fcap_`t'  l(1/4)sdtemp  l(1/4)lagenew l(1/4)lsize l(1/4)lliquidity l(1/4)lmat l(1/4)ltobin l(1/4)meantemp l(1/4)fcap_0,  absorb(gvkey2 yq) cluster(gvkey2) level(90)
}
}
}
}
******************************************************************
****************************table S4*****************************
******************************************************************
/*use the dataset compustat_temperature.dta and add Compustat variables "capxy, atq, chechy, lctq, ltq, cshoq, prccq, ceqq. 

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
***********Estimations
foreach shock in  "sdtemp" {
foreach p of local smooth {
foreach dep in "fcap" {
forvalues k = 0/20 {
statsby _b _se e(r2_a), clear: reghdfe `dep'_`k'  l(1/4)`p'_l_`shock' l(1/4)`p'_h_`shock'  l(1/4)`dep'`p'_l_`shock' l(1/4)`dep'`p'_h_`shock' l(1/4)meantemp,  absorb(gvkey2 yq) cluster(gvkey2)
test L.`p'_l_`shock'=L.`p'_h_`shock'
}
}
}
}

******************************************************************
****************************Fig.S2********************************
******************************************************************
/*use the dataset compustat_temperature.dta and add Compustat variables "capxy, ppentq"
where ppentq: net property, plant, and equipment.
gen inv_ratio=capxy*4/L.ppentq   /generate investment ratio to use it as dependent variable
*/ 
xtset gvkey2 yq
gen lninv=ln( inv_ratio)
gen finv=lninv-l.lninv
gen f1inv=f1.lninv-l.lninv
gen f2inv=f2.lninv-l.lninv
gen f3inv=f3.lninv-l.lninv
gen f4inv=f4.lninv-l.lninv
gen f5inv=f5.lninv-l.lninv
gen f6inv=f6.lninv-l.lninv
gen f7inv=f7.lninv-l.lninv
gen f8inv=f8.lninv-l.lninv
gen f9inv=f9.lninv-l.lninv
gen f10inv=f10.lninv-l.lninv
gen f11inv=f11.lninv-l.lninv
gen f12inv=f12.lninv-l.lninv
gen f13inv=f13.lninv-l.lninv
gen f14inv=f14.lninv-l.lninv
gen f15inv=f15.lninv-l.lninv
gen f16inv=f16.lninv-l.lninv
gen f17inv=f17.lninv-l.lninv
gen f18inv=f18.lninv-l.lninv
gen f19inv=f19.lninv-l.lninv
gen f20inv=f20.lninv-l.lninv

local shock "sdtemp"
local depvar "finv"
foreach shock of local shock {
foreach v of local depvar {
foreach t in "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20"  {
xi: statsby _b _se e(r2_a), clear: reghdfe `v'_`t'  l(1/4)`shock' l(1/4)meantemp  l(1/4)`v'_0, absorb(gvkey2 yq) cluster(gvkey2)
}
}
}
*****construct the impulse response functions on the basis of the coefficients associated with l.sdtemp
******************************************************************
****************************Fig.S3********************************
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
*****construct the impulse response functions on the basis of the coefficients associated with l.meantemp
******************************************************************
****************************Fig.S4********************************
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
xi: statsby _b _se e(r2_a), clear: reghdfe `v'_`t'  l(1/4)`shock' l(1/4)`v'_0, absorb(gvkey2 yq) cluster(gvkey2)
}
}
}
*****construct the impulse response functions on the basis of the coefficients associated with l.sdtemp
******************************************************************
****************************Fig.S5********************************
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
gen meantempsq=meantemp*meantemp*meantemp /*generate average temperature square*/
gen meantempcube=meantemp*meantemp*meantemp*meantemp /*generate average temperature cube*/
local shock "sdtemp"
local depvar "fcap"
foreach shock of local shock {
foreach v of local depvar {
foreach t in "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20"  {
xi: statsby _b _se e(r2_a), clear: reghdfe `v'_`t'  l(1/4)`shock' l(1/4)meantemp l.meantempsq l.meantempcube l(1/4)`v'_0, absorb(gvkey2 yq) cluster(gvkey2)
}
}
}
*****construct the impulse response functions on the basis of the coefficients associated with l.sdtemp
******************************************************************
****************************Fig.S6********************************
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
gen meantempsq=meantemp*meantemp*meantemp /*generate average temperature square*/
local shock "sdtemp"
local depvar "fcap"
foreach shock of local shock {
foreach v of local depvar {
foreach t in "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20"  {
xi: statsby _b _se e(r2_a), clear: reghdfe `v'_`t'  l(1/4)`shock' l(1/4)meantemp l.meantempsq l.meantempcube l(1/4)`v'_0, absorb(gvkey2 yq) cluster(gvkey2)
}
}
}
*****construct the impulse response functions on the basis of the coefficients associated with l.meantempsq
******************************************************************
****************************Fig.S7********************************
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
gen meantempsq=meantemp*meantemp*meantemp /*generate average temperature square*/
gen meantempcube=meantemp*meantemp*meantemp*meantemp /*generate average temperature cube*/
local shock "sdtemp"
local depvar "fcap"
foreach shock of local shock {
foreach v of local depvar {
foreach t in "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20"  {
xi: statsby _b _se e(r2_a), clear: reghdfe `v'_`t'  l(1/4)`shock' l(1/4)meantemp l.meantempsq l.meantempcube l(1/4)`v'_0, absorb(gvkey2 yq) cluster(gvkey2)
}
}
}
*****construct the impulse response functions on the basis of the coefficients associated with l.meantempcube
******************************************************************
****************************Fig.S8********************************
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
xi: statsby _b _se e(r2_a), clear: reghdfe `v'_`t'  l(1/4)`shock' l(1/4)meantemp l.min_temp l(1/4)`v'_0, absorb(gvkey2 yq) cluster(gvkey2)
}
}
}
*****construct the impulse response functions on the basis of the coefficients associated with l.sdtemp
******************************************************************
****************************Fig.S9********************************
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
xi: statsby _b _se e(r2_a), clear: reghdfe `v'_`t'  l(1/4)`shock' l(1/4)meantemp l.max_temp l(1/4)`v'_0, absorb(gvkey2 yq) cluster(gvkey2)
}
}
}
*****construct the impulse response functions on the basis of the coefficients associated with l.sdtemp
******************************************************************
****************************Fig.S10*******************************
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
xi: statsby _b _se e(r2_a), clear: reghdfe `v'_`t'  l(1/4)`shock' l(1/4)meantemp l.min_temp l(1/4)`v'_0, absorb(gvkey2 yq) cluster(gvkey2)
}
}
}
*****construct the impulse response functions on the basis of the coefficients associated with l.min_temp
******************************************************************
****************************Fig.S11*******************************
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
xi: statsby _b _se e(r2_a), clear: reghdfe `v'_`t'  l(1/4)`shock' l(1/4)meantemp l.max_temp l(1/4)`v'_0, absorb(gvkey2 yq) cluster(gvkey2)
}
}
}
*****construct the impulse response functions on the basis of the coefficients associated with l.max_temp


******************************************************************
****************************Fig.S12*******************************
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
xi: statsby _b _se e(r2_a), clear: reghdfe `v'_`t'  c.l(1/4)`shock'##manufnaics l(1/4)meantemp l(1/4)`v'_0, absorb(gvkey2 yq) cluster(gvkey2)
}
}
}
*****construct the impulse response functions on the basis of the coefficients associated with l.shock_manufnaics
local shock "sdtemp"
local depvar "fcap"
foreach shock of local shock {
foreach v of local depvar {
foreach t in "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20"  {
xi: statsby _b _se e(r2_a), clear: reghdfe `v'_`t'  c.l(1/4)`shock'##servicenaics l(1/4)meantemp l(1/4)`v'_0, absorb(gvkey2 yq) cluster(gvkey2)
}
}
}
*****construct the impulse response functions on the basis of the coefficients associated with l.shock_servicenaics
******************************************************************
****************************Fig.S13*******************************
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
xi: statsby _b _se e(r2_a), clear: reghdfe `v'_`t'  l(1/4)`shock' l(1/4)meantemp l(1/4)`v'_0, absorb(i.gvkey2#c.yq yq) cluster(gvkey2)
}
}
}
*****construct the impulse response functions on the basis of the coefficients associated with l.sdtemp
******************************************************************
****************************Fig.S14*******************************
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
xi: statsby _b _se e(r2_a), clear: reghdfe `v'_`t'  l(1/4)`shock' l(1/4)meantemp l(1/4)`v'_0, absorb(gvkey2#fqtr yq) cluster(gvkey2)
}
}
}
*****construct the impulse response functions on the basis of the coefficients associated with l.sdtemp
******************************************************************
****************************Fig.S15*******************************
******************************************************************
/*use the dataset compustat_temperature.dta and add Compustat variables "capxy, lactq, ltq"
gen maturity=lctq/ltq
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
xi: statsby _b _se e(r2_a), clear: reghdfe `v'_`t'  l(1/4)`shock' l(1/4)meantemp l.maturity l(1/4)`v'_0, absorb(gvkey yq) cluster(gvkey2)
}
}
}
*****construct the impulse response functions on the basis of the coefficients associated with l.sdtemp
******************************************************************
****************************Fig.S16*******************************
******************************************************************
/*use the dataset compustat_temperature.dta and add Compustat variable "capxy, atq"
gen size=ln(atq)
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
xi: statsby _b _se e(r2_a), clear: reghdfe `v'_`t'  l(1/4)`shock' l(1/4)meantemp l.size l(1/4)`v'_0, absorb(gvkey yq) cluster(gvkey2)
}
}
}
*****construct the impulse response functions on the basis of the coefficients associated with l.sdtemp
******************************************************************
****************************Fig.S17*******************************
******************************************************************
/*use the dataset compustat_temperature.dta and add Compustat variables "capxy, chechy, atq"
gen liquidity=chechy/atq
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
xi: statsby _b _se e(r2_a), clear: reghdfe `v'_`t'  l(1/4)`shock' l(1/4)meantemp l.liquidity l(1/4)`v'_0, absorb(gvkey yq) cluster(gvkey2)
}
}
}
*****construct the impulse response functions on the basis of the coefficients associated with l.sdtemp
******************************************************************
****************************Fig.S18*******************************
******************************************************************
/*use the dataset compustat_temperature.dta and add Compustat variable "capxy"
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
local shock "sdtemp"
local depvar "fcap"
foreach shock of local shock {
foreach v of local depvar {
foreach t in "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20"  {
xi: statsby _b _se e(r2_a), clear: reghdfe `v'_`t'  l(1/4)`shock' l(1/4)meantemp l.age l(1/4)`v'_0, absorb(gvkey yq) cluster(gvkey2)
}
}
}
*****construct the impulse response functions on the basis of the coefficients associated with l.sdtemp
******************************************************************
****************************Fig.S19*******************************
******************************************************************
/*use the dataset compustat_temperature.dta and add Compustat variables "capxy, atq"
gen tobinq=(atq+prccq*cshoq-ceqq)/atq
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
xi: statsby _b _se e(r2_a), clear: reghdfe `v'_`t'  l(1/4)`shock' l(1/4)meantemp l.tobinq l(1/4)`v'_0, absorb(gvkey yq) cluster(gvkey2)
}
}
}
*****construct the impulse response functions on the basis of the coefficients associated with l.sdtemp
******************************************************************
****************************Fig.S20*******************************
******************************************************************
/*use the dataset compustat_temperature.dta and add Compustat variables "capxy, atq, chechy, lctq, ltq, cshoq, prccq, ceqq. 

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
local shock "sdtemp"
local depvar "fcap"
foreach shock of local shock {
foreach v of local depvar {
foreach t in "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20"  {
xi: statsby _b _se e(r2_a), clear: reghdfe `v'_`t'  l(1/4)`shock' l(1/4)meantemp l.maturity l.liquidity l.size l.age l.tobinq l(1/4)`v'_0, absorb(gvkey2 yq) cluster(gvkey2)
}
}
}
*****construct the impulse response functions on the basis of the coefficients associated with l.sdtemp
******************************************************************
****************************Fig.S21*******************************
******************************************************************
/*use the dataset compustat_temperature.dta and add Compustat variables "capxy"
To exclude outliers (1 and 99 percentile of the distribution of the dependent variables

winsor2 capxy, cuts(1 99)
*Stata generates a new variable "capxy_w"
*/
xtset gvkey2 yq
gen lncapw=ln( capxy_w)
gen fcap=lncapw-l.lncapw
gen f1cap=f1.lncapw-l.lncapw
gen f2cap=f2.lncapw-l.lncapw
gen f3cap=f3.lncapw-l.lncapw
gen f4cap=f4.lncapw-l.lncapw
gen f5cap=f5.lncapw-l.lncapw
gen f6cap=f6.lncapw-l.lncapw
gen f7cap=f7.lncapw-l.lncapw
gen f8cap=f8.lncapw-l.lncapw
gen f9cap=f9.lncapw-l.lncapw
gen f10cap=f10.lncapw-l.lncapw
gen f11cap=f11.lncapw-l.lncapw
gen f12cap=f12.lncapw-l.lncapw
gen f13cap=f13.lncapw-l.lncapw
gen f14cap=f14.lncapw-l.lncapw
gen f15cap=f15.lncapw-l.lncapw
gen f16cap=f16.lncapw-l.lncapw
gen f17cap=f17.lncapw-l.lncapw
gen f18cap=f18.lncapw-l.lncapw
gen f19cap=f19.lncapw-l.lncapw
gen f20cap=f20.lncapw-l.lncapw
local shock "sdtemp"
local depvar "fcap"
foreach shock of local shock {
foreach v of local depvar {
foreach t in "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20"  {
xi: statsby _b _se e(r2_a), clear: reghdfe `v'_`t'  l(1/4)`shock' l(1/4)meantemp l(1/4)`v'_0, absorb(gvkey2 yq) cluster(gvkey2)
}
}
}
*****construct the impulse response functions on the basis of the coefficients associated with l.sdtemp
******************************************************************
****************************Fig.S22*******************************
******************************************************************
/*use the dataset compustat_temperature.dta and add Compustat variables "capxy"
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
gen lsdtemp=ln(sdtemp)
local shock "lsdtemp"
local depvar "fcap"
foreach shock of local shock {
foreach v of local depvar {
foreach t in "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20"  {
xi: statsby _b _se e(r2_a), clear: reghdfe `v'_`t'  l(1/4)`shock' l(1/4)meantemp l(1/4)`v'_0, absorb(gvkey2 yq) cluster(gvkey2)
}
}
}
*****construct the impulse response functions on the basis of the coefficients associated with l.lsdtemp
******************************************************************
****************************Fig.S23*******************************
******************************************************************
/*use the dataset compustat_temperature.dta and add Compustat variables "capxy"
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
gen maxmin_temp=max_temp-min_temp
local shock "maxmin_temp"
local depvar "fcap"
foreach shock of local shock {
foreach v of local depvar {
foreach t in "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20"  {
xi: statsby _b _se e(r2_a), clear: reghdfe `v'_`t'  l(1/4)`shock' l(1/4)meantemp l(1/4)`v'_0, absorb(gvkey2 yq) cluster(gvkey2)
}
}
}
*****construct the impulse response functions on the basis of the coefficients associated with l.maxmin_temp
******************************************************************
****************************Fig.S24*******************************
******************************************************************
/*use the dataset compustat_temperature.dta and add Compustat variables "capxy"
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
xi: statsby _b _se e(r2_a), clear: reghdfe `v'_`t'  l(1/2)`shock' l(1/2)meantemp l(1/2)`v'_0, absorb(gvkey2 yq) cluster(gvkey2)
}
}
}
*****construct the impulse response functions on the basis of the coefficients associated with l.sdtemp
******************************************************************
****************************Fig.S25*******************************
******************************************************************
/*use the dataset compustat_temperature.dta and add Compustat variables "capxy"
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
xi: statsby _b _se e(r2_a), clear: reghdfe `v'_`t'  l(1/3)`shock' l(1/3)meantemp l(1/3)`v'_0, absorb(gvkey2 yq) cluster(gvkey2)
}
}
}
*****construct the impulse response functions on the basis of the coefficients associated with l.sdtemp
******************************************************************
****************************Fig.S26*******************************
******************************************************************
/*use the dataset compustat_temperature.dta and add Compustat variables "capxy"
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
xi: statsby _b _se e(r2_a), clear: reghdfe `v'_`t'  l(0/4)`shock' l(0/4)meantemp l(0/4)`v'_0, absorb(gvkey2 yq) cluster(gvkey2)
}
}
}
*****construct the impulse response functions on the basis of the coefficients associated with l.sdtemp
******************************************************************
****************************Fig.S27*******************************
******************************************************************
/*use the dataset compustat_temperature.dta and add Compustat variables "capxy"
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
xi: statsby _b _se e(r2_a), clear: reghdfe `v'_`t'  l(1/4)`shock' f(0/20)`shock' l(1/4)meantemp l(1/4)`v'_0, absorb(gvkey2 yq) cluster(gvkey2)
}
}
}
*****construct the impulse response functions on the basis of the coefficients associated with l.sdtemp
******************************************************************
****************************Fig.S28*******************************
******************************************************************
/*use the dataset compustat_temperature.dta and add Compustat variables "capxy"
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
/*compute quartiles of sdtemp*/
egen sd25=pctile(sdtemp), p(25)
egen sd50=pctile(sdtemp), p(50)
egen sd75=pctile(sdtemp), p(75)
/*generate dummies based on quartiles*/
gen dummy1pc=0
replace dummy1pc=1 if sdtemp<=sd25
gen dummy2pc=0
replace dummy2pc=1 if sdtemp>sd25 & sdtemp<=sd50
gen dummy3pc=0
replace dummy3pc=1 if sdtemp>sd50 & sdtemp<=sd75
gen dummy4pc=0
replace dummy4pc=1 if sdtemp>sd75
/*generate interactions between dummies based on quartiles and temperature volatility*/
gen sdtemp_1pc=sdtemp*dummy1pc
gen sdtemp_2pc=sdtemp*dummy2pc
gen sdtemp_3pc=sdtemp*dummy3pc
gen sdtemp_4pc=sdtemp*dummy4pc
*estiamtion
local depvar "fcap"
foreach v of local depvar {
foreach t in "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20"  {
xi: statsby _b _se e(r2_a), clear: reghdfe `v'_`t'  l(1/4)sdtemp_1pc l(1/4)sdtemp_2pc l(1/4)sdtemp_3pc l(1/4)sdtemp_4pc l(1/4)meantemp l(1/4)`v'_0, absorb(gvkey2 yq) cluster(gvkey2)
}
}
*****construct the impulse response functions on the basis of the coefficients associated with l.sdtemp_1pc, l.sdtemp_2pc, l.sdtemp_3pc, l.sdtemp_4pc
******************************************************************
****************************Fig.S29*******************************
******************************************************************
/*use the dataset compustat_temperature.dta and add Compustat variables "capxy"
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
/*evolution of temperature volatility between 1990 and 2018*/
sort gvkey2 year
bysort gvkey2 year: egen sdtemp_y=mean(sdtemp)
bysort gvkey2:gen sdtemp_y90=sdtemp_y if year==1990
bysort gvkey2:gen sdtemp_y18=sdtemp_y if year==2018
sort gvkey2 year
bysort gvkey2:replace sdtemp_y90= sdtemp_y90[_n-1] if missing(sdtemp_y90)
bysort gvkey2:replace sdtemp_y18= sdtemp_y18[_n-1] if missing(sdtemp_y18)
gsort -year
bysort gvkey2:replace sdtemp_y90= sdtemp_y90[_n-1] if missing(sdtemp_y90)
bysort gvkey2:replace sdtemp_y18= sdtemp_y18[_n-1] if missing(sdtemp_y18)
sort gvkey2 year
bysort gvkey2:gen sdtemp_change=sdtemp_y18-sdtemp_y90
/*compute quartiles of sevolution of temperature volatility between 1990 and 2018 in the sample*/
egen temp_change25=pctile(sdtemp_change), p(25)
egen temp_change50=pctile(sdtemp_change), p(50)
egen temp_change75=pctile(sdtemp_change), p(75)
/*generate dummies based on quartiles*/
gen dummy1pc=0
replace dummy1pc=1 if sdtemp_change<=temp_change25
gen dummy2pc=0
replace dummy2pc=1 if sdtemp_change>temp_change25 & sdtemp_change<=temp_change50
gen dummy3pc=0
replace dummy3pc=1 if sdtemp_change>temp_change50 & sdtemp_change<=temp_change75
gen dummy4pc=0
replace dummy4pc=1 if sdtemp_change>temp_change75
/*generate interactions between dummies based on quartiles and temperature volatility*/
gen sdtemp_1pc=sdtemp*dummy1pc
gen sdtemp_2pc=sdtemp*dummy2pc
gen sdtemp_3pc=sdtemp*dummy3pc
gen sdtemp_4pc=sdtemp*dummy4pc
*estiamtion
local depvar "fcap"
foreach v of local depvar {
foreach t in "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20"  {
xi: statsby _b _se e(r2_a), clear: reghdfe `v'_`t'  l(1/4)sdtemp_1pc l(1/4)sdtemp_2pc l(1/4)sdtemp_3pc l(1/4)sdtemp_4pc l(1/4)meantemp l(1/4)`v'_0, absorb(gvkey2 yq) cluster(gvkey2)
}
}
*****construct the impulse response functions on the basis of the coefficients associated with l.sdtemp_1pc, l.sdtemp_2pc, l.sdtemp_3pc, l.sdtemp_4pc
******************************************************************
****************************Fig.S30*******************************
******************************************************************
/*use the dataset compustat_temperature.dta and add Compustat variables "capxy, atq, chechy, lctq, ltq, cshoq, prccq, ceqq. 

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
}
}
}
}
******************************************************************
****************************Fig.S31*******************************
******************************************************************
/*use the dataset compustat_temperature.dta and add Compustat variables "capxy, atq, chechy, lctq, ltq, cshoq, prccq, ceqq. 

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
local smooth "age liquidity matutiry size tobinq"
*********cross-firm normalization based on first value in the sample, with gamma=1.5
xtset gvkey2 yq
foreach var of local smooth {	
bysort gvkey2 : gen countnonmissing_`var' = sum(!missing(`var')) if !missing(`var')
bysort gvkey2 (countnonmissing_`var'): gen `var'_first = `var'[1]
egen `var'_mean_all=mean(`var'_first)
bysort yq: egen `var'_sd_time = sd(`var'_first)
bysort gvkey2 (yq): gen `var'_norm = (`var'_first - `var'_mean_all)/`var'_sd_time  	//  normalized z
bysort gvkey2 (yq): gen `var'_low = exp(-1.5*`var'_norm)/(1+exp(-1.5*`var'_norm))    		//  F(z)
bysort gvkey2 (yq): gen `var'_high = 1 - `var'_low      									//  [1-F(z)]
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
statsby _b _se e(r2_a), clear: reghdfe `dep'_`k'  l(1/4)`p'_l_`shock' l(1/4)`p'_h_`shock'  l(1/4)`dep'`p'_l_`shock' l(1/4)`dep'`p'_h_`shock'  l(1/4)meantemp ,  absorb(gvkey2 yq) cluster(gvkey2)
}
}
}
}
******************************************************************
****************************Fig.S32*******************************
******************************************************************
/*use the dataset compustat_temperature.dta and add Compustat variables "capxy, atq, chechy, lctq, ltq, cshoq, prccq, ceqq. 

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
*********cross-firm normalization based on dummies
local smooth "age liquidity matutiry size tobinq"
foreach var of local smooth {
bysort gvkey2: egen `var'_mean = mean(`var') 
bysort yq:egen `var'_mean_tot = mean(`var'_mean) 
gen high_`var'=0
replace high_`var'=1 if `var'_mean>=`var'_mean_tot & `var'_mean!=.
gen low_`var'=1-high_`var'
gen h`var'=high_`var'*sdtemp
gen l`var'=low_`var'*sdtemp
}
************Estimations
local smooth "age liquidity matutiry size tobinq"
foreach shock in  "sdtemp" {
foreach p of local smooth {
foreach dep in "fcap" {
forvalues k = 0/20 {
xtset gvkey2 yq
statsby _b _se e(r2_a), clear: reghdfe `dep'_`k'  l(1/4)l`p' l(1/4)h`p'  l(1/4)meantemp l(1/4)`dep'_0,  absorb(gvkey2 yq) cluster(gvkey2)
}
}
}
}
