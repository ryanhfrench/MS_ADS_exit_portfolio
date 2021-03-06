# Ryan H. French
# Honors Capstone Project: Visualizing and Understanding Violent Crime in Syracuse

# Project Initialization
# Import necessary libraries
library(dplyr)
library(ggplot2)
library(kernlab)
library(arules)
library(arulesViz)
library(Matrix)
library(randomForest)
library(ElemStatLearn)
library(ggmap)
library(leaflet)
library(leaflet.extras)
library(randomForestExplainer)

# Get working directory
current_path = rstudioapi::getActiveDocumentContext()$path 
setwd(dirname(current_path))
path = getwd()

# Import crime data
crimeData <- read.csv(file="Weekly_Crime_Offenses_2017.csv", 
                             stringsAsFactors = FALSE)

# Set seed for replication purposes
set.seed(111)



# Data Cleaning
# Remove rows which are not from 2017
crimeData <- crimeData[ grep("2017", as.character(crimeData$DATE)),]

# Convert Attempt column to binary factor
crimeData$Attempt <- as.factor(ifelse(crimeData$Attempt == "A", 1, 0))

# Convert Arrests column to binary factor
crimeData$Arrest <- as.factor(ifelse(crimeData$Arrest == "Yes", 1, 0))



# Feature Engineering
# Add larceny code for crimes that are not larceny
crimeData$LarcenyCode[crimeData$LarcenyCode == ""] <- "Not Larceny"

# Discretize TIMEEND into hourly bins
crimeData$TIMEEND <- as.numeric(crimeData$TIMEEND)
crimeData$TIMEEND[crimeData$TIMEEND > 0 & crimeData$TIMEEND <= 100] <- 0
crimeData$TIMEEND[crimeData$TIMEEND > 100 & crimeData$TIMEEND <= 200] <- 1
crimeData$TIMEEND[crimeData$TIMEEND > 200 & crimeData$TIMEEND <= 300] <- 2
crimeData$TIMEEND[crimeData$TIMEEND > 300 & crimeData$TIMEEND <= 400] <- 3
crimeData$TIMEEND[crimeData$TIMEEND > 400 & crimeData$TIMEEND <= 500] <- 4
crimeData$TIMEEND[crimeData$TIMEEND > 500 & crimeData$TIMEEND <= 600] <- 5
crimeData$TIMEEND[crimeData$TIMEEND > 600 & crimeData$TIMEEND <= 700] <- 6
crimeData$TIMEEND[crimeData$TIMEEND > 700 & crimeData$TIMEEND <= 800] <- 7
crimeData$TIMEEND[crimeData$TIMEEND > 800 & crimeData$TIMEEND <= 900] <- 8
crimeData$TIMEEND[crimeData$TIMEEND > 900 & crimeData$TIMEEND <= 1000] <- 9
crimeData$TIMEEND[crimeData$TIMEEND > 1000 & crimeData$TIMEEND <= 1100] <- 10
crimeData$TIMEEND[crimeData$TIMEEND > 1100 & crimeData$TIMEEND <= 1200] <- 11
crimeData$TIMEEND[crimeData$TIMEEND > 1200 & crimeData$TIMEEND <= 1300] <- 12
crimeData$TIMEEND[crimeData$TIMEEND > 1300 & crimeData$TIMEEND <= 1400] <- 13
crimeData$TIMEEND[crimeData$TIMEEND > 1400 & crimeData$TIMEEND <= 1500] <- 14
crimeData$TIMEEND[crimeData$TIMEEND > 1500 & crimeData$TIMEEND <= 1600] <- 15
crimeData$TIMEEND[crimeData$TIMEEND > 1600 & crimeData$TIMEEND <= 1700] <- 16
crimeData$TIMEEND[crimeData$TIMEEND > 1700 & crimeData$TIMEEND <= 1800] <- 17
crimeData$TIMEEND[crimeData$TIMEEND > 1800 & crimeData$TIMEEND <= 1900] <- 18
crimeData$TIMEEND[crimeData$TIMEEND > 1900 & crimeData$TIMEEND <= 2000] <- 19
crimeData$TIMEEND[crimeData$TIMEEND > 2000 & crimeData$TIMEEND <= 2100] <- 20
crimeData$TIMEEND[crimeData$TIMEEND > 2100 & crimeData$TIMEEND <= 2200] <- 21
crimeData$TIMEEND[crimeData$TIMEEND > 2200 & crimeData$TIMEEND <= 2300] <- 22
crimeData$TIMEEND[crimeData$TIMEEND > 2300 & crimeData$TIMEEND <= 2400] <- 23

