# Weekly Capstone Progress Report
**Project:** JetBlue Operational Performance & Strategic Risk Analytics

## Work Completed This Week

This week, I refined my capstone project from the original Disney film performance analysis to a JetBlue-focused operational analytics project. The objective is to investigate where operational risks are concentrated, identify factors associated with flight disruptions, and determine where management could prioritize resources to improve operational reliability.

I established the project's primary business questions, focusing on JetBlue's operational performance over time, differences in delays and cancellations across airports and routes, factors associated with flight disruptions, and the potential use of predictive analytics to identify higher-risk flights and operational areas.

I reviewed the Bureau of Transportation Statistics (BTS) aviation databases and identified relevant data fields for the project. The primary dataset will be the Reporting Carrier On-Time Performance dataset, which includes flight-level information such as scheduled and actual departure and arrival times, delays, cancellations, routes, and flight distance. I also reviewed the T-100 Domestic Segment dataset as a potential supplemental source for flight volume, passenger, and capacity information.

## Technology Stack and Analytical Approach

I developed a proposed technology stack to support the project from data preparation through business recommendations. Python will be used for data ingestion, cleaning, exploratory data analysis, feature engineering, and machine learning. Snowflake will serve as the cloud data platform, while dbt will manage SQL transformations, data modeling, testing, and documentation. GitHub will support version control and project documentation.

The planned machine-learning component will estimate the likelihood of significant flight disruption using information available before a flight operates. These predictions will be combined with historical operational performance and flight volume to help prioritize airports and routes for further investigation.

Excel will be used for scenario analysis to evaluate potential operational improvements under different assumptions, while Power BI will serve as the final presentation layer for communicating performance trends, risk concentrations, model findings, and strategic recommendations.

I also evaluated the potential use of Monte Carlo simulation. The current priority is to complete the core data pipeline, exploratory analysis, predictive modeling, and operational risk prioritization before deciding whether simulation would add meaningful value.

## Next Steps

The next step is to begin Python-based exploratory data analysis using the reviewed BTS data. This will involve inspecting the dataset's structure, assessing data quality and completeness, examining delay and cancellation patterns, and identifying trends across airports, routes, and time periods.

The findings will help refine the project's business questions, establish a defensible operational risk methodology, and determine which variables are suitable for predictive modeling. After the initial analysis, I will continue developing the Snowflake and dbt architecture and document the data sources, assumptions, and analytical methods used throughout the project.

The immediate objective is to establish a reliable understanding of the data before proceeding to machine learning, scenario analysis, and the final Power BI dashboard.
