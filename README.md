# Steam Data Explorer – What Makes a Popular Game?

This R project dives into a dataset (from Kaggle) of Steam games to investigate the key factors that contribute to a game's popularity and rating. Using tidyverse tools, the project performs data cleaning, transformation, and visualization to get useful insights.

---

## Key Questions Explored

* Which tags appear most often in popular games?
* Are newer games more popular, or do older games still dominate?
* Which publishers and devs release the most high-rated games?


---

## Features

* **Data Cleaning**: Handles missing values, formats prices, extracts review counts from complex text, and parses dates.
* **Feature Engineering**: Adds numeric columns like `number_of_reviews`, `price`, and `release_year`.
* **Visual Analysis**:

  * Top tags among highly-rated games
  * Price vs. popularity scatter plots
  * Popularity trends over time

---

## Data Used

* `steam_games.csv` (assumed): Contains columns like `name`, `original_price`, `all_reviews`, `release_date`, `publisher`, `developer`, `popular_tags`.

---

## Tools & Libraries

* **R**
* `tidyverse` (dplyr, ggplot2, stringr, lubridate)
* `scales` for axis formatting

---

## Example Visualizations

* **Top 10 Tags Among Highly Rated Games** (Bar Chart)
* **Popularity by Release Year** (Smoothed Trend Line)
* **Game Count vs. Average Reviews by Year**

---

## Key Insights

* Certain tags like "Action" and "Adventure" dominate highly rated games.
* Price has a weak or mixed correlation with popularity.
* Games released post-2020 show increased review counts, but older titles still hold strong.
* A few publishers and developers consistently release well-rated games.

---

## How To Get Stuff Working

1. Clone the repo
2. Open the R project in RStudio
3. Run the main analysis script ('steamAnalysisCode.R')

---

## Future Work

* Machine learning models for predicting success could be made

---

## Author

Created by [Ahmad Azeez](https://github.com/AhmadAzeez999)
