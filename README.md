# temperature_volatilityUSfirms
Replication code for “The economic costs of temperature volatility: Evidence from US firms”
Luca Bettarelli, Davide Furceri, Michael Ganslmeier, Marc Tobias Schiffbauer
Submitted to Science
June, 2023


This replication package includes information on data and codes in Stata v17 to replicate Tables and Figures presented in the article “The economic costs of temperature volatility: Evidence from US firms”, submitted to Science. Firm-level data retrieved from Compustat are not directly included in the replication package, as they are not publicly available. Compustat is a comprehensive corporate financial dataset published by Standard and Poor’s. Data can be acquired from S&P Global (https://www.marketplace.spglobal.com/en/datasets/compustat-financials-(8)). The replication package includes temperature data, and firm-level uncertainty data, and it precisely specifies what variables from Compustat have been used, as well as any modification to original variables. Note that replication codes refer to each regression performed to construct impulse response functions, while you may want to use your own codes to translate them into charts.  

The replication package includes the following files:

•	1_compustat_temperature: Stata v.17 dataset used to run all regressions except table S1 in supplementary materials. It contains quarterly data at firm-level from 1961Q1 to 2018Q4, firms’ ID and temperature data (i.e., temperature volatility, average temperature, minimum and maximum temperature) associated with each firm. Firms’ ID should be used to merge with Compustat.
•	2_firm_uncertainty: Stata v.17 dataset used to run regressions in table S1, in supplementary materials. It contains yearly data from 1992 to 2019, firms’ ID, a measure of firm-level uncertainty from Alfaro et al. (2022) and temperature data (i.e., temperature volatility, average temperature) associated with each firm.
•	3_dofile_main_text: replication codes for Figs. 2-4 in Main Text.
•	4_dofile_supplementary_materials: replication codes for table S1, S2 and S4, and Figs. S2-S32 in supplementary materials.

CODEBOOK 

DATASET: 1_compustat_temperature
gvkey: firm-level identifier from Compustat (string variable).
gvkey2: encoded firm-level identifier gvkey.
year: current year; from 1961 to 2018.
fqtr: current quarter; from 1 to 4.
yq: current year/quarter; from 1961Q1 to 2018Q4.
sdtemp: temperature volatility at firm/quarter level.
meantemp: average temperature at firm/quarter level.
min_temp: minimum temperature at firm/quarter level.
max_temp: maximum temperature at firm/quarter level.
manufnaics: a dummy equal to one if firm’s 4-digit North American Industry Classification System (NAICS) code is manufacturing.
servicenaics: a dummy equal to one if firm’s 4-digit North American Industry Classification System (NAICS) code is service.

2_firm_uncertainty

gvkey: firm-level identifier from Compustat (string variable).
idcode: encoded firm-level identifier gvkey.
year: current year; from 1992 to 2019.
sdtemp_year: firm-level temperature volatility for firm i, at year t. 
meantemp_year: firm-level average temperature for firm i, at year t.
shock_realized_vol: annual growth rates of firm realized volatility, estimated as the annualized 12-month standard deviation of daily CRSP returns (typically spanning 252 days of trading return data in a year, 200 minimum).
sic_2_digit: year-by-year 2-digit Standard Industrial Classifications (SIC) code.


