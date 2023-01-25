
#load required libraries
library(COINr)
library(readxl)

#read in the data from a pre-prepared spreadsheet
WS_iData <- read_excel("C:/Users/skrautzi/Desktop/WS_Index_Lit/coin-dummy/data-table/WS_input_sheets.xlsx", sheet = "IndData")
WS_iMeta <- read_excel("C:/Users/skrautzi/Desktop/WS_Index_Lit/coin-dummy/data-table/WS_input_sheets.xlsx", sheet = "IndMeta")
WS_aMeta <- read_excel("C:/Users/skrautzi/Desktop/WS_Index_Lit/coin-dummy/data-table/WS_input_sheets.xlsx", sheet = "AggMeta")
#change
#view dataframes
WS_iData
WS_iMeta
WS_aMeta

#or alternatively
head(WS_iData)

#check if the Indicator Data Format is okay

check_iData(WS_iData)
check_iMeta(WS_iMeta)

WS_iMeta$Level <- as.numeric(WS_iMeta$Level)
WS_iMeta$Direction <- as.numeric(WS_iMeta$Direction)
WS_iMeta$Weight <- as.numeric(WS_iMeta$Weight)



# build a new coin
WS_coin <- new_coin(iData = WS_iData,
                    iMeta = WS_iMeta,
                    level_names = c("Indicator", "Dimension", "Sub-index", "Index"))


# plot framework
plot_framework(WS_coin)


#Select indicators and review them - Step 2
#table with descriptive statistics
# get table of indicator statistics for raw data set
stat_table <- get_stats(WS_coin, dset = "Raw", out2 = "df")
stat_table


#Unit Screening (coverage of data)
#screen the raw data set with a threshold of X% data availability 
#According to the EU Guide: aim for at least 65% of data coverage across each indicator and each country

coin <- Screen(WS_coin, dset = "Raw", unit_screen = "byNA", dat_thresh = 0.65, write_to = "Filtered_85pc")
coin


#Data Analysis - STEP 3
#visualize the distribution of each indicator with histograms and scatter plotts

#consider indicators for outlier treatment if:
#1) absolute skewness > 2.0 and kurtosis > 3.5 or,
# 2) kurtosis is very high > 10

#Check for missing data 
#MISSING DATA OPTIONS
#With missing data, several options are available:
#1. Leave it as it is and aggregate anyway (there is also the option for data availability thresholds during aggregation - see Aggregation)
#2. Consider removing indicators that have low data availability (this has to be done manually because it affects the structure of the index)
#3. Consider removing units that have low data availability (see Unit Screening)
#4. Impute missing data

#Outlier Treatment?

#Normalization - STEP 4
#you can normalize coins or purses /time indexed coins)

#case 1: simple coin normalization
#default normalisation uses the min-max approach, scaling indicators onto the [0,100] interval
norm_coin <- Normalise(WS_coin, dset = "Raw")

# compare one of the raw and un-normalised indicators side by side
plot_scatter(norm_coin, dsets = c("Raw", "Normalised"), iCodes = "WaterUse")

plot_scatter(norm_coin, dsets = c("Raw", "Normalised"), iCodes = "WQ")


#Weighting - STEP 5
#weighting method?

#first with equal weights
#consider correlations between indicators


#Aggregation - STEP 6
#Consider whether compensability among indicators should be allowed

#Select aggregation levels

#Select aggregation method
#Popular aggregation methods include the arithmetic average, 
#geometric average, Borda and Copeland

