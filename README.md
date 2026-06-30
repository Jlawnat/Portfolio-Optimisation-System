# 📈 Portfolio Optimisation and Risk Analytics System

A fully reproducible quantitative finance project that applies **Modern Portfolio Theory (MPT)** to construct, optimise, and evaluate diversified ETF portfolios using R.

The project implements an end-to-end investment analytics workflow, from downloading historical market data to portfolio optimisation, backtesting, Monte Carlo simulation, and automated report generation with Quarto.

---

## Overview

This project demonstrates a complete quantitative investment analysis workflow designed to support portfolio construction and performance evaluation.

Using historical ETF price data from Yahoo Finance, the system automatically:

- Downloads and preprocesses market data
- Calculates daily log returns
- Performs exploratory data analysis
- Computes portfolio risk and performance metrics
- Estimates covariance and correlation structures
- Optimises portfolio allocations
- Constructs the Efficient Frontier
- Backtests historical portfolio performance
- Simulates future portfolio outcomes using Monte Carlo methods
- Produces a fully reproducible Quarto report

The project follows reproducible research principles, allowing anyone to regenerate every figure, table, and result directly from the source code.

---

## Project Workflow

```text
Download Market Data
        │
        ▼
Prepare Return Data
        │
        ▼
Exploratory Data Analysis
        │
        ▼
Risk & Performance Analysis
        │
        ▼
Covariance & Correlation Analysis
        │
        ▼
Portfolio Optimisation
        │
        ▼
Efficient Frontier
        │
        ▼
Historical Backtesting
        │
        ▼
Monte Carlo Simulation
        │
        ▼
Automated Quarto Report
```

---

## ETFs Included

| Investment Style | ETF |
|------------------|-----|
| Large Cap Growth | SCHG |
| Large Cap Blend | SCHX |
| Large Cap Value | SCHV |
| Mid Cap Growth | SCHM |
| Mid Cap Blend | VO |
| Mid Cap Value | IWS |
| Small Cap Growth | VBK |
| Small Cap Blend | VB |
| Small Cap Value | VBR |

These ETFs provide diversified exposure across market capitalisations and investment styles, making them suitable for portfolio optimisation and diversification analysis.

---

## Project Structure

```text
Portfolio-Optimisation-System/
│
├── R/
│   ├── 01_download_data.R
│   ├── 02_prepare_returns.R
│   ├── 03_exploratory_analysis.R
│   ├── 04_risk_return.R
│   ├── 05_covariance_matrix.R
│   ├── 06_portfolio_optimisation.R
│   ├── 07_efficient_frontier.R
│   └── 08_backtesting.R
│
├── data/
│   ├── raw/
│   └── processed/
│
├── outputs/
│   ├── figures/
│   ├── tables/
│   └── models/
│
├── report/
│   └── portfolio_report.qmd
│
├── README.md
├── renv.lock
├── .gitignore
└── LICENSE
```

---

## Portfolio Analytics

The project evaluates portfolios using widely adopted risk and performance measures.

### Return Measures

- Daily Log Returns
- Annualised Return
- Cumulative Return

### Risk Measures

- Annualised Volatility
- Sharpe Ratio
- Sortino Ratio
- Maximum Drawdown

### Portfolio Analytics

- Covariance Matrix
- Correlation Matrix
- Eigenvalue Analysis
- Portfolio Diversification

---

## Portfolio Optimisation

Three portfolio construction strategies are implemented and compared.

| Portfolio | Objective |
|-----------|-----------|
| Equal Weight Portfolio | Equal allocation across all ETFs |
| Minimum Variance Portfolio | Minimise portfolio volatility |
| Maximum Sharpe Portfolio | Maximise risk-adjusted return |

Each portfolio is evaluated using both historical performance and risk-adjusted metrics.

---

## Technologies

This project is developed entirely in **R** using the following packages:

- tidyverse
- tidyquant
- quantmod
- PerformanceAnalytics
- PortfolioAnalytics
- quadprog
- ggplot2
- xts
- Quarto

---

## Reproducing the Project

Clone the repository:

```bash
git clone https://github.com/your-username/Portfolio-Optimisation-System.git
```

Restore the project environment:

```r
renv::restore()
```

Run the analysis scripts in sequence:

```r
source("R/01_download_data.R")
source("R/02_prepare_returns.R")
source("R/03_exploratory_analysis.R")
source("R/04_risk_return.R")
source("R/05_covariance_matrix.R")
source("R/06_portfolio_optimisation.R")
source("R/07_efficient_frontier.R")
source("R/08_backtesting.R")
```

Render the Quarto report:

```r
quarto::quarto_render("report/portfolio_report.qmd")
```

All figures, tables, and performance metrics are generated automatically.

---

## Future Enhancements

Potential extensions include:

- Portfolio rebalancing strategies
- Transaction cost modelling
- Black–Litterman optimisation
- Conditional Value at Risk (CVaR) optimisation
- Stress testing under market scenarios
- Multi-period portfolio optimisation
- Factor-based investing
- Interactive portfolio dashboard using Shiny

---

## Author

**Elliot Yang**

---