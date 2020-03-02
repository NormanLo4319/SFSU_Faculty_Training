********************************************************************************
**                          BASIC COMMAND LINE USAGE                          **
********************************************************************************

* For the purpose of this presentation, we focus on some basic descriptive
* statistic command and some common regression model technique. All examples are
* based on the data sets stored in the data directory.

clear all
set more off

* Importing the Boston data set for linear regression analysis.
* For Stata 12 or before,
* insheet using data\Boston.csv
* For Stata 13 or after,
import delimited using data\Boston.csv

* USING ONE OR MORE VARIABLES
* Most commands can be applied to one or more variables. To apply the command
* to ALL variables, enter the command only:
summarize

* To apply the command to individual variables, list them after the command,
* separated by a space:

summarize tax crim

* You can use wildcards to save yourself some typing. The asterisk * stands for
* any character or characters (one or many). For example:

summarize r*

* ... is the same as listing every single variable whose name starts with a r:

summarize rm rad

* Another wildcard is the question mark ? standing for any one character:

summarize n?x

* is the same as listing every single variable whose name started with a n,
* followed by any character and ending with a x:

summarize nox



* ABBREVIATING VARIABLES NAMES
* Stata is all about saving you some typing. The most common commands can be
* abbreviated a lot, e.g. summarize can be abbreviated to "su". Writing:

* If you want to know if you can abbreviate a variable name, use the help
* function:

help summarize

* Under syntax, the abbreviated version of the variable name will be underlined.


* USING ALL OBSERVATIONS OR A SUBSET
* By default, Stata will apply the command to all observations for your
* variable, possibly excluding any missing values. But sometimes you don't want
* all observations, but only a subset. 

* Here are the summary values for median value of homes given per capita crime
* rate is over 5:

summarize medv if crim > 5

* You can force Stata to take a subset of observations that fulfills multiple
* options at the same time (logical AND). The following command returns the 
* summary of median value of home given crim >5 and the house's tract bounds
* the Charles River:

summarize medv if crim > 5 & chas == 1


* This command here return median home's value given crim > 5 OR the house's
* tract bounds the Charles River:

summarize medv if crim > 5 | chas == 1


** GRAPHING CORRELATION AMONG VARIABLES IN THE DATASET (Matrix Graph)
graph matrix medv crim chas lstat age rad

** GRAPHING QUANTITATIVE DATA (HISTOGRAM) -- Histograms are very useful for
* quantitative information because break the entire range of values into
* individual bins and show the frequencies with which observations fall into the
* different bins.

* Our dataset has a variable "medv" which represents the median home's value.
* Creating a histogram for it is easy:
histogram medv


* The histogram will show the entire range and the label of the variable along
* its x-axis. The y-axis is labeled with densities, which are not easy to
* interpret for "normal" earthlings. It's recommended switching to percentages
* or frequencies:
histogram medv, percent
histogram medv, frequency


** COMPARING QUANTITATIVE DATA BY CATEGORIES (BOX PLOT) -- Box plots are 
* summary graphs that show the distribution of a variable in comparison for
* multiple categories, with indications for the center, central 50% of
* observations, and outliers.

* Our dataset identifies whether a home is located nearby the river or not "chas"
* We can use a boxplot to compare nearby or none nearby river home value:
graph box medv, over(chas)


** PLOTTING TWO QUANTITATIVE VARIABLES AGAINST EACH OTHER (SCATTER PLOT) --
* Scatter plots are useful for showing the distribution of two quantitative
* variables in respect to each other.

* Our data contains variables on median home value and per capita crime rate.
* A scatter plot for these two variables is easily created with:
graph twoway scatter medv crim, title("Median Home Value v Per Capita Crime Rate")

* Especially when you have lots of observations, relatively thick dots for each
* observation may obscure the pattern. You can opt for smaller markers with
* scatter medv crim, msize(small)
* scatter medv crim, msize(tiny)

* We can also add subtitles, captions, and labels of the axes
sc medv crim, msize(small) ///
   title("Median Home Value v Per Capita Crime Rate") ///
   subtitle("Boston Housing Values Survey") ///
   caption("Observations: 506 units") ///
   xtitle("Per Capita Crime Rate") ///
   ytitle("Median Value of Owner-Occupied Homs in $1000s") ///
   scheme(economist)



** Single Linear Regression Model **
* Checking the correlation between variables
corr

* Estimate the predicted effect of the per capita crime rate on the median 
* home value in Boston:
regress medv crim

* Plotting regression results
* Simple residuals-versus-fitted plot.
rvfplot, yline(0) ///
name(rvfplot, replace)

* Get fitted values.
cap drop yhat
predict yhat

* Get residuals
cap drop r
predict r, resid

* Plot residuals against predicted values of home value
sc r yhat, yline(0) $ccode ///
name(rvfplot2, replace)

* Plot home value with observed and predicted value of home value.
sc medv crim || conn yhat crim, ///
name(dv_yhat, replace)


** Multiple Linear Regression **
* Estimate the predicted effect of the per capita crim, lower status of the 
* population, and Charles River dummy on the median home value in Boston:
regress medv crim lstat chas

* Robust Test
* Ramsey RESET test
ovtest
* Breusch-Pagan / Cook-Weisberg test for heteroskedasticity
hettest
* Variance Inflation Factor test for multicollinearity
vif


** Logistic Regression Model **
* Import the data set Default for the logistic regression analysis.
* For Stata 12 or before,
* insheet using data\Boston.csv
* For Stata 13 or after,
import delimited using data\Default.csv

* Discriptive summary of the data set
summarize 

* Note that the column Default and Student cannot be summarized by the
* summarize function.  The problem is that the function can only take
* numeric value, but the data is string.

* Check the data type
describe

* Solution 1:
encode default, generate(default2)
encode student, generate(student2)

* Solution 2:
gen default3 = 0
replace default3 = 1 if default == "Yes"
gen student3 = 0
replace student3 = 1 if student == "Yes"

* Estimate the log odds of Default using the average balance that the
* customer has remaning on their credit card after making their monthly
* payment.
logit default3 balance

* Estimate the log odds of Default using balance, income, and student:
logit default3 balance income student3

* Robust Test
* Ramsey RESET test
ovtest
* Breusch-Pagan / Cook-Weisberg test for heteroskedasticity
hettest
* Variance Inflation Factor test for multicollinearity
vif
* Evaluate the area under the ROC curve 
lroc
* Calculate Hosmer-Lemeshow goodness-of-fit statistic
estat gof

* Confusion Matrix (Pr > 0.5)
estat classification
