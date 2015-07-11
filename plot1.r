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

png(filename="plot1.png", width = 480, height = 480, units = "px")
hist(dataSrc$Global_active_power, 
     xlab="Global Active Power(kilowatts)",
     main="Global Active Power",
     col="red")
dev.off()
