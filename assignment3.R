install.packages("PxWebApiData")
install.packages("stringr")
install.packages("anytime")
library(anytime)
library(PxWebApiData)
library(stringr)
library(dplyr)
library(tidyr)

nasjon <- ApiData("http://data.ssb.no/api/v0/dataset/95276.json?lang=no", getDataByGET = TRUE)
fylke <- ApiData("http://data.ssb.no/api/v0/dataset/95274.json?lang=no,", getDataByGET = TRUE)

nasjon <- nasjon[[2]]
fylke <- fylke[[2]]

joined_data <- full_join(nasjon, fylke)
head(joined_data)
tail(joined_data)
str(joined_data)

joined_data$Tid <- str_replace_all(joined_data$Tid, "M", "/")
joined_data$Tid <- anydate(joined_data$Tid)
head(joined_data)
str(joined_data)
summary(joined_data)

cleaned_data <- spread(joined_data, key = ContentsCode, value = value)
cleaned_data <- filter(cleaned_data, PrisRom > 0)

tibble_meanprice <- cleaned_data %>% 
  group_by(Region) %>%
  summarise(MeanPrice = mean(PrisRom))

tibble_meanprice$Region <- c("NORGE", "Østfold", "Akershus", "Oslo", "Hedmark", "Oppland", "Buskerud", "Vestfold","Telemark", "Aust-Agder", "Vest-Agder", "Rogaland", "Hordaland", "Sogn og Fjordane","Møre og Romsdal", "Sør-Trøndelag (-2017)", "Nord-Trøndelag (-2017)","Nordland", "Troms", "Finnmark", "Svalbard","Trøndelag")
high_to_low <- arrange(tibble_meanprice,-MeanPrice)
high_to_low[1:8,1] #Higher than national mean
high_to_low[10:22,1] #Lower than national mean
#Har ikke tatt hensyn til tidsperioden for data til Trøndelag og Svalbard.

cor(cleaned_data$Kaputnytt, cleaned_data$PrisRom)
#cor = 0.1127, no correlation between capacity and price

cor(cleaned_data$KaputnyttRom, cleaned_data$PrisRom)
#cor = 0.2221, slightly more correlation, but still very small