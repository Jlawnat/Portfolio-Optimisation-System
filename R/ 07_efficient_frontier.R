source("R/config.R")
source("R/functions.R")
returns <- read_csv(
  "data/processed/log_returns.csv",
  show_col_types = FALSE
)

return_matrix <- returns %>%
  select(date, symbol, log_return) %>%
  pivot_wider(
    names_from = symbol,
    values_from = log_return
  )

R <- return_matrix %>%
  select(-date)

mu <- colMeans(R)

Sigma <- cov(R)

n <- ncol(R)
set.seed(123)

n_portfolios <- 10000

portfolio_results <- tibble(
  Return = numeric(n_portfolios),
  Risk = numeric(n_portfolios),
  Sharpe = numeric(n_portfolios)
)

weight_list <- vector("list", n_portfolios)
for(i in 1:n_portfolios){
  
  weights <- runif(n)
  
  weights <- weights / sum(weights)
  
  weight_list[[i]] <- weights
  
  portfolio_return <-
    sum(weights * mu) * 252
  
  portfolio_risk <-
    sqrt(t(weights) %*%
           Sigma %*%
           weights) * sqrt(252)
  
  portfolio_results$Return[i] <- portfolio_return
  
  portfolio_results$Risk[i] <- portfolio_risk
  
  portfolio_results$Sharpe[i] <-
    portfolio_return / portfolio_risk
  
}
max_sharpe_index <-
  which.max(portfolio_results$Sharpe)

max_sharpe_portfolio <-
  portfolio_results[max_sharpe_index, ]
min_var_index <-
  which.min(portfolio_results$Risk)

min_var_portfolio <-
  portfolio_results[min_var_index, ]

equal_weights <- rep(1 / n, n)

equal_return <-
  sum(equal_weights * mu) * 252

equal_risk <-
  sqrt(
    t(equal_weights) %*%
      Sigma %*%
      equal_weights
  ) * sqrt(252)

equal_portfolio <- tibble(
  Risk = equal_risk,
  Return = equal_return,
  Portfolio = "Equal Weight"
)

min_var_portfolio$Portfolio <- "Minimum Variance"

max_sharpe_portfolio$Portfolio <- "Maximum Sharpe"

frontier_plot <-
  
  ggplot(
    portfolio_results,
    aes(Risk, Return)
  ) +
  
  geom_point(
    aes(color = Sharpe),
    alpha = 0.5,
    size = 1
  ) +
  
  scale_color_viridis_c() +
  
  geom_point(
    data = max_sharpe_portfolio,
    aes(Risk, Return),
    color = "red",
    size = 4
  ) +
  
  geom_point(
    data = min_var_portfolio,
    aes(Risk, Return),
    color = "blue",
    size = 4
  ) +
  
  geom_point(
    data = equal_portfolio,
    aes(Risk, Return),
    color = "black",
    size = 4
  )+
  geom_text(
  data = equal_portfolio,
  aes(Risk, Return, label = Portfolio),
  nudge_y = 0.01,
  size = 4
  ) +
  
  geom_text(
    data = min_var_portfolio,
    aes(Risk, Return, label = Portfolio),
    nudge_y = 0.01,
    size = 4
  ) +
  
  geom_text(
    data = max_sharpe_portfolio,
    aes(Risk, Return, label = Portfolio),
    nudge_y = 0.01,
    size = 4
  )
  labs(
    title = "Efficient Frontier",
    x = "Annual Volatility",
    y = "Annual Return",
    color = "Sharpe Ratio"
  )

frontier_plot

ggsave(
  "figures/efficient_frontier.png",
  frontier_plot,
  width = 10,
  height = 7,
  dpi = 300
)

cat("Efficient frontier generated successfully.\n")










