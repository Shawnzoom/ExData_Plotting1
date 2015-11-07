# Introduction
# This assignment uses data from the UC Irvine Machine Learning Repository http://archive.ics.uci.edu/ml/ , a popular repository for machine learning datasets. In particular, we will be using the "Individual household electric power consumption Data Set" which I have made available on the course web site:
#   . Dataset: Electric power consumption [20Mb] https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
# . Description: Measurements of electric power consumption in one household with a one-minute sampling rate over a period of almost 4 years. Different electrical quantities and some sub-metering values are available.
# The following descriptions of the 9 variables in the dataset are taken from the UCI web site https://archive.ics.uci.edu/ml/datasets/Individual+household+electric+power+consumption:
#   1. Date: Date in format dd/mm/yyyy 
# 2. Time: time in format hh:mm:ss 
# 3. Global_active_power: household global minute-averaged active power (in kilowatt) 
# 4. Global_reactive_power: household global minute-averaged reactive power (in kilowatt) 
# 5. Voltage: minute-averaged voltage (in volt) 
# 6. Global_intensity: household global minute-averaged current intensity (in ampere) 
# 7. Sub_metering_1: energy sub-metering No. 1 (in watt-hour of active energy). It corresponds to the kitchen, containing mainly a dishwasher, an oven and a microwave (hot plates are not electric but gas powered). 
# 8. Sub_metering_2: energy sub-metering No. 2 (in watt-hour of active energy). It corresponds to the laundry room, containing a washing-machine, a tumble-drier, a refrigerator and a light. 
# 9. Sub_metering_3: energy sub-metering No. 3 (in watt-hour of active energy). It corresponds to an electric water-heater and an air-conditioner.
# 
# 
# Loading the data
# When loading the dataset into R, please consider the following:
#   . The dataset has 2,075,259 rows and 9 columns. First calculate a rough estimate of how much memory the dataset will require in memory before reading into R. Make sure your computer has enough memory (most modern computers should be fine).
# . We will only be using data from the dates 2007-02-01 and 2007-02-02. One alternative is to read the data from just those dates rather than reading in the entire dataset and subsetting to those dates.
# . You may find it useful to convert the Date and Time variables to Date/Time classes in R using the strptime() and as.Date() functions.
# . Note that in this dataset missing values are coded as ?.



# set project directory to the dir with "household_power_consumption.txt"
project_dir <- setwd("e:/rcode/chap04/project1")

# load libraries
library(data.table)
library(lubridate)
library(ggplot2)
library(plyr)

# read "household_power_consumption.txt" into a data table
system.time(DT <- fread("household_power_consumption.txt", sep = ";", header = TRUE, data.table = TRUE )) 

# create a subset data table with observations only for 1st and 2nd Feb 2007
DT2 <- DT[DT$Date == "1/2/2007" | DT$Date == "2/2/2007",]

# create data frame from data table
DF2 <- as.data.frame(DT2)

# free memory from original data table
DT <- ""

# convert DF2$Date to Date format
DF2$Date <- dmy(DF2$Date)

# PLOT 4 goes here
# create a date time version of the Time column
DF2$xtime <- hms(DF2$Time)

# create duration version of the Time column
DF2$dtime <- as.duration(DF2$xtime)

# prepare voltage vector for plotting
DF2$volt <- as.numeric(DF2$Voltage)

# prepare voltage vector for plotting
DF2$reactive <- as.numeric(DF2$Global_reactive_power)


# create a numeric version of Sub_metering_1
DF2$sub1 <- as.numeric(DF2$Sub_metering_1)

# prepare second plot ; create a numeric version of Sub_metering_2
DF2$sub2 <- as.numeric(DF2$Sub_metering_2)


#prepare third plot: create a numeric version of Sub_metering_3
DF2$sub3 <- as.numeric(DF2$Sub_metering_3)


par(mfrow = c(2, 2))
with(DF2, {
  
  # add plot at position 1,1
  plot(ymd(Date) + dtime, Global_active_power, xlab = "", ylab = "Global Active Power", type = "l")
  
  # add plot at position 1,2
  plot(ymd(Date) + dtime, volt, xlab = "datetime", ylab = "Voltage", type = "l")
  
  # add plot at position 2,1
    #Create 'empty' plot
    with(DF2, plot(ymd(Date) + dtime, sub1, xlab = "", ylab = "Energy sub metering", type = "n"))
    
    # add first plot
    with(DF2, lines(ymd(Date) + dtime, sub1))
    
    # add 
    with(DF2, lines(ymd(Date) + dtime, sub2, col = "red"))
    
    #add third plot
    with(DF2,  lines(ymd(Date) + dtime, sub3, col = "blue"))
    
    # add legend
    legend("topright", pch = "-", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty = "n", y.intersp = 1, lwd = 4)
  
  
  # add plot at position 2,2
  plot(ymd(Date) + dtime, reactive, xlab = "datetime", ylab = "Global_reactive_power", type = "l")
  
})

# copy plot to a PNG file
dev.copy(png, file = "plot4.png", width = 480, height = 480)

#  close the PNG device!
dev.off()