annual_return <- function(x) {
  mean(x, na.rm = TRUE) * 252
}

annual_volatility <- function(x) {
  sd(x, na.rm = TRUE) * sqrt(252)
}

daily_volatility <- function(x) {
  sd(x, na.rm = TRUE)
}

daily_return <- function(x) {
  mean(x, na.rm = TRUE)
}

max_drawdown_value <- function(x) {
  as.numeric(maxDrawdown(x))
}

sortino_ratio_value <- function(x) {
  as.numeric(SortinoRatio(x))
}

sharpe_ratio_value <- function(x) {
  as.numeric(
    SharpeRatio(
      x,
      FUN = "StdDev",
      annualize = TRUE
    )
  )
}