library(ggplot2)
# Download the file from the official URL
# https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", 
             method="auto", destfile = "data.zip")


# Read Files in R format
NEI <- readRDS(unzip("data.zip", "summarySCC_PM25.rds"))
SCC <- readRDS(unzip("data.zip", "Source_Classification_Code.rds"))

# We need to extract Emissions from sources that uses Coal for Combustion
# First filter by searching for "Comb" in SCC.Level.One from SCC
SCC_Coal_Comb <- SCC[grepl("Comb", SCC$SCC.Level.One) == TRUE, ]
# Then filter by searching for "Coal" in SCC.Short.Name
SCC_Coal_Comb <- SCC_Coal_Comb[grepl("Coal", SCC_Coal_Comb$Short.Name) == TRUE, ]
# Filter from NEI all observations which have SCC in SCC_Coal_Comb$SCC
Z <- subset(NEI, SCC %in% SCC_Coal_Comb$SCC, select=c("Emissions","year"))
# Finally aggregate Emissions by year to summarise
Y <- aggregate(Z["Emissions"], by=c(Z["year"]), FUN=sum)

# Open file
png(file="plot4.png", width=480, height=480)

# Plot using year as x-axis, Emissions as y-axis. Group = 1 (just one group)
# Type of plot: draw a line with data: geom_line()
# Also add the points: geom_point()
# and Finally using a linear model draw a line to show the tendency: geom_smooth()
T_plot <- ggplot(data=Y, aes(x=as.factor(year), y=Emissions, group=1)) + 
  geom_line(stat="identity", size=1.5, color="#9E9AC8") + 
  geom_point(aes(x=as.factor(year), y=Emissions), size=3, shape=22, fill="#54278F") +
  geom_smooth(method="lm", colour="orange", linetype=3, size=1, se=FALSE, aes(group=1)) +
  xlab("Year") + ylab("Total Emissions") + ggtitle("Coal Combustion - All USA")

print(T_plot)
# Close file
dev.off()
