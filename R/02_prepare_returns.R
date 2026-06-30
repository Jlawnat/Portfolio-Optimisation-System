library(tidyverse)
library(tidyquant)
prices <- read_csv("data/raw/raw_prices.csv")
simple_returns <- prices %>%
  arrange(symbol, date) %>%
  group_by(symbol) %>%
  mutate(
    simple_return = adjusted / lag(adjusted) - 1
  ) %>%
  filter(!is.na(simple_return))
log_returns <- prices %>%
  arrange(symbol, date) %>%
  group_by(symbol) %>%
  mutate(
    log_return = log(adjusted / lag(adjusted))
  ) %>%
  filter(!is.na(log_return))
head(simple_returns)
head(log_returns)

dir.create("data/processed",
           recursive = TRUE,
           showWarnings = FALSE)

write_csv(
  simple_returns,
  "data/processed/simple_returns.csv"
)

write_csv(
  log_returns,
  "data/processed/log_returns.csv"
)

cat("Processed return datasets saved successfully.\n")





