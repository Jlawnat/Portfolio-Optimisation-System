library(tidyverse)
library(quantmod)
library(PerformanceAnalytics)
library(xts)
library(zoo)
library(corrplot)
library(scales)
folders <- c(
  "data/raw",
  "data/processed",
  "figures",
  "outputs",
  "outputs/tables",
  "outputs/models"
)

invisible(
  lapply(
    folders,
    function(x) dir.create(
      x,
      recursive = TRUE,
      showWarnings = FALSE
    )
  )
)
options(
  stringsAsFactors = FALSE,
  scipen = 999
)

theme_set(theme_minimal())