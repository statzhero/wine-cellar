URL <- 'https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/339362/GH_Wine_Cellar_and_consumption_dataset_July_2014.csv'
URLbackup <- 'https://raw.githubusercontent.com/statshero/wine-cellar/master/GH_Wine_Cellar_and_consumption_dataset_July_2014.csv'

# NOT WORKING - but why...
wine <- read.csv(URL)

# Introducing a function - there are other ways.
read.csv.ssl <- function(url, ...){
  tmpfile <- tempfile()
  download.file(url, destfile = tmpfile, method = "curl")
  urldata <- read.csv(tmpfile, ...)
  return(urldata)
}

wine <- read.csv.ssl(URL)

######----------------------------------------
# Now the questions: is it 'machine-readable'? 

# Encoding errors in Product.Name
wine[1, ]

# What type are the columns? 
sapply(wine, class)

# Factors, hmmmm

options(stringsAsFactors = FALSE) # TRUE is a terrible R default
wine <- read.csv.ssl(URL)

sapply(wine, class)

# Shouldn't vintage and consumption be numeric?!
# We can force it - but what happens is a mystery
# There is a warning
# THIS IS BAD!

wine$Vintage <- as.numeric(wine$Vintage) 
# Abort, abort

wine_original <- read.csv.ssl(URL)
wine <- wine_original # copies the data, no more waiting for downloading


# We know that a year should have four digits
# Here are four ways to do it. They have different advantages or drawbacks.
# You should've seen all of them

# wine$Vintage[nchar(wine$Vintage) != 4]
# wine[nchar(wine[, 2]) != 4, 2]
# wine[nchar(wine[, "Vintage"]) != 4, "Vintage"]
subset(wine, nchar(Vintage) != 4, select = Vintage)

# Well...
# NV = no value? Probably, but we're guessing. Which is also BAD. Heyho.
wine$Vintage[wine$Vintage == "NV"] <- NA
wine$Vintage[wine$Vintage == ""] <- NA

wine$Vintage <- as.numeric(wine$Vintage)


# We could go further and import them as dates
# However, it needs a little hack to set as dates
# Working with dates = NIGHTMARES GUARANTEED
as.Date(paste0(wine$Vintage[1:5], "-01-01"))
# Plus nice function name: dot AND camelCase

# Now stuff like this is more meaningful
summary(wine$Vintage)

# Makes minimal sense
hist(wine$Vintage)

# Sooooo
# So what's up with Consumption?
wine$Consumption.April.2013...March.2014[nchar(wine$Consumption.April.2013...March.2014) > 3]

# Aha! Aha... :(

# We could replace them as before with custom assignments, but let's use a power tool

## XXXXXXXXXXXX ##

# Table with missings
# as default: http://stackoverflow.com/questions/21724212/set-r-to-include-missing-data-how-can-is-set-the-usena-ifany-option-for-t
table(wine[, 4], useNA = 'ifany')

# Default visualisation
plot(table(wine[, 2]))

# This below doesn't even work
plot(wine$Vintage, wine$Grade)

# Get package
if(!"ggplot2" %in% installed.packages()) install.packages("ggplot2")
library(ggplot2)

ggplot(data = wine, aes(x = Vintage)) + geom_histogram()

# Other stuff
ggplot(data = wine, aes(Vintage, Grade)) + geom_point()
ggplot(data = wine, aes(Vintage, Grade)) + geom_jitter()
ggplot(data = wine, aes(Grade, Country.Region)) + geom_jitter()

#--------COSMETICS------------
# Note changing column names will make some of code above not work.

# FAST way 
names(wine)
colnames(wine) <- c("Country.Region", "Vintage", "Product.Name", "Grade", "Consumption")

# SAFE way
if(!"plyr" %in% installed.packages()) install.packages("plyr")
library(plyr)
wine <- rename(wine, c("Country.Region" = "countryregion",
                       "Vintage" = "vintage",
                       "Product.Name" = "productname",
                       "Grade" = "grade",
                       "Consumption" = "consumption"))

# SCALABLE way
if(!"data.table" %in% installed.packages()) install.packages("data.table")
library(data.table)
?setnames

# Export as a simple file
write.csv(wine, "UK-wine-cellar-2014-CLEAN.csv", row.names = FALSE, na = "")