# Discretize TIMESTART into hourly bins
crimeData$TIMESTART <- as.numeric(crimeData$TIMESTART)
crimeData$TIMESTART[crimeData$TIMESTART > 0 & crimeData$TIMESTART <= 100] <- 0
crimeData$TIMESTART[crimeData$TIMESTART > 100 & crimeData$TIMESTART <= 200] <- 1
crimeData$TIMESTART[crimeData$TIMESTART > 200 & crimeData$TIMESTART <= 300] <- 2
crimeData$TIMESTART[crimeData$TIMESTART > 300 & crimeData$TIMESTART <= 400] <- 3
crimeData$TIMESTART[crimeData$TIMESTART > 400 & crimeData$TIMESTART <= 500] <- 4
crimeData$TIMESTART[crimeData$TIMESTART > 500 & crimeData$TIMESTART <= 600] <- 5
crimeData$TIMESTART[crimeData$TIMESTART > 600 & crimeData$TIMESTART <= 700] <- 6
crimeData$TIMESTART[crimeData$TIMESTART > 700 & crimeData$TIMESTART <= 800] <- 7
crimeData$TIMESTART[crimeData$TIMESTART > 800 & crimeData$TIMESTART <= 900] <- 8
crimeData$TIMESTART[crimeData$TIMESTART > 900 & crimeData$TIMESTART <= 1000] <- 9
crimeData$TIMESTART[crimeData$TIMESTART > 1000 & crimeData$TIMESTART <= 1100] <- 10
crimeData$TIMESTART[crimeData$TIMESTART > 1100 & crimeData$TIMESTART <= 1200] <- 11
crimeData$TIMESTART[crimeData$TIMESTART > 1200 & crimeData$TIMESTART <= 1300] <- 12
crimeData$TIMESTART[crimeData$TIMESTART > 1300 & crimeData$TIMESTART <= 1400] <- 13
crimeData$TIMESTART[crimeData$TIMESTART > 1400 & crimeData$TIMESTART <= 1500] <- 14
crimeData$TIMESTART[crimeData$TIMESTART > 1500 & crimeData$TIMESTART <= 1600] <- 15
crimeData$TIMESTART[crimeData$TIMESTART > 1600 & crimeData$TIMESTART <= 1700] <- 16
crimeData$TIMESTART[crimeData$TIMESTART > 1700 & crimeData$TIMESTART <= 1800] <- 17
crimeData$TIMESTART[crimeData$TIMESTART > 1800 & crimeData$TIMESTART <= 1900] <- 18
crimeData$TIMESTART[crimeData$TIMESTART > 1900 & crimeData$TIMESTART <= 2000] <- 19
crimeData$TIMESTART[crimeData$TIMESTART > 2000 & crimeData$TIMESTART <= 2100] <- 20
crimeData$TIMESTART[crimeData$TIMESTART > 2100 & crimeData$TIMESTART <= 2200] <- 21
crimeData$TIMESTART[crimeData$TIMESTART > 2200 & crimeData$TIMESTART <= 2300] <- 22
crimeData$TIMESTART[crimeData$TIMESTART > 2300 & crimeData$TIMESTART <= 2400] <- 23

# Extract day of week from DATE attribute
weekDay <- weekdays(as.Date(crimeData$DATE))
crimeData <- cbind(weekDay, crimeData)

weekDayCrimeFreq <- table(crimeData$weekDay)

# Extract days from DATE attribute
DAY <- substr(crimeData$DATE, 9, 10)
crimeData <- cbind(DAY, crimeData)

table(crimeData$DAY)
dayCrimeFreq <- table(crimeData$DAY)

# Extract months from DATE attribute
MONTH <- substr(crimeData$DATE, 6, 7)
crimeData <- cbind(MONTH, crimeData)

