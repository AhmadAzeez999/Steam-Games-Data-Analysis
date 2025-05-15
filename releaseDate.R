# library(dplyr)
# library(stringr)
# library(lubridate)
# library(ggplot2)
# library(scales)  # For better formatting of axis labels

# Clean and prepare the data
reviews_by_year <- steam_games %>%
  filter(!is.na(all_reviews)) %>%
  mutate(
    number_of_reviews = str_extract(all_reviews, "\\(\\d{1,3}(,\\d{3})*\\)") %>%
      str_remove_all("[(),]") %>%
      as.numeric(),
    price = str_remove_all(original_price, "[$]") %>%
      as.numeric(),
    release_year = year(mdy(release_date))  # Convert release_date to year
  ) %>%
  filter(!is.na(release_year) & !is.na(number_of_reviews)) %>%
  filter(release_year >= 2000 & release_year <= 2023) %>%  # Filter reasonable year range
  select(name, release_year, price, number_of_reviews)

# Create year groups for more meaningful analysis
reviews_by_year <- reviews_by_year %>%
  mutate(
    era = case_when(
      release_year < 2010 ~ "Pre-2010",
      release_year < 2015 ~ "2010-2014",
      release_year < 2020 ~ "2015-2019",
      TRUE ~ "2020+"
    )
  )

# Calculate average reviews by year
avg_reviews_by_year <- reviews_by_year %>%
  group_by(release_year) %>%
  summarize(
    avg_reviews = mean(number_of_reviews, na.rm = TRUE),
    median_reviews = median(number_of_reviews, na.rm = TRUE),
    game_count = n()
  )

# Plot 1: Scatter plot with trend line
p1 <- ggplot(reviews_by_year, aes(x = release_year, y = number_of_reviews)) +
  geom_point(alpha = 0.2, color = "steelblue", size = 2) +
  geom_smooth(method = "loess", se = TRUE, color = "darkred") +
  scale_y_log10(labels = comma) +
  scale_x_continuous(breaks = seq(2000, 2023, by = 2)) +
  labs(
    title = "Game Popularity by Release Year",
    subtitle = "Each point represents a game, log scale used for reviews",
    x = "Release Year",
    y = "Number of Reviews (Log Scale)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 10, color = "darkgray"),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

# Plot 2: Box plot by era to see distribution
p2 <- ggplot(reviews_by_year, aes(x = era, y = number_of_reviews, fill = era)) +
  geom_boxplot(outlier.alpha = 0.5, outlier.size = 1) +
  scale_y_log10(labels = comma) +
  scale_fill_brewer(palette = "Blues") +
  labs(
    title = "Distribution of Game Popularity by Era",
    x = "Game Release Era",
    y = "Number of Reviews (Log Scale)"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

# Plot 3: Average reviews by year with game count
p3 <- ggplot(avg_reviews_by_year, aes(x = release_year)) +
  geom_col(aes(y = game_count), fill = "lightblue", alpha = 0.6) +
  geom_line(aes(y = avg_reviews / 10), color = "darkred", size = 1.5) +
  scale_y_continuous(
    name = "Number of Games",
    sec.axis = sec_axis(~.*10, name = "Average Reviews per Game")
  ) +
  scale_x_continuous(breaks = seq(2000, 2023, by = 2)) +
  labs(
    title = "Game Releases and Average Popularity by Year",
    subtitle = "Bars show game count; Line shows average review count",
    x = "Release Year"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    axis.title.y.left = element_text(color = "lightblue4"),
    axis.title.y.right = element_text(color = "darkred")
  )

# Identify top games by era to see which era dominates the top charts
top_games <- reviews_by_year %>%
  arrange(desc(number_of_reviews)) %>%
  group_by(era) %>%
  slice_head(n = 10) %>%
  ungroup()

# Calculate statistics for conclusions
era_stats <- reviews_by_year %>%
  group_by(era) %>%
  summarize(
    avg_reviews = mean(number_of_reviews, na.rm = TRUE),
    median_reviews = median(number_of_reviews, na.rm = TRUE),
    total_reviews = sum(number_of_reviews, na.rm = TRUE),
    game_count = n(),
    reviews_per_game = total_reviews / game_count
  ) %>%
  arrange(desc(avg_reviews))

# Print summary statistics
print(era_stats)

# Print top 20 games overall by popularity
top_overall <- reviews_by_year %>%
  arrange(desc(number_of_reviews)) %>%
  select(name, release_year, number_of_reviews) %>%
  head(20)

print(top_overall)

# Display plots
p1
p2
p3