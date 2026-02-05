 use insurance;
 
 show tables;
 
 Select * from individual_budgets;
 
 #No of invoices by account executive
 SELECT 
    `Account Executive`,
    COUNT(invoice_number) AS no_of_invoices
FROM invoice
GROUP BY `Account Executive`
ORDER BY no_of_invoices DESC;
 
 
 #Yearly meeting count
SELECT 
    COUNT(*) AS total_meetings
FROM meeting;


#Meeting by account executive
SELECT
	'Account_Executive',
    COUNT(*) AS meeting_count
FROM meeting
GROUP BY account_executive
ORDER BY meeting_count DESC;


#Achieved Revenue by Type
SELECT revenue_transaction_type,
	   SUM(amount) AS achieved_revenue
FROM brokerage
GROUP BY revenue_transaction_type;

#
SELECT revenue_transaction_type,
	   SUM(amount) AS achieved_revenue
FROM fees
GROUP BY revenue_transaction_type;

#Stage funnel by revenue
SELECT 
    stage,
    SUM(revenue_amount) AS total_revenue
FROM opportunity
GROUP BY stage
ORDER BY total_revenue DESC;

#Top open oppurtunities
SELECT 
    opportunity_name,
    `Account Executive`,
    revenue_amount,
    stage
FROM opportunity
WHERE stage IN ('Propose Solution', 'Qualify Opportunity')
ORDER BY revenue_amount DESC;

#Open oppurtunity (Drill Down)
SELECT 
    opportunity_name,
    `Account Executive`,
    revenue_amount,
    stage
FROM opportunity
WHERE stage IN ('Propose Solution', 'Qualify Opportunity')
ORDER BY revenue_amount DESC
LIMIT 10;



SELECT income_type, SUM(placed_achievement) AS total_placed
FROM (
    SELECT income_class AS income_type, amount AS placed_achievement FROM brokerage
    UNION ALL
    SELECT income_class AS income_type, amount AS placed_achievement FROM fees
) t
GROUP BY income_type;




