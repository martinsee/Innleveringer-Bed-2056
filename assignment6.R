install.packages("tibble")
library(tibble)
library(dplyr)
library(ggplot2)

#Task 1
DS = tribble(
  ~fk_account_code, ~Ansvar, ~fk_function_code, ~fk_project_code, ~amount,
  101030,40220,"Det",3432,1493.00,
  101030,40220,"Met",3586,2827.00,
  101030,40320,"Det",3456,49440.00,
  101030,40330,"Sal",NA,870716.00,
  101030,40350,"Met",NA,559928.00,
  101030,40360,"Sal",NA,125534.00,
  101030,40280,"Pol",NA,251611.00)

#1
DS <- DS %>%
  select(-fk_account_code)

#2
DS$Ansvar <- as.character(DS$Ansvar)
DS %>%
  group_by(substr(Ansvar, start = 1, stop = 3)) %>%
  summarise(sum = sum(amount)) %>%
  rename(ansvar = "substr(Ansvar, start = 1, stop = 3)")

#3
DS %>%
  mutate(new_function_code = case_when(
    fk_function_code == "Det" ~ "supplies",
    fk_function_code == "Sal" ~"inventories",
    fk_function_code == "Met" ~"inventories",
    fk_function_code == "Pol" ~"other expenses"))
  
#Task 2
df <- data.frame(Product=gl(3,10,labels=c("A","B","C")), 
                 Year=factor(rep(2002:2011,3)), 
                 Sales=1:30)
glimpse(df)

#1
df2 <- df %>%
  group_by(Year) %>%
  mutate(yearly_sales = sum(Sales)) %>%
  group_by(Year,Product) %>%
  summarise(prod_sales = sum(Sales), share_of_yearly = sum(Sales)/yearly_sales*100)

df2 %>%
  group_by(Product)

#2
ggplot(df2) +
  geom_line(aes(x=as.Date(Year, "%Y"), y=prod_sales)) +
  geom_line(aes(as.Date(Year, "%Y"), share_of_yearly)) +
  facet_wrap(~Product) +
  labs(x = "Year", y = "sales / %share of yearly")

