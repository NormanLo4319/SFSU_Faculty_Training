############################################################################
##                        BASIC COMMAND LINE USAGE                        ##
############################################################################

# In this demo, we focus on some basic descriptive statistic command and
# some command and some common regression model technique.  All examples are
# based on the data sets stored in the data directory.

# install.packages("")
# Importing the library for the project.
library(MASS)
library(ISLR)
library(klaR)
library(ggplot2)
library(corrplot)
library(lmtest)
library(car)
library(pROC)
library(generalhoslem)

# Setting the working directory for the project.
setwd("C:/Users/lokma/Desktop/SFSU_Training/SFSU_Faculty_Training")

# Importing the Boston data set for linear regression analysis.
boston <- read.csv("data/Boston.csv", header=TRUE, na.string="?")

# Getting the descriptive summary of the data.
summary(boston)

# Note that "chas" is a dummy variable, but R is treating it as continues
# variable in the summary.  Therefore, we need to define it as categorical
# for later analysis.
boston$chas <- factor(boston$chas)

# Getting the descriptive summary for just one of the columns.
summary(boston$crim)

# No abbreviation can be used in R or Python because they are the name of 
# the function written by the programmers.  
# If we want to learn more about the function, we can use "?".
?summary

# If we want to use the same dataset over and over again, we can use 
# function attach().
attach(boston)


# Graphing the correlation among variables in the dataset.
pairs(boston)

# Graphing Quantitative Data (Histogram)
# The dataset has a variable 'medv' which represents the median home's
# value.  Creating a historgram for it is easy:
hist <- ggplot(boston, aes(x=medv)) + geom_histogram()

# We can also add mean line on the graph.
hist+ geom_vline(aes(xintercept=mean(medv)),
              color='blue', linetype='dashed', size=1)

# We can also plot the histogram with desity plot
ggplot(boston, aes(x=medv)) +
  geom_histogram(aes(y=..density..), colour='black', fill='white') +
  geom_density(alpha=0.2, fill="#FF6666")

# We can also plot the histogram by groups.
ggplot(boston, aes(x=medv, color=chas, group=chas)) +
  geom_histogram(binwidth=1, fill="white")

# Comparing Quantitative Data by Categories (Box Plot)
# Our dataset identifies whether a home is located nearby the river or not
# "chas". We can use a boxplot to compare nearby or none nearby river 
# home value:
ggplot(boston, aes(x=chas, y=medv)) +
  geom_boxplot()

# Plotting two quantitative varaibles against each other (Scatter Plot)
# Our data contains variables on median home value and per capita crime rate.
# A scatter plot for these two variables is easily created with:
ggplot(boston, aes(x=crim, y=medv)) +
  geom_point(size=2, shape=1)


# Single Linear Regression Model
# Checking the correlation between variables
cor(boston, use="complete.obs")

# Note that the cor() function can only take numeric value, but "chas" is 
# a string (or factor).  We can change it back to numeric or create a new vector.
chas_riv <- as.factor(boston$chas)
boston$chas <- as.numeric(boston$chas)

# Try again with the cor() function with boston dataset
correlation <- cor(boston, use="complete.obs")
correlation

# We can also plot the correlation with corrplot() function in R.
# The function corrplot() takes the correlation matrix as the first argument. 
# The second argument (type="upper") is used to display only the upper triangular
# of the correlation matrix.
corrplot(correlation, type="upper", order="hclust", tl.col="black", tl.srt=45)

# The correlation matrix is reordered according to the correlation coefficient 
# using "hclust" method.
# tl.col (for text label color) and tl.srt (for text label string rotation) are 
# used to change text colors and rotations.
# Possible values for the argument type are : "upper", "lower", "full".


# Estimate the predicted effect of per capita crime rate on the median home value
# in Boston:
fit1 <- lm(medv~crim, data=boston)
summary(fit1)

# Plot residuals against predicted value of home value
plot(predict(fit1), residuals(fit1))

# Plotting the regression line.
plot(crim, medv, col="blue", 
     main="Median Home Value v Per Captia Crime Rate",
     xlab="Per Capita Crime Rate", ylab="Median Home Value")
abline(fit1, col="red")


# Multiple Linear Regression
# Estimate the predicted effect of the per capita crime rate, lower status
# of the population, and Charles River dummy on median home value in Boston:
fit2 <- lm(medv~crim+lstat+chas)
summary(fit2)

# Robust Tests
# Ramsey RESET test
resettest(fit2)
#Breusch-Pagan / Cook-Weisberg test for heteroskedasticity
bptest(fit2)
# Variance Inflation Factor test for multicollinearity
vif(fit2)


# Logistic Regression Model
# Import the data set Default for the logistic regression analysis.
default_data <- read.csv("data/Default.csv", header=TRUE, na.string="?")

# Descriptive summary of the dataset.
summary(default_data)

# Check the structure of the dataset.
str(default_data)

# In R, even the dataset may contain categorical string data and 
# numerical value data, most of the analysis tools do not require
# manipulation of the data before running the model.

attach(default_data)

# Estimate the log odds of Default using the average balance that the
# customer has remaining on their credit card after making their monthy
# payment:
fit3 <- glm(default~balance, data=default_data, family=binomial)
summary(fit3)

# Estimate the log odds of Default using balance, income, and student:
fit4 <- glm(default~balance+income+student, 
            data=default_data, family=binomial)
summary(fit4)

# Store the predicted probability from the model.
glm.prob <- predict(fit4, type="response")
default_data$prob <- glm.prob

# Robust Tests
# Ramsey RESET test
resettest(fit4)
#Breusch-Pagan / Cook-Weisberg test for heteroskedasticity
bptest(fit4)
# Variance Inflation Factor test for multicollinearity
vif(fit4)
# Evaluate the area under the ROC curve 
g <- roc(default~prob, data=default_data)
plot(g)
# Calculate Hosmer-Lemeshow goodness-of-fit statistic
# Note: this statistical test can be adjusted by number of groups 'g'
logitgof(default_data$default, fitted(fit4), g=10)

# Confusion Matrix (Pr > 0.5)
glm.pred <- ifelse(glm.prob > 0.5,"Yes","No")
table(glm.pred, default_data$default)
