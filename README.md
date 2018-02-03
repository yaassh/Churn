# Churn
## Authors: Yaassh Rao, Tanay Karmarkar, Vamsi Krishna Vandana

# Detailed Analysis of Customer Churn in TELCO

In this project, we have explored the rate of loss of customers (also known as churn rate) of a telecommunications corporation, TELCO. The data can be acquired from the following link:

Link : https://www.ibm.com/communities/analytics/watson-analytics-blog/predictive-insights-in-the-telco-customer-churn-data-set/

This data set provides info to help you predict behavior to retain customers. You can analyze all relevant customer data and develop focused customer retention programs.

A telecommunications company is concerned about the number of customers leaving their landline business for cable competitors. They need to understand who is leaving. Imagine that you’re an analyst at this company and you have to find out who is leaving and why.

The data set includes information about:

1] Customers who left within the last month – the column is called Churn.

2] Services that each customer has signed up for – phone, multiple lines, internet, online security, online backup, device protection, tech support, and streaming TV and movies.

3] Customer account information – how long they’ve been a customer, contract, payment method, paperless billing, monthly charges, and total charges.

4]Demographic info about customers – gender, age range, and if they have partners and dependents.

## Using exploratory analysis on the information provided, we have cleared a few outstanding questions, before moving ahead.

Firstly, we look at key drivers which influence customers to switch to another telecom provider.
Using decision trees and word clouds, we determine that "Contract", "Internet Service", "Tenure" and "Total Charges" are the most important factors.
The aforementioned visualizations are represented in the visualizations folder and have been created using Tableau and R.

Next, we look at which customers are most likely to leave? 
Let’s get some more details on who is leaving so we can predict who is likely to leave in the future. The Top Decision Rules are specific and detailed, and are sorted by accuracy.

Upon analyzing these Top Decision Rules, we can conclude that customers who leave tend to be ones who are on a month-to-month contract, have fiber optic internet service, and have been customers for shorter periods.

Thus, we can now predict which customers are at risk to churn. Using the decision rules to identify customers who fit the churn profile, we can proactively offer them an incentive to stay.
