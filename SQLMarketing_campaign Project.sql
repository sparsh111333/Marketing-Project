--select * from marketing_Project

--Which marketing channel generated the highest revenue?
/*select 
channel,
sum(Revenue_USD) as total_Revenue
from marketing_project
group by Channel
order by total_Revenue desc*/

--Which channel has the highest average ROAS?
/*select 
Channel,
Avg(ROAS) as Avg_Roas
from marketing_Project
group by Channel
order by Avg_Roas desc*/

--Which campaign generated the highest revenue?
/*select 
Campaign_Name,
Sum(Revenue_USD) as Total_Revenue
from marketing_Project
group by Campaign_Name
order by Total_Revenue desc*/

--Which region contributes the most revenue?
/*select 
Region,
Sum(Revenue_USD) as Total_Revenue
from marketing_Project
group by Region
order by Total_Revenue desc*/

--Which channel has the lowest CPA?
/*select
Channel,
sum(CPA) as SUM_CPA
from marketing_project
group by Channel
order by SUM_CPA*/

--What are the top 3 campaigns by ROAS?
/*Select Top 3
Campaign_Name,
Avg(ROAS) as AVg_ROAS
from marketing_project
group by CAmpaign_Name
order by AVg_ROAS desc*/

--Which campaigns have above-average conversion rates?
/*select
Campaign_Name,
Conversions 
from marketing_project
where Conversions>(select avg(conversions) from Marketing_project)*/


--How has revenue changed month-over-month?
/*with monthly_revenue as (select
Month(Date) as months,
Sum(revenue_USD) as revenue
from marketing_project
Group  by Month(Date))
select 
months,
revenue,
LAG(revenue) over(order by months) as previous_month_revneue,
round(100*(Revenue-LAG(revenue) over(order by months))/LAG(revenue) over(order by months),2)revenue_change
from monthly_revenue
order by months*/


--How has marketing spend changed month-over-month?
/*with monthly_spend as (select
Month(Date) as months,
Sum(Spend_USD) as spend
from marketing_project
Group  by Month(Date))
select 
months,
spend,
LAG(spend) over(order by months) as previous_month_revneue,
round(100*(spend-LAG(spend) over(order by months))/LAG(spend) over(order by months),2)spend_change
from monthly_spend
order by months*/

--Which channel generates the highest average CTR?
/*select top 1
Channel,
avg(CTR) as Avg_ctr
from marketing_project
group by channel 
order by Avg_ctr desc*/

--Which channel generates the highest revenue per dollar spent?
/*select Top 1
Channel,
Avg(ROAS) as avg_Revenue_per_dollar
from marketing_project
group by channel 
order by avg_Revenue_per_dollar desc*/

--Which region has the highest average conversion rate?
/*select 
Region,
avg(conversion_rate) as avg_conv_rate
from marketing_project
group by region
order by avg_conv_rate desc*/

--Which campaigns are underperforming with a ROAS below 1?
/*select
campaign_name,
ROAS
from marketing_Project
where ROAS<1
order by ROAS */

--What is the best-performing campaign within each marketing channel?

/*WITH ranked_campaigns AS (
    SELECT
        Channel,
        Campaign_Name,
        ROAS,
        ROW_NUMBER() OVER (
            PARTITION BY Channel
            ORDER BY ROAS DESC
        ) AS rn
    FROM marketing_Project
)
SELECT
    Channel,
    Campaign_Name,
    ROAS
FROM ranked_campaigns
WHERE rn = 1;*/


--How do different campaign types compare in terms of profitability (ROAS, Revenue, and Spend)?
/*select
Campaign_Name,
AVg(ROAS) Avg_ROAS,
sum(Revenue_USD) Total_Revneue,
sum(Spend_USD) Total_Spend
from marketing_Project
group by campaign_Name*/



--ADVANCED QUESTIONS
--select * from marketing_Project

--Which marketing channel has the most consistent ROAS over time?
/*WITH monthly_roas AS (
    SELECT
        Channel,
        MOnth(Date) AS Months,
        AVG(ROAS) AS Monthly_ROAS
    FROM marketing_Project
    GROUP BY Channel,Date
)

SELECT
    Channel,
    AVG(Monthly_ROAS) AS Avg_ROAS,
    STDEV(Monthly_ROAS) AS ROAS_Volatility
FROM monthly_roas
GROUP BY Channel
ORDER BY ROAS_Volatility ASC;*/

--Which campaigns show a declining ROAS trend month-over-month?
/*WITH monthly_roas AS (
    SELECT
        Campaign_Name,
        YEAR(Date) AS yr,
        MONTH(Date) AS mn,
        AVG(ROAS) AS monthly_roas
    FROM marketing_Project
    GROUP BY Campaign_Name, YEAR(Date), MONTH(Date)
),
roas_trend AS (
    SELECT
        Campaign_Name,
        yr,
        mn,
        monthly_roas,
        LAG(monthly_roas) OVER (
            PARTITION BY Campaign_Name
            ORDER BY yr, mn
        ) AS previous_roas
    FROM monthly_roas
)
SELECT *
FROM roas_trend
WHERE monthly_roas < previous_roas
order by Campaign_Name,yr,mn */

--What are the top 3 revenue-generating campaigns in each region?
/*with campaign_revenue as (select
sum(Revenue_USD) total_revenue,
Campaign_Name,
Region
from marketing_project
group  by Region,Campaign_Name
)select * from(
select
*,
row_number() over(partition by region order by total_revenue) as Rnk
from campaign_revenue)t
WHERE rnk <= 3
ORDER BY Region, Total_Revenue ;*/

--Which campaigns contribute to 80% of the total revenue (Pareto Analysis)?
/*WITH campaign_revenue AS (
    SELECT
        Campaign_Name,
        SUM(Revenue_USD) AS Total_Revenue
    FROM marketing_project
    GROUP BY Campaign_Name
),
pareto AS (
    SELECT
        Campaign_Name,
        Total_Revenue,
        SUM(Total_Revenue) OVER (
            ORDER BY Total_Revenue DESC
        ) AS Running_Revenue,
        SUM(Total_Revenue) OVER () AS Overall_Revenue
    FROM campaign_revenue
)
SELECT
    Campaign_Name,
    Total_Revenue,
    Running_Revenue,
    ROUND(
        Running_Revenue * 100.0 / Overall_Revenue,
        2
    ) AS Cumulative_Percentage
FROM pareto
WHERE Running_Revenue * 100.0 / Overall_Revenue <= 80
ORDER BY Total_Revenue DESC;
*/
--Which campaigns significantly outperform their channel's average ROAS?
/*with AVg_roas_Campaign as (select 
Channel,
AVg(ROAS) as avg_ROAS
from marketing_project
group by Channel
)
select 
m.campaign_name,
m.channel,
c.avg_ROAS,
m.ROAS
from marketing_project m
join AVg_roas_Campaign c
on m.channel=c.channel
where m.Roas>c.avg_ROAS*/


