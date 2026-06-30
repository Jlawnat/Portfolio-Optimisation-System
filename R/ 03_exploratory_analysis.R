library(tidyverse)
library(PerformanceAnalytics)
library(xts)
library(zoo)
library(corrplot)
library(scales)

dir.create("figures",
           recursive = TRUE,
           showWarnings = FALSE)

prices <- read_csv("data/raw/raw_prices.csv",
                   show_col_types = FALSE)

returns <- read_csv("data/processed/log_returns.csv",
                    show_col_types = FALSE)

price_plot <- ggplot(prices,
                     aes(date,
                         adjusted,
                         colour = symbol)) +
  
  geom_line(linewidth = 0.8) +
  
  labs(
    title = "Adjusted Prices",
    x = "",
    y = "Price"
  ) +
  
  theme_minimal()

price_plot

ggsave(
  "figures/price_chart.png",
  price_plot,
  width = 10,
  height = 6,
  dpi = 300
)

return_plot <- ggplot(returns,
                      aes(date,
                          log_return,
                          colour = symbol)) +
  
  geom_line(alpha = 0.7) +
  
  labs(
    title = "Daily Log Returns",
    x = "",
    y = "Log Return"
  ) +
  
  theme_minimal()

return_plot

ggsave(
  "figures/return_chart.png",
  return_plot,
  width = 10,
  height = 6,
  dpi = 300
)

hist_plot <- ggplot(
  returns,
  aes(log_return)
) +
  
  geom_histogram(
    bins = 40,
    fill = "steelblue",
    colour = "white"
  ) +
  
  facet_wrap(~symbol,
             scales = "free") +
  
  theme_minimal() +
  
  labs(
    title = "Distribution of Daily Log Returns",
    x = "Log Return",
    y = "Frequency"
  )

hist_plot

ggsave(
  "figures/histograms.png",
  hist_plot,
  width = 11,
  height = 8,
  dpi = 300
)

box_plot <- ggplot(
  returns,
  aes(symbol,
      log_return,
      fill = symbol)
) +
  
  geom_boxplot() +
  
  theme_minimal() +
  
  theme(
    legend.position = "none"
  ) +
  
  labs(
    title = "Return Distribution"
  )

box_plot

ggsave(
  "figures/boxplots.png",
  box_plot,
  width = 9,
  height = 6,
  dpi = 300
)

return_matrix <- returns %>%
  select(date,
         symbol,
         log_return) %>%
  pivot_wider(
    names_from = symbol,
    values_from = log_return
  )

cor_matrix <- return_matrix %>%
  select(-date) %>%
  cor()

png(
  "figures/correlation_heatmap.png",
  width = 900,
  height = 900
)

corrplot(
  cor_matrix,
  method = "color",
  type = "upper",
  tl.cex = 0.8
)

dev.off()


rolling_vol <- returns %>%
  group_by(symbol) %>%
  arrange(date) %>%
  mutate(
    volatility = zoo::rollapply(
      log_return,
      width = 30,
      FUN = sd,
      fill = NA,
      align = "right"
    )
  )

vol_plot <- ggplot(
  rolling_vol,
  aes(
    date,
    volatility,
    colour = symbol
  )
) +
  
  geom_line() +
  
  theme_minimal() +
  
  labs(
    title = "30-Day Rolling Volatility",
    x = "",
    y = "Volatility"
  )

vol_plot

ggsave(
  "figures/rolling_volatility.png",
  vol_plot,
  width = 10,
  height = 6,
  dpi = 300
)

cat("EDA completed successfully.\n")













