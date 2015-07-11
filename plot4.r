# Set locale
Sys.setlocale("LC_TIME", "English")

## Read required data range
# end copy it to a separate file

fileName <- "household_power_consumption.txt"
tmpFileName <- "tmp.txt"
dateTimeFormat <- "%d/%m/%Y %H:%M:%S"

from <-strptime("01/02/2007 00:00:00", dateTimeFormat, tz="")
to <-strptime("03/02/2007 00:00:00", dateTimeFormat, tz="")

# Open files
con = file(fileName, open="r")
conStudy = file("tmp.txt", open="w")

# Make header 
ln <- readLines(con, n=1);
d <- strsplit(ln, ";")
tmp <- paste(c("Date_Time", as.character(d[[1]][-(1:2)])), collapse=";", sep="")
writeLines(tmp, conStudy)

# Read input file line by line

repeat
{
  # Read input file line by line
  ln <- readLines(con, n=1);
  
  # Check for EOF
  if (length(ln) == 0) break;
  
  # get date ant time from the read line
  d <- strsplit(ln, ";")
  dateTime <- strptime(paste(d[[1]][[1]], d[[1]][[2]]), dateTimeFormat, tz="")
  
  # If time is not valid skip this line
  if (is.na(dateTime)) next;
  
  # if date and time is greater than upper bound exit the loop 
  if (dateTime > to) break;
  
  # if date and time are in the range write the line to output file
  # date and time is converted to R Date/Time class
  if (dateTime >= from) 
  {
    tmp <- paste(c(as.character(dateTime), as.character(d[[1]][-(1:2)])), collapse=";", sep="")
    writeLines(tmp, conStudy); 
  }
}  

# close files
close(con)
close(conStudy)

## read required range
dataSrc <- read.delim(tmpFileName, 
                      sep=";", 
                      na.strings=c("?"), 
                      colClasses=c("character", rep(c("numeric"), each=7)))

dataSrc$Date_Time <- strptime(dataSrc$Date_Time, "%Y-%m-%d %H:%M:%S")

png(filename="plot4.png", width = 480, height = 480, units = "px")
# 4 figures arranged in 2 rows and 2 columns
par(mfrow=c(2,2))

plot(dataSrc$Date_Time, 
     dataSrc$Global_active_power, 
     type="l", 
     xlab="", 
     ylab="Global Active Power (kilowatts)")

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