table(crimeData$MONTH)
monthCrimeFreq <- table(crimeData$TIMESTART)

# Drop old date column and other unnecesary columns
drops <- c("DATE", "FID", "DRNUMB")
crimeData <- crimeData[ , !(names(crimeData) %in% drops)]

# Reformat character class attributes as factors
crimeData[ , c("ADDRESS", "CODE_DEFINED", "LarcenyCode")] <- 
  lapply(crimeData[ , c("ADDRESS", "CODE_DEFINED", "LarcenyCode")], factor)



# Descriptive Modeling
# Plot week day crime frequency
# Create table for frequency of day of week instances
freqDow <- as.data.frame(weekDayCrimeFreq)
colnames(freqDow) <- c("weekDay", "frequency")

# Bar graph of weekDay
dowBar <- ggplot(freqDow, aes(weekDay, frequency)) + 
  geom_bar(color = "royalblue", fill = "orange", stat = "identity")
dowBar <- dowBar + theme(axis.text.x = element_text(angle = 90, hjust = 1)) + 
  ggtitle("Day of Week vs Frequency") + 
  theme(plot.title = element_text(hjust = 0.5)) + xlab("Day of Week") + ylab("Frequency") +
  scale_y_continuous(breaks = c(0, 300, 600, 900), 
                     limits = c(0, 900))
dowBar
sd(freqDow$frequency)

# Plot monthly crime frequency
monthHist <- ggplot(crimeData,aes(x=MONTH)) + 
  geom_bar(color="royalblue", fill="orange")
monthHist <- monthHist + theme(axis.text.x = element_text()) + 
  ggtitle("Month vs Frequency") + 
  theme(plot.title = element_text(hjust = 0.5)) + xlab("Month") + ylab("Frequency") +
  scale_y_continuous(breaks = c(0, 100, 200, 300, 400, 500, 600), 
                     limits = c(0, 600))
monthHist

# Plot daily crime frequency
dayHist <- ggplot(crimeData, aes(x = DAY)) + 
  geom_bar(color = "royalblue", fill = "orange")
dayHist <- dayHist + theme(axis.text.x = element_text()) + 
  ggtitle("Day vs Frequency") + 
  theme(plot.title = element_text(hjust = 0.5)) + xlab("Day") + ylab("Frequency") +
  scale_y_continuous(breaks = c(0, 50, 100, 150, 200, 250), 
                     limits = c(0, 250))
dayHist

# Select only addresses with over 15 occurences of incident
addressTable <- table(crimeData$ADDRESS)
freqAddresses <- as.data.frame(addressTable)
colnames(freqAddresses) <- c("address", "frequency")
freqAddresses <- freqAddresses[freqAddresses[2]>15,]

# Bar graph of ADDRESS where crime instances > 15
dAddressBar <- ggplot(freqAddresses,aes(address, frequency)) + 
  geom_bar(color = "royalblue", fill = "orange", stat = "identity")
dAddressBar <- dAddressBar + theme(axis.text.x = element_text(angle = 90, hjust = 1)) + 
  ggtitle("Address vs Frequency (Where Frequency > 15)") + 
  theme(plot.title = element_text(hjust = 0.5)) + xlab("Address") + ylab("Frequency") +
  scale_y_continuous(breaks = c(0, 100, 200, 300, 400, 500), 
                     limits = c(0, 500))
dAddressBar

# Bar graph of ADDRESS not including Destiny where crime instances > 15
freqAddresses <- freqAddresses[-1,]
addressBar <- ggplot(freqAddresses,aes(address, frequency)) + 
  geom_bar(color = "royalblue", fill = "orange", stat = "identity")
addressBar <- addressBar + theme(axis.text.x = element_text(angle = 90, hjust = 1)) + 
  ggtitle("Address vs Frequency (Where Frequency > 15, Not Including Destiny)") + 
  theme(plot.title = element_text(hjust = 0.5)) + xlab("Address") + ylab("Frequency") +
  scale_y_continuous(breaks = c(0, 25, 50, 75, 100), 
                     limits = c(0, 100))
addressBar

