# Intro to R

# Creating a vector of data
v <- c (1, 2, 3, 4, 5)

# Getting the first element in an array
v[1]

# Getting the 2nd to 4th element in an array
v[2:4]


#Importing data from the exiting data file (CSV)
# Loading data from CSV file

data <- read.csv(",/data/donors2008.csv")

# Printing the structure of the data
str(data)

# Printing the summary of the data
summary(data)


#Data, Format, Mathematic Operations
  
# Creaet varaible x and y, note that R use "<-" as equal sign
x <- 3
y <- 10

# Addition/Subtraction
x + y
x - y

# Multiplication/Division
x * y
x / y

# Exponent/Power
x**y
x^y

# Modulus (x mod y)
x%%y


#Matrix Algebra in R
  
# Create matrix d in R
d = matrix(c(10, 20, 30), nrow=3, byrow=TRUE)
d

# Create matrix A in R
A = matrix(c(1, 2, 3, 
             -4, -5, -6, 
             7, -8, 9),
           nrow=3, byrow=TRUE)
A

# Find the determinant for matrix A in R
det(A)

# Solving the variable matrix x
solve(A, d)


# Generate 10 random numbers in an array
w = runif(10, min=0, max=100)

# Minimum value in the array
min(w)

# Maximum value in the array
max(w)

# Range of the array
range(w)

# 90th Percentile in the array
quantile(w, .90)

# Median of the array
median(w)

# Mean/Average of the array
mean(w)

# Mode of the array
# Note that there is no build in function in base R to find mode of set of numbers. 
# However, you can find other alternative libraries to help finding mode in an array, which I am not going to cover here.

# Variance of array w
var(w)

# Standard deviation of array w
sqrt(var(w))

# Descriptive Statistic Summary
summary(w)

# Loading the data from csv files
general_heights <- read.csv("./data/general_heights.csv")

wba_heights <- read.csv("./data/wba_data.csv")

# Statistic Summary for the two files
summary(general_heights)
summary(wba_heights)


#Simple Statistic Plot
#Require installing ggplot2
  
# install.packages("ggplot2", dep=T)
# install.packages("reshape2", dep=T)
library(ggplot2)
library(reshape2)

# Ploting the height distribution for the general heights data set
ggplot(general_heights, aes(x=height))+geom_histogram()

ggplot(wba_heights, aes(x=height))+geom_histogram()

# Reading the food environment data
health <- read.csv("./data/food_env_data.csv")

# Scatter Plot for obesity and diabetes data
ggplot(health, aes(x=Percent.Obesity, y = Percent.Diabetes))+geom_point()


#Simple Statistic Function and Regression Modeling
  
# t-TEst for general and WBA heights data
g_height <- general_heights["height"]
wba_height <- wba_heights["height"]

t.test(g_height, wba_height)

# Create three arrays with random numbers
x <- c(1, 2, 8, 10, 3, 5, 13, 12, 6, 8)
y <- c(4, 9, 2, 15, 10, 9, 9, 5, 12, 14)
z <- c(12, 15, 10, 5, 4, 7, 11, 11, 3, 2)

# F-test (ANOVA) for the three arrays data
xyz <- c(x, y, z)
groups = factor(rep(letters[1:3], each=10))

fit <- lm(formula = xyz~groups)
anova(fit)

# Correlation matrix for the health data
dia <- health["Percent.Diabetes"]
obs <- health["Percent.Obesity"]

cor(dia, obs)

# Linear Regression Model
fit <- lm(Percent.Diabetes ~ Percent.Obesity, data=health)
summary(fit)

# Plotting the data and the regression line
ggplot(health, aes(x=Percent.Obesity, y=Percent.Diabetes))+geom_point(shape=1)+geom_smooth(method=lm)

# Clearning and Manipulating Data
# Idicating which elements have a N/A value
test <- is.na(health)
test

# Create new dataset without missing data
newdata <- na.omit(health)

# Create a new column in the dataframe 
# Adding/Substracting two columns
health$total_survey <- health$Survey.Diabetes + health$Survey.Obesity

# Multiplying/Dividing two columns
health$total_diabetes <- health$Survey.Diabetes * health$Percent.Diabetes / 100

# Log with a column
health$log_percent_obesity <- log(health$Percent.Obesity)

# Exponential with a column
health$exp_log_percent_obesity <- exp(health$log_percent_obesity)
