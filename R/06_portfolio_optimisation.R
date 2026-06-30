source("R/config.R")
source("R/functions.R")

library(quadprog)
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
equal_weights <- rep(1 / n, n)

equal_return <- sum(equal_weights * mu) * 252

equal_vol <- sqrt(
  t(equal_weights) %*%
    Sigma %*%
    equal_weights
) * sqrt(252)

equal_sharpe <- equal_return / equal_vol

Dmat <- 2 * Sigma

dvec <- rep(0, n)

Amat <- cbind(
  rep(1, n),
  diag(n)
)

bvec <- c(1, rep(0, n))

minvar <- solve.QP(
  Dmat,
  dvec,
  Amat,
  bvec,
  meq = 1
)

min_weights <- minvar$solution
min_return <- sum(min_weights * mu) * 252

min_vol <- sqrt(
  t(min_weights) %*%
    Sigma %*%
    min_weights
) * sqrt(252)

min_sharpe <- min_return / min_vol
raw_weights <- solve(Sigma) %*% mu

max_weights <- raw_weights / sum(raw_weights)

max_return <- sum(max_weights * mu) * 252

max_vol <- sqrt(
  t(max_weights) %*%
    Sigma %*%
    max_weights
) * sqrt(252)

max_sharpe <- max_return / max_vol
weights <- tibble(
  
  Asset = colnames(R),
  
  Equal = equal_weights,
  
  MinimumVariance = min_weights,
  
  MaximumSharpe = as.vector(max_weights)
  
)

print(weights)
performance <- tibble(
  
  Portfolio = c(
    "Equal Weight",
    "Minimum Variance",
    "Maximum Sharpe"
  ),
  
  Annual_Return = c(
    equal_return,
    min_return,
    max_return
  ),
  
  Annual_Volatility = c(
    equal_vol,
    min_vol,
    max_vol
  ),
  
  Sharpe = c(
    equal_sharpe,
    min_sharpe,
    max_sharpe
  )
  
) %>%
  mutate(
    across(where(is.numeric), round, 4)
  )

print(performance)
write_csv(
  weights,
  "outputs/tables/portfolio_weights.csv"
)

write_csv(
  performance,
  "outputs/tables/portfolio_performance.csv"
)
cat("Portfolio optimisation completed successfully.\n")









