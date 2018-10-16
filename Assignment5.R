install.packages("readr")
library(readr)
install.packages("mosaic")
library(mosaic)
library(dplyr)

getwd()
births_data <- read_fwf("Nat2017PublicUS.c20180516.r20180808.txt", 
                fwf_positions(start = c(13,475,504), 
                              end = c(14, 475, 507),
                              col_names = c("month", "gender", "weight")))

births_data <- filter(births_data, weight <9999)
tally(~gender, data=births_data)

births_data$weight <- as.numeric(births_data$weight)
births_data$gender <- as.factor(births_data$gender)
births_data$month <- as.factor(births_data$month)
str(births_data)
tally(~gender, data=births_data)
tally(~gender, data=births_data, format = "percent")

births_data <- births_data %>% mutate(april_august = month %in% c("04","08"))
head(filter(births_data, month == "08"))

favstats(weight~gender+april_august, data=births_data)

