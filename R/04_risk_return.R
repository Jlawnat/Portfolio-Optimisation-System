source("R/config.R")
source("R/functions.R")
returns <- read_csv(
  "data/processed/log_returns.csv",
  show_col_types = FALSE
)
return_wide <- returns %>%
  select(date, symbol, log_return) %>%
  pivot_wider(
    names_from = symbol,
    values_from = log_return
  )
return_xts <- xts(
  return_wide[-1],
  order.by = as.Date(return_wide$date)
)
risk_summary <- tibble(
  Asset = colnames(return_xts),
  Mean_Return = NA_real_,
  Annual_Return = NA_real_,
  Daily_Volatility = NA_real_,
  Annual_Volatility = NA_real_,
  Sharpe_Ratio = NA_real_,
  Sortino_Ratio = NA_real_,
  Max_Drawdown = NA_real_
)

for(i in seq_along(colnames(return_xts))){
  
  asset <- return_xts[, i]
  
  risk_summary$Mean_Return[i] <-
    mean(asset)
  
  risk_summary$Annual_Return[i] <-
    mean(asset) * 252
  
  risk_summary$Daily_Volatility[i] <-
    sd(asset)
  
  risk_summary$Annual_Volatility[i] <-
    sd(asset) * sqrt(252)
  
  risk_summary$Sharpe_Ratio[i] <-
    as.numeric(
      SharpeRatio(
        asset,
        FUN = "StdDev",
        annualize = TRUE
      )
    )
  
  risk_summary$Sortino_Ratio[i] <-
    as.numeric(
      SortinoRatio(asset)
    )
  
  risk_summary$Max_Drawdown[i] <-
    as.numeric(
      maxDrawdown(asset)
    )
  
}
print(risk_summary)
dir.create(
  "outputs/tables",
  recursive = TRUE,
  showWarnings = FALSE
)

write_csv(
  risk_summary,
  "outputs/tables/risk_return_summary.csv"
)
cat("Risk and return analysis completed successfully.\n")








