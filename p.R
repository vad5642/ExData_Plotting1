dataSrc <- read.delim(tmpFileName, sep=";", na.strings=c("?"), colClasses=c("character", rep(c("numeric"), each=7)))
dataSrc[[1]] <- strptime(dataSrc[[1]], "%Y-%m-%d %H:%M:%S")

png(filename="plot4.png")
# 4 figures arranged in 2 rows and 2 columns
par(mfrow=c(2,2))

plot(dataSrc$Date_Time, 
     dataSrc$Global_active_power, 
     type="l", 
     xlab="", 
     ylab="Global Active Power(kilowatts)")

plot(dataSrc$Date_Time, 
     dataSrc$Voltage, 
     type="l", 
     xlab="datetime", 
     ylab="Voltage")

plot(dataSrc$Date_Time, 
     dataSrc$Sub_metering_1,
     type="l", 
     xlab="", 
     ylab="Energy sub metering")
lines(dataSrc$Date_Time,
      dataSrc$Sub_metering_2, 
      type="l", 
      col="red")
lines(dataSrc$Date_Time,
      dataSrc$Sub_metering_3, 
      type="l", 
      col="blue")
legend("topright", 
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       lty=c(1,1,1), 
       col=c("black","red", "blue"))

plot(dataSrc$Date_Time, 
     dataSrc$Global_reactive_power, 
     type="l", 
     xlab="datetime", 
     ylab="Global_reactive_power")
dev.off()