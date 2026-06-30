source("R/config.R")
source("R/functions.R")
returns <- read_csv(
  "data/processed/log_returns.csv",
  show_col_types = FALSE
)

weights <- read_csv(
  "outputs/tables/portfolio_weights.csv",
  show_col_types = FALSE
)
return_matrix <- returns %>%
  select(date, symbol, log_return) %>%
  pivot_wider(
    names_from = symbol,
    values_from = log_return
  )

dates <- return_matrix$date

R <- as.matrix(return_matrix %>% select(-date))
equal_weights <- weights$Equal
min_weights <- weights$MinimumVariance
max_weights <- weights$MaximumSharpe
equal_returns <- R %*% equal_weights

min_returns <- R %*% min_weights

max_returns <- R %*% max_weights
equal_returns <- xts(
  as.vector(equal_returns),
  order.by = dates
)

min_returns <- xts(
  as.vector(min_returns),
  order.by = dates
)

max_returns <- xts(
  as.vector(max_returns),
  order.by = dates
)

wealth <- tibble(
  date = dates,
  Equal = cumprod(1 + as.vector(equal_returns)),
  MinimumVariance = cumprod(1 + as.vector(min_returns)),
  MaximumSharpe = cumprod(1 + as.vector(max_returns))
)
wealth_long <- wealth %>%
  pivot_longer(
    -date,
    names_to = "Portfolio",
    values_to = "Wealth"
  )

wealth_plot <-
  
  ggplot(
    wealth_long,
    aes(date,
        Wealth,
        colour = Portfolio)
  ) +
  
  geom_line(linewidth = 1) +
  
  labs(
    title = "Backtesting Portfolio Performance",
    x = "",
    y = "Growth of $1"
  )

wealth_plot

ggsave(
  "figures/cumulative_wealth.png",
  wealth_plot,
  width = 10,
  height = 6,
  dpi = 300
)

performance <- tibble(
  
  Portfolio = c(
    "Equal Weight",
    "Minimum Variance",
    "Maximum Sharpe"
  ),
  
  Annual_Return = c(
    annual_return(equal_returns),
    annual_return(min_returns),
    annual_return(max_returns)
  ),
  
  Annual_Volatility = c(
    annual_volatility(equal_returns),
    annual_volatility(min_returns),
    annual_volatility(max_returns)
  ),
  
  Sharpe = c(
    sharpe_ratio_value(equal_returns),
    sharpe_ratio_value(min_returns),
    sharpe_ratio_value(max_returns)
  ),
  
  Max_Drawdown = c(
    max_drawdown_value(equal_returns),
    max_drawdown_value(min_returns),
    max_drawdown_value(max_returns)
  )
)

write_csv(
  performance,
  "outputs/tables/backtest_performance.csv"
)


cat("Backtesting completed successfully.\n")