# View crimes at Destiny
destinyData <- crimeData[crimeData$ADDRESS == "1 DESTINY USA DR", ]
table(destinyData$CODE_DEFINED)
table(destinyData$Arrest)

dCodeBar <- ggplot(destinyData, aes(x = CODE_DEFINED)) + 
  geom_bar(color = "royalblue", fill = "orange")
dCodeBar <- dCodeBar + theme(axis.text.x = element_text(angle = 90, hjust = 1)) + 
  ggtitle("Crime Code vs Frequency at Destiny USA") + 
  theme(plot.title = element_text(hjust = 0.5)) + xlab("Code Defined") + ylab("Frequency") + 
  scale_y_continuous(breaks = c(0, 150, 300, 450), 
                     limits = c(0, 450))
dCodeBar

# Bar graph for CODE_DEFINED
codeBar <- ggplot(crimeData, aes(x = CODE_DEFINED)) + 
  geom_bar(color="royalblue", fill="orange")
codeBar <- codeBar + theme(axis.text.x = element_text(angle = 90, hjust = 1)) + 
  ggtitle("Crime Code vs Frequency") + 
  theme(plot.title = element_text(hjust = 0.5)) + xlab("Code Defined") + ylab("Frequency") + 
  scale_y_continuous(breaks = c(0, 500, 1000, 1500, 2000, 2500, 3000, 3500), 
                     limits = c(0, 3500))
codeBar

# View information on murders
murderData <- crimeData[crimeData$CODE_DEFINED == "MURDER", ]
murderData

# Bar graph for Attempt
attemptBar <- ggplot(crimeData, aes(x = Attempt)) + 
  geom_bar(color = "royalblue", fill = "orange")
attemptBar <- attemptBar + theme(axis.text.x = element_text()) + 
  ggtitle("Attempts vs Frequency") + 
  theme(plot.title = element_text(hjust = 0.5)) + xlab("Attempts") + ylab("Frequency") + 
  scale_y_continuous(breaks = c(0, 1500, 3000, 4500, 6000), 
                     limits = c(0, 6000))
attemptBar

# Bar graph for Arrests
arrestBar <- ggplot(crimeData, aes(x = Arrest)) + 
  geom_bar(color = "royalblue", fill = "orange")
arrestBar <- arrestBar + theme(axis.text.x = element_text()) + 
  ggtitle("Arrests vs Frequency") + 
  theme(plot.title = element_text(hjust = 0.5)) + xlab("Arrests") + ylab("Frequency") +
  scale_y_continuous(breaks = c(0, 1500, 3000, 4500), 
                     limits = c(0, 4500))
arrestBar

# View information on arrests that occured
arrestData <- crimeData[crimeData$Arrest == 1, ]
table(arrestData$CODE_DEFINED)

cArrestBar <- ggplot(arrestData, aes(x = CODE_DEFINED)) + 
  geom_bar(color = "royalblue", fill = "orange")
cArrestBar <- cArrestBar + theme(axis.text.x = element_text(angle = 90, hjust = 1)) + 
  ggtitle("Confirmed Arrests vs Frequency") + 
  theme(plot.title = element_text(hjust = 0.5)) + xlab("Arrests") + ylab("Frequency") +
  scale_y_continuous(breaks = c(0, 350, 700), 
                     limits = c(0, 700))
cArrestBar

# Bar graph for LarcenyCode
# Subset data for just crimes with larceny codes
larcenyData <- crimeData[crimeData$LarcenyCode != "Not Larceny", ]

larcenyBar <- ggplot(larcenyData, aes(x = LarcenyCode)) + 
  geom_bar(color = "royalblue", fill = "orange")
larcenyBar <- larcenyBar + theme(axis.text.x = element_text(angle = 90, hjust = 1)) + 
  ggtitle("Type of Larceny vs Frequency") +
  theme(plot.title = element_text(hjust = 0.5)) + xlab("Larceny Code") + 
  ylab("Frequency") + scale_y_continuous(breaks = c(500, 1000, 1500), 
                                           limits = c(0, 1500))
larcenyBar



# Predict Arrests
sampleData <- crimeData

# SVM Model
# Randomize the order of the data to allow for random sampling of the thirds selected
table(sampleData$Arrest)
set.seed(111)
randIndex <- sample(1:dim(sampleData)[1])

