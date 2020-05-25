# Fargo Heath Group Cardiovascular Examinations

The following project was based on a case that was prepared by Davit Khachatryan, Assistant Professorof Statistics & Analyticsat Babson College (2014 Babson College and licensed for publication to Harvard Business Publishing).

  * [Overview](#overview)
  * [Executive Summary](#executive-summary)
  * [Data](#data)
  * [Data Cleansing](#data-cleansing)
  * [Outliers](#outliers)
  * [Missing Data](#missing-data)
  * [Forecasts](#forecasts)
    + [Holt Winters Forecast](#holt-winters-forecast)
    + [Amelia Forecast](#amelia-forecast)
  * [Model Selection](#model-selection)

## Overview
The Fargo Health Group (FHG) has decided to do a pilot-study to determine if a data solution can accurately predict the incoming volume of medical requests in order to improve the scheduling of physicians. FHG has provided a dataset on the historical monthly examinations volume of cardiovascular examinations from the Health Center located in Abbeville, LA.
In order to effectively schedule physicians, FHG needs to be able to predict how many examinations to expect at the different Health Centers. This pilot program attempts to predict a small subset of these examinations, specifically the cardiovascular exams at just one of their Health Centers.
The dataset that FHG provided will need to be examined, the data will need to be cleaned, and a forecasting method will need to be chosen. 

## Executive Summary

FHG provided several spreadsheets that needed to be transformed into one consistent dataset. Once that was done, there were two outliers that needed to be looked at. It was determined that one was the result of a data entry error, while the other was seen as an accurate number. The error was corrected using a 3-period weighted average.

Next, missing values were imputed. Two methods were compared, Amelia and weighted averages. Weighted averges prodcued the most likely results and was used on the ten missing values.

Finally, two forecasting models were analyzed and plotted, the Holt Winters Forecast and the ARIMA Forecast. The Holt Winters Forecast had a much better Mean Average Deviation and was chosen to present to FHG.

## Data
FHG provided a dataset in the form of an Excel spreadsheet. This spreadsheet consisted of eight worksheets that contained the data.
The first sheet has three columns: Incoming Examinations, Year, and Month. It lists the number of cardiovascular examinations for each month from January 2006 through December 2013 that originated at the Abbeville, LA Health Center. 
The next four worksheets contain examinations that were sent from one Health Center to another. Each of four worksheets contains information about examinations that were sent to another Health Center in May 2007. There is one worksheet for each of four Health Centers: Violet, New Orleans, Lafayette, and Baton Rouge. These worksheets include all examinations sent from all Health Centers in May 2007.
One worksheet contained information about all examinations done by FHG in December 2013. It just contains the Routing SYSID. The SYSID is a 17 character string that contains the location code (first four characters), Condition Code (next six characters), among other information.
There is a worksheet that contains the heart-related Condition Codes and another that contains all of the Condition Codes.

## Data Cleansing
The Abbeville worksheet was copied in order to transform the data without losing the original values. The Cleaned Data worksheet was sorted by Year and Month. Figure 1 shows a graph of the Incoming Examinations before any cleansing has been performed.

![](/images/figure1.png)

The four worksheets containing data for the examinations that were sent to other Health Centers had several dates that were not formatted properly. These were manually changed in order to get an accurate count of examinations in each month. Columns for Month and Year were then added to these worksheets. There were numerous duplicate Request IDs, which were removed.
Pivot tables were created based each of the worksheets in order to filter the data. Each pivot table was filtered to show the cardiovascular examinations sent from Abbeville. They were grouped by Year and Month. The examinations were then added to the corresponding months in the Cleaned Data worksheet.
Added columns in the December 2013 Data worksheet for Location Code and Condition Code. These columns were filled in from the SYSID. A third column was added to represent whether or not the examination was sent from Abbeville and was a cardiovascular exam. This count was added to the Cleaned Data worksheet. 
A quick examination of the data showed that there were 10 values that were obviously inaccurate. Two of them were over 99 million and eight were not numbers. These 10 values were reformatted in the Cleaned Data worksheet. The result was saved in a csv file and examined in R.

## Outliers

There were two values that did not appear to conform to the general trends of the data. October 2008 had 3110 exams listed, well above the number of exams around that time. December 2013 had 3442 exams listed, well below previous marks. Figure 2 shows the scatterplot of Heart Exams over time.

![](/images/figure2.png)

The value for October 2008 does indeed appear to be a mistake, perhaps a simple typo. The value for December 2013, however, upon closer inspection appears to be part of a downward trend after a high of 6094 in October 2013. 
The value for October 2008 value was replaced using a 3-period weighted moving average value. The weights used were 0.5, 0.3, and 0.2. That value turned out to be 995.

## Missing Data

The summary of the Cleaned Data is shown in Figure 3. There are 10 missing values that need to be imputed. 
 
![](/images/figure3.png)

Two methods of imputing the missing values were tried: Amelia and Weighted Average. Figures 4 and 5 show the results of these two methods.

![](/images/figure4.png)

![](/images/figure5.png)

The Weighted Averages result was chosen because the Amelia results produced some negative results early on. 

## Forecasts

Two forecasts were attempted on the dataset: Holt Winters and ARIMA. Both forecasts were analyzed and plotted.

### Holt Winters Forecast
The Holt Winters forecast was run without specifying the alpha value, allowing R to come up with the best fit. The predicted values for the next 12 months can be seen in Figures 6 and 7.

![](/images/figure6.png)

![](/images/figure7-1.png)

### Amelia Forecast

The ARIMA forecast was run next. Once again, R was used to automatically fit the model. The predicted values for the next 12 months can be seen in Figures 8 and 9.

![](/images/figure8.png)

![](/images/figure9.png)

## Model Selection
The two models were compared on the basis of Mean Absolute Deviation (MAD). The Holt Winters forecast yielded a MAD of 0.13 while the Arima forecast yielded a MAD of 235.23. The Holt Winters forecast was chosen based on having a much better MAD.
