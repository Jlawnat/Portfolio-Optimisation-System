source("R/config.R")
source("R/functions.R")
dir.create("data/raw",
           recursive = TRUE,
           showWarnings = FALSE)
assets <- c(
  "SPY",
  "QQQ",
  "IWM",
  "EFA",
  "EEM",
  "VNQ",
  "TLT",
  "GLD",
  "DBC"
)
price_list <- list()

for(symbol in assets){
  
  cat("Downloading", symbol, "...\n")
  
  data <- getSymbols(
    Symbols = symbol,
    src = "yahoo",
    from = "2015-01-01",
    auto.assign = FALSE
  )
  
  df <- data.frame(
    date = index(data),
    coredata(data)
  )
  
  colnames(df) <- c(
    "date",
    "open",
    "high",
    "low",
    "close",
    "volume",
    "adjusted"
  )
  
  df$symbol <- symbol
  
  price_list[[symbol]] <- df
}
prices <- bind_rows(price_list)

prices <- prices %>%
  select(
    symbol,
    date,
    open,
    high,
    low,
    close,
    volume,
    adjusted
  )
glimpse(prices)

head(prices)
write_csv(
  prices,
  "data/raw/raw_prices.csv"
)

cat("\n")
cat("=====================================\n")
cat("Data downloaded successfully.\n")
cat("Rows:", nrow(prices), "\n")
cat("Assets:", length(unique(prices$symbol)), "\n")
cat("=====================================\n")


