# Create a 2/3 cut point by dividing the data into thirds
cutPoint2_3 <- floor(2 * dim(sampleData)[1]/3+1)
cutPoint2_3

# Create the training and testing data off of the 2/3 cut point
trainData <- sampleData[randIndex[1:cutPoint2_3],]
testData <- sampleData[randIndex[(cutPoint2_3):dim(sampleData)[1]],]

# Create the SVM expression with the following parameters
svmOutput <- ksvm(Arrest ~ ., data = trainData, kernel = "rbfdot", cost = 1, 
                  cross = 10, prob.model = TRUE, set.seed = 111)
svmOutput

# Examine the support vectors
svmHist <- hist(alpha(svmOutput)[[1]], main="Support Vector Histogram with cost = 1", 
                xlab="Support Vector Values")

# Test the created model against the test data set
svmPred <- predict(svmOutput, testData, type='votes')

# Create a confusion matrix of the second row of svmPred vs binSat
smvCompTable <- data.frame(testData$Arrest,svmPred[2,])
table(smvCompTable) 

# Determine the accuracy of the model
svmAcc <- (sum(diag(table(smvCompTable))))/sum(table(smvCompTable))
svmAcc
# Accuracy is 79.5%



# Refined SVM Model
# Randomize the order of the data to allow for random sampling of the thirds selected
table(sampleData$Arrest)
set.seed(111)
randIndex <- sample(1:dim(sampleData)[1])

# Subset the sample data so as to create 50% yes, and 50% no
# Collect all succesful arrests
ySampleData <- sampleData[sampleData$Arrest == 1, ]
nrow(ySampleData)

# Randomly collect an equal number of opposing
nSampleData <- sampleData[sampleData$Arrest == 0, ]
set.seed(111)
nSampleData <- nSampleData[sample(nrow(nSampleData), 1302, replace = FALSE),]

# Combine the two and reorder
sampleData <- rbind(ySampleData, nSampleData)

# Randomize the order of the data to allow for random sampling of the thirds selected
table(sampleData$Arrest)
set.seed(111)
randIndex <- sample(1:dim(sampleData)[1])

# Create a 2/3 cut point by dividing the data into thirds
cutPoint2_3 <- floor(2 * dim(sampleData)[1]/3+1)
cutPoint2_3

# Create the training and testing data off of the 2/3 cut point
trainData <- sampleData[randIndex[1:cutPoint2_3],]
testData <- sampleData[randIndex[(cutPoint2_3):dim(sampleData)[1]],]

# Create the SVM expression with the following parameters
set.seed(111)
svmOutput <- ksvm(Arrest ~ ., data = trainData, kernel = "rbfdot", cost = 1, 
                  cross = 10, prob.model = TRUE)
svmOutput

# Examine the support vectors
svmHist <- hist(alpha(svmOutput)[[1]], main="Support Vector Histogram with cost = 1", 
                xlab="Support Vector Values")

# Test the created model against the test data set
svmPred <- predict(svmOutput, testData, type='votes')

# Create a confusion matrix of the second row of svmPred vs binSat
smvCompTable <- data.frame(testData$Arrest,svmPred[2,])
table(smvCompTable) 

# Determine the accuracy of the model
svmAcc <- (sum(diag(table(smvCompTable))))/sum(table(smvCompTable))
svmAcc
# Accuracy is 73.5%



# Random Forest Model
# Re-initialize sample data
sampleData <- crimeData

# Randomize the order of the data to allow for random sampling of the thirds selected
table(sampleData$Arrest)
set.seed(111)
randIndex <- sample(1:dim(sampleData)[1])

# Create a 2/3 cut point by dividing the data into thirds
cutPoint2_3 <- floor(2 * dim(sampleData)[1]/3+1)
cutPoint2_3

# Create the training and testing data off of the 2/3 cut point
trainData <- sampleData[randIndex[1:cutPoint2_3],]
testData <- sampleData[randIndex[(cutPoint2_3):dim(sampleData)[1]],]

# Remove the week day column as it has an adverse effect on accuracy and remove the ADDRESS column; 
# it is too large for random forest analysis
trainData <- trainData[ ,-c(3, 6)]
testData <- testData[ ,-c(3, 6)]

