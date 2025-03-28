/* intergrated household survey(ihs) is a long term household data collection exercise by National Statistics office
data colecte iclude more than demographic, social economic, agriculture, institutional and access to different infrastructes 
this data cleaning excercise is a practice to identify and sellect some variables of interest, 

*/
*first we import IHS5 Agriculture Production module dataset that contains crops planted and yield.
import delimited "E:\Agri-Economics\YEAR 4 SEMESTER 1\AHD ANALYSIS\Databases\MWI_2019_IHS-V_v06_M_CSV\Agriculture\ag_mod_g.csv"

*we want to have a quick overview of the variables and data we have in each variable
describe

*we have noticed most variables have no label and also the data has many variables which might not be important during analyisis, so first we will select all
*variables on crop planted and output using the survey quetion documentation
list crop_code ag_g0a ag_g0e_1 ag_g01 ag_g02 ag_g03 ag_g13a ag_g13b in 1/10

*then we will only keep the variables we will workon
keep crop_code ag_g0a ag_g0e_1 ag_g01 ag_g13a ag_g13b

*next we will change the var name to reflect the contents
rename (crop_code ag_g0a ag_g0e_1 ag_g01 ag_g13a ag_g13b) (crop_name planted_or_not crop_type cropping_type harvested_yield yield_unit)

*we follow it up with adding var labels
label var crop_name "name of crop"
label var planted_or_not "whether it was planted or not"
label var crop_type "either local or hybrid"
label var cropping_type "systeam of cropping"
label var harvested_yield "amount of harvest"
label var yield_unit "harvested yield unit"

*just like an if statement, the following code will only keep Maize, Beans and Groundnuts, but first we can also see all the unique values in crop_name and its distribution
tabulate crop_name

describe

keep if inlist(crop_name, "MAIZE COMPOSITE/OPV", "MAIZE HYBRID", "MAIZE HYBRID RECYCLED", "MAIZE LOCAL", "BEANS", "GROUNDNUT CG7", "GROUNDNUT CHALIMBANA", "GROUNDNUT MANI-PINTAR", "GROUNDNUT MAWANGA")
*after running the above code, some variables will be deleted, we can also repeat the tabulate code to really see if it has worked

tabulate crop_name
*at first we had 32651 values now we are remaining with 15871. and we now also remaining with maize, beans and groundnuts observations

*next we will work to identify missing values.
codebook
*it showed we have some missing values including blacks. 
*in the first 4 columns,we cannot replace any missing with any values because it cannot be determined,
*so we will delete all missing
drop if missing(crop_name, planted_or_not, crop_type, cropping_type)

*in last columns, missing or black will assume the farmer did not harvest, so we can either replace with 0
replace harvested_yield = 0 if harvested_yield == .
replace yield_unit = "none" if yield_unit == ""

*after replacing missing values and removing others, we can excute codebook code to verify. apart from that our data is ready for analysis.

*theb we will go on and save the current data to a new dta stata file extension.
save data_1

*Next we will exprole Fcators of Production,we will first clear the workspace and import the dataset.


clear

import delimited "E:\Agri-Economics\YEAR 4 SEMESTER 1\AHD ANALYSIS\Databases\MWI_2019_IHS-V_v06_M_CSV\Agriculture\ag_mod_d.csv"
* the dataset include most of factores of production, labour, inputs, land etc
*we will goon and select relevant data.
keep ag_d14 ag_d20a ag_d20b ag_d20c ag_d20d ag_d20e ag_d28a ag_d36 ag_d37a ag_d37b ag_d38 ag_d39a ag_d39b ag_d39c ag_d39f ag_d39g ag_d39h ag_d39i ag_d40 ag_d41a ag_d41a_oth ag_d41b ag_d41c

*then we will rename the variables

rename (ag_d14 ag_d20a ag_d20b ag_d20c ag_d20d ag_d20e ag_d28a ag_d36 ag_d37a ag_d37b ag_d38 ag_d39a ag_d39b ag_d39c ag_d39f ag_d39g ag_d39h ag_d39i ag_d40 ag_d41a ag_d41a_oth ag_d41b ag_d41c) (garden_usage first_crop second_crop third_crop forth_crop fifth_crop irrig_syst used_org_fert org_fert_quant org_fert_unit used_innorg_fert inorg_fert_type first_app_qunt faq_unit second_inorg_fert sif_type sif_quntity sifq_unit used_pesticides pestcides_amount pestcides_name pestcides_qunt pestcides_q_unit)

