# NJIT | DS636.852 Final Project
<hr>
This project was created to explore kaggle dataset [House_Prices](https://www.kaggle.com/competitions/house-prices-advanced-regression-techniques), and to implement Machine Learning techniques using R. The description of the dataset contain the following information:
<br>
<br>
<font color = "red">MSSubClass: Identifies the type of dwelling involved in the sale.</font>	

        20	1-STORY 1946 & NEWER ALL STYLES
        30	1-STORY 1945 & OLDER
        40	1-STORY W/FINISHED ATTIC ALL AGES
        45	1-1/2 STORY - UNFINISHED ALL AGES
        50	1-1/2 STORY FINISHED ALL AGES
        60	2-STORY 1946 & NEWER
        70	2-STORY 1945 & OLDER
        75	2-1/2 STORY ALL AGES
        80	SPLIT OR MULTI-LEVEL
        85	SPLIT FOYER
        90	DUPLEX - ALL STYLES AND AGES
       120	1-STORY PUD (Planned Unit Development) - 1946 & NEWER
       150	1-1/2 STORY PUD - ALL AGES
       160	2-STORY PUD - 1946 & NEWER
       180	PUD - MULTILEVEL - INCL SPLIT LEV/FOYER
       190	2 FAMILY CONVERSION - ALL STYLES AND AGES

<font color = "red">MSZoning: Identifies the general zoning classification of the sale.</font>
		
       A	Agriculture
       C	Commercial
       FV	Floating Village Residential
       I	Industrial
       RH	Residential High Density
       RL	Residential Low Density
       RP	Residential Low Density Park 
       RM	Residential Medium Density
	
<font color = "red">LotFrontage: Linear feet of street connected to property</font>

<font color = "red">LotArea: Lot size in square feet</font>

<font color = "red">Street: Type of road access to property</font>

       Grvl	Gravel	
       Pave	Paved
       	
<font color = "red">Alley: Type of alley access to property</font>

       Grvl	Gravel
       Pave	Paved
       NA 	No alley access
		
<font color = "red">LotShape: General shape of property</font>

       Reg	Regular	
       IR1	Slightly irregular
       IR2	Moderately Irregular
       IR3	Irregular
       
<font color = "red">LandContour: Flatness of the property</font>

       Lvl	Near Flat/Level	
       Bnk	Banked - Quick and significant rise from street grade to building
       HLS	Hillside - Significant slope from side to side
       Low	Depression
		
<font color = "red">Utilities: Type of utilities available</font>
		
       AllPub	All public Utilities (E,G,W,& S)	
       NoSewr	Electricity, Gas, and Water (Septic Tank)
       NoSeWa	Electricity and Gas Only
       ELO	Electricity only	
	
<font color = "red">LotConfig: Lot configuration</font>

       Inside	Inside lot
       Corner	Corner lot
       CulDSac	Cul-de-sac
       FR2	Frontage on 2 sides of property
       FR3	Frontage on 3 sides of property
	
<font color = "red">LandSlope: Slope of property</font>
		
       Gtl	Gentle slope
       Mod	Moderate Slope	
       Sev	Severe Slope
	
<font color = "red">Neighborhood: Physical locations within Ames city limits</font>

       Blmngtn	Bloomington Heights
       Blueste	Bluestem
       BrDale	Briardale
       BrkSide	Brookside
       ClearCr	Clear Creek
       CollgCr	College Creek
       Crawfor	Crawford
       Edwards	Edwards
       Gilbert	Gilbert
       IDOTRR	Iowa DOT and Rail Road
       MeadowV	Meadow Village
       Mitchel	Mitchell
       Names	North Ames
       NoRidge	Northridge
       NPkVill	Northpark Villa
       NridgHt	Northridge Heights
       NWAmes	Northwest Ames
       OldTown	Old Town
       SWISU	South & West of Iowa State University
       Sawyer	Sawyer
       SawyerW	Sawyer West
       Somerst	Somerset
       StoneBr	Stone Brook
       Timber	Timberland
       Veenker	Veenker
			
<font color = "red">Condition1: Proximity to various conditions</font>
	
       Artery	Adjacent to arterial street
       Feedr	Adjacent to feeder street	
       Norm	Normal	
       RRNn	Within 200' of North-South Railroad
       RRAn	Adjacent to North-South Railroad
       PosN	Near positive off-site feature--park, greenbelt, etc.
       PosA	Adjacent to postive off-site feature
       RRNe	Within 200' of East-West Railroad
       RRAe	Adjacent to East-West Railroad
	
<font color = "red">Condition2: Proximity to various conditions (if more than one is present)</font>
		
       Artery	Adjacent to arterial street
       Feedr	Adjacent to feeder street	
       Norm	Normal	
       RRNn	Within 200' of North-South Railroad
       RRAn	Adjacent to North-South Railroad
       PosN	Near positive off-site feature--park, greenbelt, etc.
       PosA	Adjacent to postive off-site feature
       RRNe	Within 200' of East-West Railroad
       RRAe	Adjacent to East-West Railroad
	
<font color = "red">BldgType: Type of dwelling</font>
		
       1Fam	Single-family Detached	
       2FmCon	Two-family Conversion; originally built as one-family dwelling
       Duplx	Duplex
       TwnhsE	Townhouse End Unit
       TwnhsI	Townhouse Inside Unit
	
<font color = "red">HouseStyle: Style of dwelling</font>
	
       1Story	One story
       1.5Fin	One and one-half story: 2nd level finished
       1.5Unf	One and one-half story: 2nd level unfinished
       2Story	Two story
       2.5Fin	Two and one-half story: 2nd level finished
       2.5Unf	Two and one-half story: 2nd level unfinished
       SFoyer	Split Foyer
       SLvl	Split Level
	
<font color = "red">OverallQual: Rates the overall material and finish of the house</font>

       10	Very Excellent
       9	Excellent
       8	Very Good
       7	Good
       6	Above Average
       5	Average
       4	Below Average
       3	Fair
       2	Poor
       1	Very Poor
	
<font color = "red">OverallCond: Rates the overall condition of the house</font>

       10	Very Excellent
       9	Excellent
       8	Very Good
       7	Good
       6	Above Average	
       5	Average
       4	Below Average	
       3	Fair
       2	Poor
       1	Very Poor
		
<font color = "red">YearBuilt: Original construction date</font>

<font color = "red">YearRemodAdd: Remodel date (same as construction date if no remodeling or additions)</font>

<font color = "red">RoofStyle: Type of roof</font>

       Flat	Flat
       Gable	Gable
       Gambrel	Gabrel (Barn)
       Hip	Hip
       Mansard	Mansard
       Shed	Shed
		
<font color = "red">RoofMatl: Roof material</font>

       ClyTile	Clay or Tile
       CompShg	Standard (Composite) Shingle
       Membran	Membrane
       Metal	Metal
       Roll	Roll
       Tar&Grv	Gravel & Tar
       WdShake	Wood Shakes
       WdShngl	Wood Shingles
		
<font color = "red">Exterior1st: Exterior covering on house</font>

       AsbShng	Asbestos Shingles
       AsphShn	Asphalt Shingles
       BrkComm	Brick Common
       BrkFace	Brick Face
       CBlock	Cinder Block
       CemntBd	Cement Board
       HdBoard	Hard Board
       ImStucc	Imitation Stucco
       MetalSd	Metal Siding
       Other	Other
       Plywood	Plywood
       PreCast	PreCast	
       Stone	Stone
       Stucco	Stucco
       VinylSd	Vinyl Siding
       Wd Sdng	Wood Siding
       WdShing	Wood Shingles
	
<font color = "red">Exterior2nd: Exterior covering on house (if more than one material)</font>

       AsbShng	Asbestos Shingles
       AsphShn	Asphalt Shingles
       BrkComm	Brick Common
       BrkFace	Brick Face
       CBlock	Cinder Block
       CemntBd	Cement Board
       HdBoard	Hard Board
       ImStucc	Imitation Stucco
       MetalSd	Metal Siding
       Other	Other
       Plywood	Plywood
       PreCast	PreCast
       Stone	Stone
       Stucco	Stucco
       VinylSd	Vinyl Siding
       Wd Sdng	Wood Siding
       WdShing	Wood Shingles
	
<font color = "red">MasVnrType: Masonry veneer type</font>

       BrkCmn	Brick Common
       BrkFace	Brick Face
       CBlock	Cinder Block
       None	None
       Stone	Stone
	
<font color = "red">MasVnrArea: Masonry veneer area in square feet</font>

<font color = "red">ExterQual: Evaluates the quality of the material on the exterior</font> 
		
       Ex	Excellent
       Gd	Good
       TA	Average/Typical
       Fa	Fair
       Po	Poor
		
<font color = "red">ExterCond: Evaluates the present condition of the material on the exterior</font>
		
       Ex	Excellent
       Gd	Good
       TA	Average/Typical
       Fa	Fair
       Po	Poor
		
<font color = "red">Foundation: Type of foundation</font>
		
       BrkTil	Brick & Tile
       CBlock	Cinder Block
       PConc	Poured Contrete	
       Slab	Slab
       Stone	Stone
       Wood	Wood
		
<font color = "red">BsmtQual: Evaluates the height of the basement</font>

       Ex	Excellent (100+ inches)	
       Gd	Good (90-99 inches)
       TA	Typical (80-89 inches)
       Fa	Fair (70-79 inches)
       Po	Poor (<70 inches
       NA	No Basement
		
<font color = "red">BsmtCond: Evaluates the general condition of the basement</font>

       Ex	Excellent
       Gd	Good
       TA	Typical - slight dampness allowed
       Fa	Fair - dampness or some cracking or settling
       Po	Poor - Severe cracking, settling, or wetness
       NA	No Basement
	
<font color = "red">BsmtExposure: Refers to walkout or garden level walls</font>

       Gd	Good Exposure
       Av	Average Exposure (split levels or foyers typically score average or above)	
       Mn	Mimimum Exposure
       No	No Exposure
       NA	No Basement
	
<font color = "red">BsmtFinType1: Rating of basement finished area</font>

       GLQ	Good Living Quarters
       ALQ	Average Living Quarters
       BLQ	Below Average Living Quarters	
       Rec	Average Rec Room
       LwQ	Low Quality
       Unf	Unfinshed
       NA	No Basement
		
<font color = "red">BsmtFinSF1: Type 1 finished square feet</font>

<font color = "red">BsmtFinType2: Rating of basement finished area (if multiple types)</font>

       GLQ	Good Living Quarters
       ALQ	Average Living Quarters
       BLQ	Below Average Living Quarters	
       Rec	Average Rec Room
       LwQ	Low Quality
       Unf	Unfinshed
       NA	No Basement

<font color = "red">BsmtFinSF2: Type 2 finished square feet</font>

<font color = "red">BsmtUnfSF: Unfinished square feet of basement area</font>

<font color = "red">TotalBsmtSF: Total square feet of basement area</font>

<font color = "red">Heating: Type of heating</font>
		
       Floor	Floor Furnace
       GasA	Gas forced warm air furnace
       GasW	Gas hot water or steam heat
       Grav	Gravity furnace	
       OthW	Hot water or steam heat other than gas
       Wall	Wall furnace
		
<font color = "red">HeatingQC: Heating quality and condition</font>

       Ex	Excellent
       Gd	Good
       TA	Average/Typical
       Fa	Fair
       Po	Poor
		
<font color = "red">CentralAir: Central air conditioning</font>

       N	No
       Y	Yes
		
<font color = "red">Electrical: Electrical system</font>

       SBrkr	Standard Circuit Breakers & Romex
       FuseA	Fuse Box over 60 AMP and all Romex wiring (Average)	
       FuseF	60 AMP Fuse Box and mostly Romex wiring (Fair)
       FuseP	60 AMP Fuse Box and mostly knob & tube wiring (poor)
       Mix	Mixed
		
<font color = "red">1stFlrSF: First Floor square feet</font>
 
<font color = "red">2ndFlrSF: Second floor square feet</font>

<font color = "red">LowQualFinSF: Low quality finished square feet (all floors)</font>

<font color = "red">GrLivArea: Above grade (ground) living area square feet</font>

<font color = "red">BsmtFullBath: Basement full bathrooms</font>

<font color = "red">BsmtHalfBath: Basement half bathrooms</font>

<font color = "red">FullBath: Full bathrooms above grade</font>

<font color = "red">HalfBath: Half baths above grade</font>

<font color = "red">Bedroom: Bedrooms above grade (does NOT include basement bedrooms)</font>

<font color = "red">Kitchen: Kitchens above grade</font>

<font color = "red">KitchenQual: Kitchen quality</font>

       Ex	Excellent
       Gd	Good
       TA	Typical/Average
       Fa	Fair
       Po	Poor
       	
<font color = "red">TotRmsAbvGrd: Total rooms above grade (does not include bathrooms)</font>

<font color = "red">Functional: Home functionality (Assume typical unless deductions are warranted)</font>

       Typ	Typical Functionality
       Min1	Minor Deductions 1
       Min2	Minor Deductions 2
       Mod	Moderate Deductions
       Maj1	Major Deductions 1
       Maj2	Major Deductions 2
       Sev	Severely Damaged
       Sal	Salvage only
		
<font color = "red">Fireplaces: Number of fireplaces</font>

<font color = "red">FireplaceQu: Fireplace quality</font>

       Ex	Excellent - Exceptional Masonry Fireplace
       Gd	Good - Masonry Fireplace in main level
       TA	Average - Prefabricated Fireplace in main living area or Masonry Fireplace in basement
       Fa	Fair - Prefabricated Fireplace in basement
       Po	Poor - Ben Franklin Stove
       NA	No Fireplace
		
<font color = "red">GarageType: Garage location</font>
		
       2Types	More than one type of garage
       Attchd	Attached to home
       Basment	Basement Garage
       BuiltIn	Built-In (Garage part of house - typically has room above garage)
       CarPort	Car Port
       Detchd	Detached from home
       NA	No Garage
		
<font color = "red">GarageYrBlt: Year garage was built</font>
		
<font color = "red">GarageFinish: Interior finish of the garage</font>

       Fin	Finished
       RFn	Rough Finished	
       Unf	Unfinished
       NA	No Garage
		
<font color = "red">GarageCars: Size of garage in car capacity</font>

<font color = "red">GarageArea: Size of garage in square feet</font>

<font color = "red">GarageQual: Garage quality</font>

       Ex	Excellent
       Gd	Good
       TA	Typical/Average
       Fa	Fair
       Po	Poor
       NA	No Garage
		
<font color = "red">GarageCond: Garage condition</font>

       Ex	Excellent
       Gd	Good
       TA	Typical/Average
       Fa	Fair
       Po	Poor
       NA	No Garage
		
<font color = "red">PavedDrive: Paved driveway</font>

       Y	Paved 
       P	Partial Pavement
       N	Dirt/Gravel
		
<font color = "red">WoodDeckSF: Wood deck area in square feet</font>

<font color = "red">OpenPorchSF: Open porch area in square feet</font>

<font color = "red">EnclosedPorch: Enclosed porch area in square feet</font>

<font color = "red">3SsnPorch: Three season porch area in square feet</font>

<font color = "red">ScreenPorch: Screen porch area in square feet</font>

<font color = "red">PoolArea: Pool area in square feet</font>

<font color = "red">PoolQC: Pool quality</font>
		
       Ex	Excellent
       Gd	Good
       TA	Average/Typical
       Fa	Fair
       NA	No Pool
		
<font color = "red">Fence: Fence quality</font>
		
       GdPrv	Good Privacy
       MnPrv	Minimum Privacy
       GdWo	Good Wood
       MnWw	Minimum Wood/Wire
       NA	No Fence
	
<font color = "red">MiscFeature: Miscellaneous feature not covered in other categories</font>
		
       Elev	Elevator
       Gar2	2nd Garage (if not described in garage section)
       Othr	Other
       Shed	Shed (over 100 SF)
       TenC	Tennis Court
       NA	None
		
<font color = "red">MiscVal: $Value of miscellaneous feature</font>

<font color = "red">MoSold: Month Sold (MM)</font>

<font color = "red">YrSold: Year Sold (YYYY)</font>

<font color = "red">SaleType: Type of sale</font>
		
       WD 	Warranty Deed - Conventional
       CWD	Warranty Deed - Cash
       VWD	Warranty Deed - VA Loan
       New	Home just constructed and sold
       COD	Court Officer Deed/Estate
       Con	Contract 15% Down payment regular terms
       ConLw	Contract Low Down payment and low interest
       ConLI	Contract Low Interest
       ConLD	Contract Low Down
       Oth	Other
		
<font color = "red">SaleCondition: Condition of sale</font>

       Normal	Normal Sale
       Abnorml	Abnormal Sale -  trade, foreclosure, short sale
       AdjLand	Adjoining Land Purchase
       Alloca	Allocation - two linked properties with separate deeds, typically condo with a garage unit	
       Family	Sale between family members
       Partial	Home was not completed when last assessed (associated with New Homes)

