URL <- 'https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/339362/GH_Wine_Cellar_and_consumption_dataset_July_2014.csv'

# NOT WORKING - but why
wine <- read.csv(URL)

# Introducing a function

read.csv.ssl <- function(url, ...){
  tmpfile <- tempfile()
  download.file(url, destfile = tmpfile, method = "curl")
  urldata <- read.csv(tmpFile, ...)
  return(urldata)
}


wine <- read.csv.ssl(URL)

######----------------------------------------
# Now the questions: is it 'machine-readile'? 

# Encoding errors in Product.Name
wine[1, ]

# What type are the columns? 
sapply(wine, class)

# Hmmmm

options(stringsAsFactors = FALSE)
wine <- read.csv.ssl(URL)

sapply(wine, class)

# Shouldn't consumption be numeric?!
# We can force it - but what happens is a mystery
# THIS IS BAD!
wine$Consumption.April.2013...March.2014 <- as.numeric(wine$Consumption.April.2013...March.2014) 
# Abort, abort

wine_original <- read.csv.ssl(URL)
wine <- wine_original # copies the data, no more waiting for downloading

# So what's up with Consumption?
wine$Consumption.April.2013...March.2014[nchar(wine$Consumption.April.2013...March.2014) > 3]

# Aha! Aha... :(



# Table with missings
# as default: http://stackoverflow.com/questions/21724212/set-r-to-include-missing-data-how-can-is-set-the-usena-ifany-option-for-t
table(wine[, 4], useNA = 'ifany')

# Quick visualisations
plot(table(wine[, 2]))

# NOT great default
# This doesn't even work
plot(wine$Vintage, wine$Grade)

# Get package
if(!"ggplot2" %in% installed.packages()) install.packages("ggplot2")
library(ggplot2)

qplot(Vintage, data = wine)

# This raises more questions: 
# What does 'NV' stand for? 
# Why the spike at 1990? 
# Why are some vintage years left blank? 

# Other stuff
qplot(Vintage, Grade, data = wine)
qplot(Vintage, Grade, data = wine, geom = 'jitter')

qplot(Grade, Country.Region, data = wine, geom = 'jitter')

