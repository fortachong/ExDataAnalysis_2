# Author: Jorge Chong
library(ggplot2)
# Download the file from the official URL
# https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", 
              method="auto", destfile = "data.zip")


# Read Files in R format
NEI <- readRDS(unzip("data.zip", "summarySCC_PM25.rds"))
SCC <- readRDS(unzip("data.zip", "Source_Classification_Code.rds"))

# Filter data from Baltimore City (fips = 24510), select columns: Emissions, year, type
Z <- NEI[NEI$fips=="24510", c("Emissions", "year", "type")]
# Aggregate data by year and type (Sum of Emissions)
Y <- aggregate(Z["Emissions"], by=c(Z["year"],Z["type"]), FUN=sum)
# Open file
png(file="plot3.png", width=480, height=480)
# plot using year in the x axis, Emissions in the y axis, group by type
# Type of graph: Line graph, using geom_point to show the points
g <- ggplot(data=Y, aes(x=as.factor(year), y=Emissions, group=type)) 
print(g + 
        geom_line(aes(colour=type), stat="identity", size=1.5) 
      + geom_point(aes(x=as.factor(year), y=Emissions), size=3, shape=22, fill="#54278F")
      + xlab("Year") + ylab("Total Emissions") + ggtitle("Baltimore Emissions by Year and Type")
)
# Close file
dev.off()
