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

# Filter from SCC only Motor vehicles. My criteria is Mobile and On-Road
SCC2 <- SCC[grepl("Mobile - On-Road", SCC$EI.Sector) == TRUE, ]
# Filter from NEI all observations in Baltimore City which have SCC in SCC2
Z <- subset(NEI, fips=="24510" & SCC %in% SCC2$SCC, select=c("Emissions","year"))
# Aggregate Emissions by year
Y <- aggregate(Z["Emissions"], by=c(Z["year"]), FUN=sum)

# Open file
png(file="plot5.png", width=480, height=480)

# Plot data
# I decided to draw bars: geom_bar()
# And add a line to show the tendency: geom_smooth()
g <- ggplot(data=Y, aes(x=as.factor(year), y=Emissions)) 
print(g + 
        geom_bar(colour="#54278F", fill="#9E9AC8", stat="identity") 
      + geom_smooth(method="lm", colour="#54278F", linetype=3, size=2, se=FALSE, aes(group=1))
      + xlab("Year") + ylab("Total Emissions") + ggtitle("Baltimore - Motor Vehicles")
)

# Close file
dev.off()
