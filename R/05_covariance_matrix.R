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
return_data <- return_matrix %>%
  select(-date)

cov_matrix <- cov(
  return_data,
  use = "complete.obs"
)
cor_matrix <- cor(
  return_data,
  use = "complete.obs"
)
print(cov_matrix)

print(cor_matrix)
write_csv(
  as.data.frame(cov_matrix),
  "outputs/tables/covariance_matrix.csv"
)

write_csv(
  as.data.frame(cor_matrix),
  "outputs/tables/correlation_matrix.csv"
)
eigen_result <- eigen(cov_matrix)

eigenvalues <- tibble(
  
  Eigenvalue = eigen_result$values
  
)

print(eigenvalues)
write_csv(
  eigenvalues,
  "outputs/tables/eigenvalues.csv"
)
if(all(eigen_result$values > 0)){
  
  cat("Covariance matrix is Positive Definite.\n")
  
}else{
  
  cat("Covariance matrix is NOT Positive Definite.\n")
  
}



png(
  "figures/correlation_heatmap.png",
  width = 900,
  height = 900
)

corrplot(
  cor_matrix,
  method = "color",
  type = "upper",
  tl.cex = 0.9,
  addCoef.col = "black",
  number.cex = 0.7
)

dev.off()

png(
  "figures/covariance_heatmap.png",
  width = 900,
  height = 900
)

corrplot(
  cov_matrix,
  method = "color",
  is.corr = FALSE,
  tl.cex = 0.9
)

dev.off()


cat("\n")
cat("=====================================\n")
cat("Covariance analysis completed.\n")
cat("=====================================\n")





