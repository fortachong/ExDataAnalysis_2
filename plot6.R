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
# Filter from NEI all observations in Baltimore City and Los Angeles which have SCC in SCC2
Z <- subset(NEI, (fips=="24510" | fips=="06037") & SCC %in% SCC2$SCC, select=c("fips","Emissions","year"))
# Aggregate Emissions by fips and year
Y <- aggregate(Z["Emissions"], by=c(Z["fips"], Z["year"]), FUN=sum)

# Open file
png(file="plot6.png", width=480, height=480)

# Plot Data
# User bars: geom_bar()
# 
g <- ggplot(data=Y, aes(x=as.factor(year), y=Emissions, fill=fips)) 
print(g + facet_wrap(~fips) + geom_bar(stat="identity") +
        scale_fill_manual(values = rev(brewer.pal(6, "Purples")), name="City", breaks=c("06037","24510"), labels=c("Los Angeles", "Baltimore")) +
        geom_smooth(method="lm", linetype=4, size=1, color="orange", se=FALSE, aes(group=1)) + 
        xlab("Year") + ylab("Total Emissions") + ggtitle("Motor Vehicles")
)

# Close file
dev.off()