*since we are only concerned about those who cultivated maize, beans and g/nuts, we will filter out those who did not cultivate their lands.

tabulate garden_usage

keep if garden_usage == "Cultivated"

keep if inlist(crop_name, "MAIZE COMPOSITE/OPV", "MAIZE HYBRID", "MAIZE HYBRID RECYCLED", "MAIZE LOCAL", "BEANS", "GROUNDNUT CG7", "GROUNDNUT CHALIMBANA", "GROUNDNUT MANI-PINTAR", "GROUNDNUT MAWANGA")

*then we have also noted a lot of black spaces in second crop, third crop , forth crop and fifth, which means the farmer dint grow,so we will replace that with "none" because we still need those farmers who grew the first crop.
replace second_crop = "none" if second_crop == ""
replace third_crop = "none" if third_crop == ""
replace forth_crop = "none" if forth_crop == ""
replace fifth_crop = "none" if fifth_crop == ""

*then we will look at fertilizers, both organic and inorganic , we will assume if their is black or missing value, then the farmer did not apply so we will replace with "None", and 0 on its quantity, including pestcides and other factors of production
replace inorg_fert_type = "none" if inorg_fert_type == ""
replace sif_type = "none" if sif_type == ""
replace pestcides_name = "none" if pestcides_name == ""

* we will also do the same for quantity and quantity units but we will replace "none" with zero since they are intergers.

*after finishing,we will export the data.

save data_2


*next we will look at demographics.
clear

import delimited "E:\Agri-Economics\YEAR 4 SEMESTER 1\AHD ANALYSIS\Databases\MWI_2019_IHS-V_v06_M_CSV\Demographics\HH_MOD_B.csv"

keep hh_b03 hh_b04 hh_b05a hh_b10a hh_b10b hh_b18 hh_b22 hh_b23 hh_b24

rename (hh_b03 hh_b04 hh_b05a hh_b10a hh_b10b hh_b18 hh_b22 hh_b23 hh_b24) (sex relation_to_head age district country education_qualification language religion marintal_status)

label var sex "sex"
label var relation_to_head "relation_to_house_head"
label var age "age"
label var district "home district"
label var country "country of origin"
label var education_qualification "highest education quali"
label var language "native language"
label var religion "religion"
label var marintal_status "marintal status"

*we will check for missing observations in sex and relation to head category.
codebook sex
*we have noticed two unique values thats male and female thus we will drop any obeservation which is not one of above

drop if sex != "FEMALE" & sex != "MALE"

tabulate relation_to_head
*we want to see how many special characters we have, and we have also noticed we have no missing observations

codebook age
drop if missing(age)
*zero changes made meaning age had no missing observation

tabulate district
*we notice district had a lot of missing obesrvations, if we delete them it might affect data presentation, so we will just input undisclosed on any missing obseevations

replace district = "undisclosed" if district == ""

*the same with country, religion, education, language

replace country = "undisclosed" if country == ""
replace education_qualification = "undisclosed" if education_qualification == ""
replace language = "undisclosed" if language == ""
replace religion = "undisclosed" if religion == ""

*on age, we will assume anyone less than 15 years is not married, so we will replace missing observation with "not married" if age is less than 15
replace marintal_status = "Not Married" if age <= 15
*but above that any missing observation will be undisclosed

replace marintal_status = "Undisclosed" if marintal_status == ""

save data_3

clear



*Now we will look at Social Economic Factors

*we will start with household consuption.
import delimited "E:\Agri-Economics\YEAR 4 SEMESTER 1\AHD ANALYSIS\Databases\MWI_2019_IHS-V_v06_M_CSV\Socio_economic\HH_MOD_G2.csv"

drop case_id hhid

rename ( hh_g08a hh_g08b hh_g08c hh_g08d hh_g08e hh_g08f hh_g08g hh_g08h hh_g08i hh_g08j ) (Consuption_of_CGC Consuption_of_RTP Consuption_of_NP Consuption_of_Vege Consuption_of_MFA_pr Consuption_of_Fruits Consuption_of_milk Consuption_of_Fats Consuption_of_Sugars Consuption_of_Spices )

