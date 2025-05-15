# Importing the csv file
steam_games <- read.csv("steam_games.csv", header = TRUE, sep=",")
steam_games

# Installing libraries I will use
install.packages("tidyverse")
install.packages("stringr")
install.packages("tidyr")

# Loading the libraries
library(tidyverse)
library(stringr)
library(tidyr)

# Cleaning and extracting parts
cleaned_reviews <- steam_games %>%
  filter(!is.na(all_reviews)) %>%
  mutate(
    rating_label = str_extract(all_reviews, "^[^,]+"), # Gets "Positive" for example
    percent_positive = str_extract(all_reviews, "\\d+%") %>%
      str_remove("%") %>%
      as.numeric() / 100) # 92% to 0.92 for example

# For top rated games
top_rated <- cleaned_reviews %>% filter(percent_positive >= 0.85)

# For the tags, I'll separate the tags into rows
tags <- top_rated %>%
  separate_rows(popular_tags, sep = ",") %>%
  mutate(popular_tags = str_trim(popular_tags)) %>%
  filter(popular_tags != "")

# Most common tags
tag_counts <- tags %>%
  count(popular_tags, sort = TRUE)

# Plotting the top 10
tag_counts %>%
  top_n(10, n) %>%
  ggplot(aes(x = reorder(popular_tags, n), y = n)) +
  geom_col(fill = "darkgreen") +
  coord_flip() +
  labs(
    title = "Top 10 Tags Among Highly Rated Steam Games",
    x = "Tag",
    y = "Number of Games"
  )

# Getting the top genres
# Filtering top-reveiwed
# "x %>% f()" is basically "f(x)" (from tidyverse)
# genre_data <- steam_data %>% separate_rows(genre, sep=",") %>% filter(!is.na(review_score) & review_score > 0.85)

