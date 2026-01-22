# Create dataframe with all OpenESM constructs and their count
# ---- 

#install.packages("rvest")

library(rvest)
library(dplyr)
library(stringr)
library(tibble)

doc <- read_html("VariablesESM.html") #HTML code of available constructs
#from the page: https://openesmdata.org/search/
#the Constructs drop down menu

#scrape HTML code and create data frame with:
#construct name
#in how many papers it appears (count)

df_all_constructs <- doc %>%
  html_elements("#construct-dropdown .construct-item") %>%
  lapply(\(node) {
    tibble(
      construct = node %>% html_element("label") %>% html_text2(),
      count = node %>%
        html_element(".construct-count") %>%
        html_text2() %>%
        str_extract("\\d+") %>%
        as.integer()
    )
  }) %>%
  bind_rows() %>%
  arrange(desc(count))

#remove constructs that appear in only 1 study
df_constructs <- df_constructs %>%
  filter(count > 1)

#----


# save as csv file
write.csv(df_constructs, "PossibleConstructs.csv", row.names = FALSE)
