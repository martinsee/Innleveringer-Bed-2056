install.packages("lubridate")
library(lubridate)
library(ggplot2)
library(dplyr)
getwd()
setwd("C:/Users/Martin/Documents/R")
options(scipen = 9999999)

eqnr_data <- read.csv("https://www.netfonds.no/quotes/paperhistory.php?paper=EQNR.OSE&csv_format=csv")
nhy_data <- read.csv("https://www.netfonds.no/quotes/paperhistory.php?paper=NHY.OSE&csv_format=csv")

# converting to date using lubridate:
eqnr_data$quote_date <- ymd(eqnr_data$quote_date)
str(eqnr_data)

# converting to date using lubridate: 
nhy_data$quote_date <- ymd(nhy_data$quote_date)
str(nhy_data)

comb_data <- rbind(eqnr_data, nhy_data) #slår sammen datasettene i en
head(comb_data) #sjekker at observasjonene er fra EQNR
tail(comb_data) # sjekker at observasjonene er fra NHY

final_data <- comb_data %>%
  filter(quote_date >= "2010-01-04") #fjerner data tidligere enn jan 2010.

ggplot(final_data, aes(x=quote_date, y=close, colour=paper)) +
  geom_line() + ggtitle("EQNR & NHY since jan 2010") + labs(x="Year", y="Value", colour = "Stock")

eqnr_2010 <- filter(final_data, paper == "EQNR") #filtrerer ut EQNR og NHY for å beregne diff log.
nhy_2010 <- filter(final_data, paper == "NHY")
ret_eqnr <- c(100,diff(log(eqnr_2010$close))) #Legger inn 100 som startverdi.
ret_nhy <- c(100,diff(log(nhy_2010$close))) 
head(df_eqnr)

df_eqnr <- data.frame(eqnr_2010$quote_date, eqnr_2010$paper, cumsum(ret_eqnr)) #slår sammen dato, aksje og kumulative sum av return beregnet
df_nhy <- data.frame(nhy_2010$quote_date, nhy_2010$paper, cumsum(ret_nhy))
colnames(df_eqnr)<- c("Dato", "Aksje", "Return") #Gir like kolonnenavn for å kunne bruke rbind
colnames(df_nhy) <- c("Dato", "Aksje", "Return")

ret_data <- rbind(df_eqnr,df_nhy)
ggplot(ret_data, aes(x=Dato, y=Return, color=Aksje)) + geom_line()
#Trur dataen er baklengs. Begge slutter på hundre.
