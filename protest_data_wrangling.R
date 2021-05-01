
library(dplyr)

data <- read.csv('data/count_love.csv', stringsAsFactors = FALSE)
data$state_abbrev <- toupper(stringr::str_sub(data$Location, start = -2))
# a data frame of US states 
us_state <- read.csv('data/us_state.csv', stringsAsFactors = FALSE)

df <- data %>% 
  group_by(state_abbrev) %>% 
  summarise(N = n()) %>% 
  inner_join(us_state, by = c("state_abbrev" = "Code")) %>% 
  select(-Abbrev) %>% 
  arrange(desc(N))
colnames(df) <- c("abbv", "N", "full")

write.csv(df, 'data/filtered_countlove_df.csv', row.names = FALSE)
