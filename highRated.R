
high_rated <- cleaned_reviews %>%
  filter(!is.na(percent_positive), percent_positive >= 0.85)

# Top Developers
top_devs <- high_rated %>%
  filter(!is.na(developer)) %>%
  count(developer, sort = TRUE)

# Top Publishers
top_publishers <- high_rated %>%
  filter(!is.na(publisher), publisher != "") %>%
  count(publisher, sort = TRUE)

# Developers
ggplot(top_devs %>% top_n(10, n), aes(x = reorder(developer, n), y = n)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(
    title = "Top 10 Developers by High-Rated Games",
    x = "Developer",
    y = "Number of High-Rated Games"
  )

# Publishers
ggplot(top_publishers %>% top_n(10, n), aes(x = reorder(publisher, n), y = n)) +
  geom_col(fill = "darkgreen") +
  coord_flip() +
  labs(
    title = "Top 10 Publishers by High-Rated Games",
    x = "Publisher",
    y = "Number of High-Rated Games"
  )
