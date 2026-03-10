# Credit Risk Portfolio Dashboard – Lending Club

## Overview
This project analyzes credit risk in a consumer lending portfolio using SQL and Power BI.  
The objective is to evaluate portfolio exposure, expected credit loss, default risk, and capital adequacy using a structured analytics pipeline.

The analysis is built using SQL queries in PostgreSQL and visualized through an interactive dashboard in Power BI.

---

## Dashboard Preview

<img width="1292" height="1168" alt="image" src="https://github.com/user-attachments/assets/43fbb478-3cce-4650-bcff-54dbd1f7a14f" />


---

## Business Objective

Financial institutions need to understand:

- How large the lending portfolio is
- Where credit risk is concentrated
- How default risk evolves over time
- Whether capital reserves are sufficient to absorb expected losses

This dashboard provides a **portfolio-level risk overview** using standard credit risk metrics.

---

## Key Risk Metrics

### Probability of Default (PD)
The likelihood that a borrower will default on a loan.

### Loss Given Default (LGD)
The percentage of exposure that is lost if a borrower defaults.

### Expected Credit Loss (ECL)

Expected Loss = PD × LGD × Exposure

This metric estimates potential losses across the portfolio.

### Capital Adequacy Ratio
Measures whether the institution holds enough capital to cover potential credit losses.

---

## Key Insights

- Total portfolio exposure: **₹11.2 Billion**
- Total loans issued: **759K**
- Portfolio default rate: **4.9%**
- Expected credit loss: **₹520M**
- Lower credit grades contribute the largest share of expected losses.
- Capital ratio currently sits at **10% vs 12% target**, indicating limited capital buffer.

---

## Dashboard Features

### Portfolio Overview
High-level KPIs showing exposure, loan volume, and default rate.

### Loan Grade Distribution
Breakdown of loans by credit grade to identify risk concentration.

### Portfolio Loss Trend
Time-series view of expected losses across the portfolio.

### Expected Loss Analysis
Expected loss by credit grade to identify high-risk segments.

### Capital Adequacy Monitoring
Tracks whether capital reserves meet regulatory targets.

---

## Project Structure

```
credit-risk-lendingclub-dashboard

dashboard/
   lending_club_dashboard.pbix

sql/
   01_data_setup
   02_data_cleaning
   03_risk_model
   04_analysis
   05_reporting_views

images/
   dashboard_preview.png
```

---

## How to Run

1. Clone this repository
2. Import dataset into PostgreSQL
3. Run SQL scripts in order
4. Open Power BI dashboard (.pbix)
5. Refresh data connection
   
---

## Tools & Technologies

- PostgreSQL
- Power BI
- SQL

---

## Skills Demonstrated

- SQL data transformation and cleaning
- Credit risk analytics (PD, LGD, Expected Loss)
- Time-series risk analysis
- Portfolio risk segmentation
- Business intelligence dashboard design
- Financial data storytelling

---

## Author

**Amal S**

Aspiring Data Analyst with a focus on financial analytics and risk analysis.

---

## Future Improvements

Possible extensions of this project:

- Monte Carlo credit risk simulation
- Loan cohort analysis
- Default prediction models
- Interactive portfolio stress testing

---

## License

This project is for educational and portfolio purposes.
