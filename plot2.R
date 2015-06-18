# Author: Jorge Chong
library(ggplot2)
# Download the file from the official URL
# https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
# download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", 
#              method="auto", destfile = "data.zip")


# Read Files in R format
#NEI <- readRDS(unzip("data.zip", "summarySCC_PM25.rds"))
#SCC <- readRDS(unzip("data.zip", "Source_Classification_Code.rds"))
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Filter Emissions from Baltimore City (fips=24510)
Z <- NEI[X$fips=="24510", c("Emissions", "year")]
# Aggregate Emissions by year
Y <- aggregate(Z["Emissions"], by=Z["year"], FUN=sum)
# Open png file
png(file="plot2.png", width=480, height=480)
# Plot a line with the data
with(Y, plot(year, Emissions, type="l", col="#9E9AC8", 
             lwd=3, 
             main="PM2.5 Emissions - Baltimore", 
             xlab="Year", 
             ylab="Total Emissions"))
# Add the points
points(Y, bg="#54278F", pch=22, cex=2)
# Add a line to show the tendency
abline(lm(Emissions~year, data=Y), col="orange", lty=2, lwd=2)
# Close file
dev.off()
