# Libraries
library(plyr)
library(corrplot)
library(ggplot2)
library(gridExtra)
library(ggthemes)
library(caret)
library(MASS)
library(randomForest)
library(party)

# Data Exploration
telecom <- read.csv(file.choose())
head(telecom)
table(telecom$Churn)
str(telecom) 
# 7043 records & 21 variables with 1869 customers who have churned

# Data Cleaning 

sapply(telecom, function(x) sum(is.na(x)))  #checking the number of missing values in each column
telecom <- telecom[complete.cases(telecom), ] #removing columns with missing values

#Now,I'm changing "No internet services" to "No" in OnlineSecurity, OnlineBackup, DeviceProtection, TechSupport, streamingTV, streamingMovies
cols_recode1 <- c(10:15)
for(i in 1:ncol(telecom[,cols_recode1])) {
  telecom[,cols_recode1][,i] <- as.factor(mapvalues
                                        (telecom[,cols_recode1][,i], from =c("No internet service"),to=c("No")))
}

#Changing "No phone service" to No
telecom$MultipleLines <- as.factor(mapvalues(telecom$MultipleLines, from=c("No phone service"),to=c("No")))

# Grouping into 5 groups : 0-12 months, 12-24,24-48, 48-60, >60 months
min(telecom$tenure); max(telecom$tenure)

group_tenure <- function(tenure){
  if (tenure >= 0 & tenure <= 12){
    return('0-12 Month')
  }else if(tenure > 12 & tenure <= 24){
    return('12-24 Month')
  }else if (tenure > 24 & tenure <= 48){
    return('24-48 Month')
  }else if (tenure > 48 & tenure <=60){
    return('48-60 Month')
  }else if (tenure > 60){
    return('> 60 Month')
  }
}

telecom$tenure_group <- sapply(telecom$tenure,group_tenure)
telecom$tenure_group <- as.factor(telecom$tenure_group)

telecom$SeniorCitizen <- as.factor(mapvalues(telecom$SeniorCitizen,from=c("0","1"),to=c("No", "Yes"))) #Changing Senior Citizen's values from (0,1) to (No, Yes)

# Exploratory Data Analysis
numeric.var <- sapply(telecom, is.numeric)
corr.matrix <- cor(telecom[,numeric.var])
corrplot(corr.matrix, main="\n\nCorrelation Plot for Numerical Variables", method="number")
# we see that TotalCharges & tenure have a correlation of 0.83

#removing columns I think are unnecessary for analysis
telecom$customerID <- NULL
telecom$MonthlyCharges<- NULL

# Now, we are left with "Gender", "Senior Citizen", "PArtner", "Dependents", "Phone Service", "Internet Service", "Multiple Lines", "Online Security", "Online Backup", "Tech Support", "Device Protection", "Streaming TV", "Streaming Movies", "COntract", "Payment Method", "Tenure Group", "Paperless Billing"
# Visualizing all these

#1 Gender visualization
p1 <- ggplot(telecom, aes(x=gender)) + ggtitle("Gender") + xlab("Gender") + geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() 

#2 Senior Citizen visualization
p2 <- ggplot(telecom, aes(x=SeniorCitizen)) + ggtitle("Senior Citizen") + xlab("Senior Citizen") + geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip()

#3 Partner visualization
p3 <- ggplot(telecom, aes(x=Partner)) + ggtitle("Partner") + xlab("Partner") + geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() 

#4 Dependents visualization
p4 <- ggplot(telecom, aes(x=Dependents)) + ggtitle("Dependents") + xlab("Dependents") + geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip()

#5 Phone Service visualization
p5 <- ggplot(telecom, aes(x=PhoneService)) + ggtitle("Phone Service") + xlab("Phone Service") +  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() 

#6 Internet Service visualization
p6 <- ggplot(telecom, aes(x=InternetService)) + ggtitle("Internet Service") + xlab("Internet Service") +   geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() 
# Visualization results
grid.arrange(p1, p2, p3, p4, p5, p6, ncol=2)

#7 Multiple Lines visualization
p7 <- ggplot(telecom, aes(x=MultipleLines)) + ggtitle("Multiple Lines") + xlab("Multiple Lines") +   geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip()

#8 Online Security visualization
p8 <- ggplot(telecom, aes(x=OnlineSecurity)) + ggtitle("Online Security") + xlab("Online Security") +   geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip()

#9 Online Backup visualization
p9 <- ggplot(telecom, aes(x=OnlineBackup)) + ggtitle("Online Backup") + xlab("Online Backup") +  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() 

#10 Tech Support visualization
p10 <- ggplot(telecom, aes(x=TechSupport)) + ggtitle("Tech Support") + xlab("Tech Support") +   geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip()

#11 Device Protection visualization
p11 <- ggplot(telecom, aes(x=DeviceProtection)) + ggtitle("Device Protection") + xlab("Device Protection") +   geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() 

#12 Streaming TV visualization
p12 <- ggplot(telecom, aes(x=StreamingTV)) + ggtitle("Streaming TV") + xlab("Streaming TV") +  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip()
# Visualization results
grid.arrange(p7, p8, p9, p10, p11, p12, ncol=2)

#13 Streaming Movies visualization
p13 <- ggplot(telecom, aes(x=StreamingMovies)) + ggtitle("Streaming Movies") + xlab("Streaming Movies") +  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() 

#14 Contract visualization
p14 <- ggplot(telecom, aes(x=Contract)) + ggtitle("Contract") + xlab("Contract") +   geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip()

#15 Paperless Billing visualization
p15 <- ggplot(telecom, aes(x=PaperlessBilling)) + ggtitle("Paperless Billing") + xlab("Paperless Billing") +   geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() 

#16 Payment Method visualization
p16 <- ggplot(telecom, aes(x=PaymentMethod)) + ggtitle("Payment Method") + xlab("Payment Method") +  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal()

#17 Tenure Group visualization
p17 <- ggplot(telecom, aes(x=tenure_group)) + ggtitle("Tenure Group") + xlab("Tenure Group") +  geom_bar(aes(y = 100*(..count..)/sum(..count..)), width = 0.5) + ylab("Percentage") + coord_flip() + theme_minimal()
# Visualization results
grid.arrange(p13, p14, p15, p16, p17, ncol=2)

# Logistic Regression
churn <- createDataPartition(telecom$Churn,p=0.7,list=FALSE)
set.seed(69)
train <- telecom[churn,]
test <- telecom[-churn,]
dim(train);dim(test)

LR <- glm(Churn ~ ., family=binomial("logit"), data=train)
summary(LR)


