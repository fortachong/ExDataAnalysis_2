library(ggplot2)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# 1
Y <- aggregate(NEI["Emissions"], by=NEI["year"], FUN=sum)
with(Y, plot(year, Emissions, type="l", col="#9E9AC8", 
             lwd=3, 
             main="PM2.5 Emissions", 
             xlab="Year", 
             ylab="Total Emissions"))
points(Y, bg="#54278F", pch=22, cex=2)
abline(lm(Emissions~year, data=Y), col="orange", lty=2, lwd=2)
