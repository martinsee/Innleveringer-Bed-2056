install.packages("readr")
library(readr)

sex <- read.fwf("ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/natality/Nat2017us.zip", widths = c(-474,1))
head(sex)
#Får bare en masse warnings: Line xxx appears to contain embedded null.


