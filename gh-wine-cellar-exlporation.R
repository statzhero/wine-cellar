URL <- 'https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/339362/GH_Wine_Cellar_and_consumption_dataset_July_2014.csv'

# NOT WORKING
wine <- read.csv(URL)

# Introducing a function

read.csv.ssl <- function(url, ...){
  tmpFile <- tempfile()
  download.file(url, destfile = tmpFile, method = "curl")
  url.data <- read.csv(tmpFile, ...)
  return(url.data)
}

wine <- read.csv.ssl(URL)