# Create the random forest classifier
rfOutput = randomForest(x = trainData[-7], y = trainData$Arrest, ntree = 500, 
                        set.seed = 111)

# Predict the rest set results
rfPred = predict(rfOutput, newdata = testData[-7])

# Making the Confusion Matrix
rfCompTable = table(testData[, 7], rfPred)
rfCompTable

# Determine the accuracy of the model
rfAcc <- (sum(diag(rfCompTable)))/sum(rfCompTable)
rfAcc
# Accuracy is 78.6%

# Plot the model
plot(rfOutput)



# Refined Random Forest Model
# Re-initialize sample data
sampleData <- crimeData

# Randomize the order of the data to allow for random sampling of the thirds selected
table(sampleData$Arrest)
set.seed(111)
randIndex <- sample(1:dim(sampleData)[1])

# Subset the sample data so as to create 50% yes, and 50% no
# Collect all succesful arrests
ySampleData <- sampleData[sampleData$Arrest == 1, ]
nrow(ySampleData)

# Randomly collect an equal number of opposing
nSampleData <- sampleData[sampleData$Arrest == 0, ]
set.seed(111)
nSampleData <- nSampleData[sample(nrow(nSampleData), 1302, replace = FALSE),]

# Combine the two and reorder
sampleData <- rbind(ySampleData, nSampleData)

# Randomize the order of the data to allow for random sampling of the thirds selected
table(sampleData$Arrest)
set.seed(111)
randIndex <- sample(1:dim(sampleData)[1])

# Create a 2/3 cut point by dividing the data into thirds
cutPoint2_3 <- floor(2 * dim(sampleData)[1]/3+1)
cutPoint2_3

# Create the training and testing data off of the 2/3 cut point
trainData <- sampleData[randIndex[1:cutPoint2_3],]
testData <- sampleData[randIndex[(cutPoint2_3):dim(sampleData)[1]],]

# Remove the week day column as it has an adverse effect on accuracy and remove the ADDRESS column; 
# it is too large for random forest analysis
trainData <- trainData[ ,-c(3, 6)]
testData <- testData[ ,-c(3, 6)]

# Create the random forest classifier
rfOutput = randomForest(x = trainData[-7], y = trainData$Arrest, ntree = 500, localImp = TRUE, 
                        set.seed = 111)

# Predicting the rest set results
rfPred = predict(rfOutput, newdata = testData[-7])

# Making the Confusion Matrix
rfCompTable = table(testData[, 7], rfPred)
rfCompTable

# Determine the accuracy of the model
rfAcc <- (sum(diag(rfCompTable)))/sum(rfCompTable)
rfAcc
# Accuracy is 78.6%

# Plot the model
plot(rfOutput)

# Create multi-way variable importance plot
importance_frame <- measure_importance(rfOutput)
plot_multi_way_importance(importance_frame, size_measure = "no_of_nodes")



# Create Map of Crime
# Convert addresses to strings and add the city and state to each
addresseses <- sapply(crimeData$ADDRESS, toString)
addresseses <- paste(addresseses, ", Syracuse, NY", sep="")

# Initialize data frame for storing geocoding information
geocoded <- data.frame(addresseses, stringsAsFactors = FALSE)

geocoded["lat"] = ""
geocoded["lon"] = ""

# Get the latitude and longitude of each address through the data science tool kit
for(i in 1:nrow(geocoded))
{
  result <- geocode(geocoded$addresses[i], output = "latlona", source = "dsk")
  geocoded$lon[i] <- as.numeric(result[1])
  geocoded$lat[i] <- as.numeric(result[2])
  geocoded$geoAddress[i] <- as.character(result[3])
}

result <- geocode(geocoded$addresses[1], output = "latlona", source = "dsk")

# Group by address and obtain count
geocoded %>% group_by("addresses", lat, lon) %>% mutate(count = n())
geocoded$lat <- as.numeric(geocoded$lat)
geocoded$lon <- as.numeric(geocoded$lon)

# Plot the data as a heat map via leaflet
leaflet(geocoded) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addWebGLHeatmap(lng = ~lon, lat = ~lat, size = 250)