label var Consuption_of_CGC "Cereal, creal products and grains"
label var Consuption_of_RTP "roots, tubers and plantains"
label var Consuption_of_NP "nuts and pulses"
label var Consuption_of_Vege "vegetables"
label var Consuption_of_MFA_pr "meant, fish and animal products"
label var Consuption_of_Fruits "fruits"
label var Consuption_of_milk "milk and its products"
label var Consuption_of_Fats "fats and oils"
label var Consuption_of_Sugars "sugars, honey"
label var Consuption_of_Spices "spices, condiments"

describe
*all values are intergers

codebook
*values range from 0 to 7.
*we dont have a lot of missing observations in this data, so we will just delete the observations since replacing it with 0 will mean the family did not eat it for the past week which can affect the outcome of analysis.

drop if !inlist( Consuption_of_CGC, 0,1,2,3,4,5,6,7)
*(0 observations deleted)

drop if !inlist( Consuption_of_RTP , 0,1,2,3,4,5,6,7)
*(1 observation deleted)

drop if !inlist( Consuption_of_NP , 0,1,2,3,4,5,6,7)
*(0 observations deleted)

drop if !inlist( Consuption_of_Vege , 0,1,2,3,4,5,6,7)
*(0 observations deleted)

drop if !inlist( Consuption_of_MFA_pr , 0,1,2,3,4,5,6,7)
*(0 observations deleted)

drop if !inlist( Consuption_of_Fruits , 0,1,2,3,4,5,6,7)
*(0 observations deleted)

drop if !inlist( Consuption_of_milk , 0,1,2,3,4,5,6,7)
*(0 observations deleted)

drop if !inlist( Consuption_of_Fats , 0,1,2,3,4,5,6,7)
(1 observation deleted)

drop if !inlist( Consuption_of_Sugars , 0,1,2,3,4,5,6,7)
*(1 observation deleted)

drop if !inlist( Consuption_of_Spices , 0,1,2,3,4,5,6,7)
*(1 observation deleted)

save data_4

clear

*we will import another Social Economic data
import delimited "E:\Agri-Economics\YEAR 4 SEMESTER 1\AHD ANALYSIS\Databases\MWI_2019_IHS-V_v06_M_CSV\Socio_economic\HH_MOD_I1.csv"

drop case_id hhid

rename ( hh_i01 hh_i02 hh_i03) (Purchased_iteam name_of_iteam cost)

describe

tabulate Purchased_iteam

codebook purchased_iteam

drop if !inlist(Purchased_iteam, "No", "Yes")

label var Purchased_iteam "Whether Purchased or not"
label var name_of_iteam "iteam name"
label var cost "price of iteam"

replace cost = 0 if Purchased_iteam == "No"
*noticed a lot of missing observation on cost var, so the above code replaced every obeservation on cost with 0 if the person did not make a purchase, which of cause makes sense.

save data_5

clear


clear

*lets explore distance variables

import delimited "E:\Agri-Economics\YEAR 4 SEMESTER 1\AHD ANALYSIS\Databases\MWI_2019_IHS-V_v06_M_CSV\Distance var\householdgeovariables_ihs5.csv"

drop case_id ea_id sq1 sq2 sq3 sq4 sq5 sq6 sq7 af_bio_1_x af_bio_8_x af_bio_12_x af_bio_13_x af_bio_16_x afmnslp_pct srtm_1k popdensity cropshare h2018_tot h2018_wetqstart h2018_wetq h2019_tot h2019_wetqstart h2019_wetq anntot_avg wetq_avgstart wetq_avg h2018_ndvi_avg twi_mwi ssa_aez09 h2018_ndvi_max h2019_ndvi_avg h2019_ndvi_max ndvi_avg ndvi_max ea_lat_mod ea_lon_mod

*we have remained with a few importat disatnce variables which have definitive var names, thus we will only add labels

label var dist_road "distance to main road"

label var dist_agmrkt "distance to agri market"

label var dist_auction "distance to auction"

label var dist_admarc "distance to admarc"

label var dist_border "distance to boarder"

label var dist_popcenter "distance to trading centre"

label var dist_boma "distance to boma"

describe
*the data is all numbers
codebook 
 
*we will delete all missing variables since distance caanot be determined.

drop if missing( dist_road)
*(8 observations deleted)
drop if missing( dist_agmrkt)
*(0 observations deleted)
drop if missing( dist_auction)
*(0 observations deleted)
drop if missing( dist_admarc)
*(0 observations deleted)
drop if missing( dist_border)
*(0 observations deleted)
drop if missing( dist_popcenter)
*(0 observations deleted)
drop if missing( dist_boma)
(0 observations deleted)

save data_6


clear
