clear

use "C:\Users\KELECHI\Documents\STATA\Stata_15.0x64\Files\ag_mod_g_cleaned_data.dta"

keep if inlist( Crop_variet , "MAIZE COMPOSITE/OPV", "MAIZE HYBRID", "MAIZE HYBRID RECYCLED", "MAIZE LOCAL" )

drop if missing( Crop_variet )

drop if Maize_variety == ""

drop if Cropping_systeam == ""

drop if Cropping_systeam == "Strip Intercrop"

drop if Cropping_systeam == "Row Intercrop"

drop if Cropping_systeam == "Relay Intercrop"

ta Agri_Shock

replace Agri_Shock = "None" if Agri_Shock == ""

replace Agri_Shock = "Yes" if Agri_Shock == "Diseases"

replace Agri_Shock = "Yes" if Agri_Shock == "Drought"
replace Agri_Shock = "Yes" if inlist( Agri_Shock, "Floods", "Insects", "Irregular Rains")

ta Agri_Shock

drop if Agri_Shock == "Fire"

drop if Agri_Shock == "Lack of hired labor"

drop if Agri_Shock == "Crop theft"

gen Maize_var = .

gen Crop_sys = .

gen Ag_Shock = .

label var Maize_var "Planted_hybrid"

label var Crop_sys "Practice_Purestand"

label var Ag_Shock "Encountered_shock"

ta Maize_var

ta Maize_variety

ta Cropping_systeam

ta Agri_Shock

replace Maize_var = 1 if Maize_variety == "IMPROVED"

replace Maize_var = 0 if Maize_variety == "LOCAL"

replace Crop_sys = 0 if Cropping_systeam == "Mixed stand"

replace Crop_sys = 1 if Cropping_systeam == "Pure stand / Sole"

replace Ag_Shock = 1 if Agri_Shock == "Yes"

replace Ag_Shock = 0 if Agri_Shock == "None"

codebook Maize_var Crop_sys Ag_Shock

label define maizevarlabel 1 "Hybrid" 0 "Local"

label value Maize_var maizevarlabel

label define croppingsys 1 "PureStand" 0 "Mixed"

label value Crop_sys croppingsys

label define shock 1 "Encountered" 0 "NotEncountered"
