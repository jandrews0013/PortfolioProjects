--Change Date column from datetime to date datatype since the time for each observation isn't relevant to analysis
ALTER TABLE PortfolioProject..Border_Crossing_Entry_Data
	ALTER COLUMN Date date

GO

--Quick overview of the table's columns and fields
SELECT TOP(50) *

FROM PortfolioProject..Border_Crossing_Entry_Data

ORDER BY Date DESC
GO

--Which states had the greatest number of border crossings 
--over a period of time (ie 5 years)? Greatest number of passengers?

SELECT State, SUM(Value) AS 'Total Non-Passenger Crossings'

FROM PortfolioProject..Border_Crossing_Entry_Data
WHERE (Measure = 'Personal Vehicles' OR Measure = 'Trucks' OR Measure = 'Pedestrians' OR 
	   Measure = 'Buses' OR Measure = 'Trains')
	   AND (DATEPART(YEAR, Date) > 2000 AND DATEPART(YEAR, Date) < 2006)
GROUP BY State
ORDER BY [Total Non-Passenger Crossings] DESC

GO

--Comment going over results of previous query

SELECT State, SUM(Value) AS 'Total of Crossings with Passengers'

FROM PortfolioProject..Border_Crossing_Entry_Data
WHERE (Measure = 'Train Passengers' OR Measure = 'Personal Vehicle Passengers' OR Measure = 'Bus Passengers' )
	   AND (DATEPART(YEAR, Date) > 2000 AND DATEPART(YEAR, Date) < 2006)
GROUP BY State
ORDER BY [Total of Crossings with Passengers] DESC

GO

--COmment going over results of previous query

--Which border (Canadian or Mexican) had the largest number of crossings?

SELECT DISTINCT(Measure)
FROM PortfolioProject..Border_Crossing_Entry_Data
GO

SELECT Border, DATEPART(YEAR, Date) AS 'Date', SUM(Value) AS 'Total Number of Crossings'
FROM PortfolioProject..Border_Crossing_Entry_Data
WHERE 
	(
	Measure = 'Personal Vehicles' OR 
	Measure = 'Trucks' OR
	Measure = 'Pedestrians' OR
	Measure = 'Buses' OR
	Measure = 'Trains'
	) 
GROUP BY DATEPART(YEAR, Date), Border
ORDER BY Date ASC, Border ASC	-- Border ASC, Date ASC shows trend over time for each border separately
GO

--The above query gives a year by year comparison of the total number of crossings between the US-Canada Border vs. the US-Mexico Border.
--As the data shows, the US-Mexico Border is substantially more busy than the US-Canada Border in terms of incoming traffic.
--For total instances of crossings between the two borders from January,1996 to February,2022, the following query will show the difference.

SELECT Border, SUM(Value) AS 'Total Number of Crossings'
FROM PortfolioProject..Border_Crossing_Entry_Data
WHERE (Measure = 'Personal Vehicles' OR Measure = 'Trucks' OR Measure = 'Pedestrians' OR 
	   Measure = 'Buses' OR Measure = 'Trains')
	--AND
	--DATEPART(YEAR, Date) = '2015'

GROUP BY Border

ORDER BY Border ASC
GO

--In total, the US-Mexico Border has had 3,262,554,707 instances of crossings versus 944,799,101 instances for the US-Canada Border.
;

--Which months are the most popular time for crossings? 
--Which months were least popular? 
--Are these answers the same for both borders?
;

SELECT Border, 
	   DATEPART(YEAR, Date) AS 'Year',
	   DATEPART(MONTH, Date) AS 'Month',
	   --DATEPART(MONTH, Date) AS 'Month', 
	   SUM(Value) AS 'Total Number of Crossings'

FROM PortfolioProject..Border_Crossing_Entry_Data
WHERE (Measure = 'Personal Vehicles' OR Measure = 'Trucks' OR Measure = 'Pedestrians' OR 
	   Measure = 'Buses' OR Measure = 'Trains')
	   --AND DATEPART(YEAR, Date) = '2012'
	   
GROUP BY Border, DATEPART(YEAR, Date), DATEPART(MONTH, Date)--DATEPART(MONTH, Date)
ORDER BY Border ASC, [Total Number of Crossings] DESC
GO

--Which port was the busiest port within a given year? 
--How many instances of crossings not counting passengers? 
--What about least busiest?


SELECT [Port Code], SUM(Value) AS 'Total Number of Crossings'
FROM PortfolioProject..Border_Crossing_Entry_Data
WHERE (Measure = 'Personal Vehicles' OR Measure = 'Trucks' OR Measure = 'Pedestrians' OR 
	   Measure = 'Buses' OR Measure = 'Trains')
	   AND DATEPART(YEAR, Date) = '2017'
GROUP BY [Port Code]
ORDER BY [Total Number of Crossings] DESC
GO

--From the query above, it appears that port 2504 was the busiest port for 2017 while port 3321 was the least busiest.
--The following query will tell us which city and state these two unique ports are located.
;
SELECT [Port Name], State, [Port Code]
FROM PortfolioProject..Border_Crossing_Entry_Data
WHERE (Measure = 'Personal Vehicles' OR Measure = 'Trucks' OR Measure = 'Pedestrians' OR 
	   Measure = 'Buses' OR Measure = 'Trains')
	   AND DATEPART(YEAR, Date) = '2017'
	   AND [Port Code] = 2504 
	   OR [Port Code] = 3321
GROUP BY [Port Name], State, [Port Code]
GO

--The busiest port in 2017 was located in San Ysidro, California and the "quietest" port was in Whitlash, Montana.
;

--Which state has the most ports for border crossings? 
--Fewest number of ports?

SELECT 
	State, 
	COUNT(DISTINCT([Port Name])) AS 'Number of Ports'

FROM PortfolioProject..Border_Crossing_Entry_Data

WHERE Date = '2022-12-21'

GROUP BY State

ORDER BY [Number of Ports] DESC
GO
--It appears that North Dakota possesses the most number of ports, while
--Idaho has the least number of ports!
;

--Practice/ Scratch

SELECT *
FROM PortfolioProject..Border_Crossing_Entry_Data
WHERE [Port Name] = 'San Ysidero'
GO

SELECT Border, Date, Measure, SUM(Value)
FROM PortfolioProject..Border_Crossing_Entry_Data
WHERE Date IN('2000-01-01', '2000-02-01', '2000-03-01', '2000-04-01', '2000-05-01', '2000-06-01',
			  '2000-07-01', '2000-08-01', '2000-09-01', '2000-10-01', '2000-11-01', '2000-12-01')
			  AND 
		     (Measure = 'Personal Vehicles' OR Measure = 'Trucks' OR Measure = 'Pedestrians' OR 
			  Measure = 'Buses' OR Measure = 'Trains') 
GROUP BY Border, Date, Measure
ORDER BY Border ASC, Date ASC
GO

SELECT DATEPART(YEAR, Date)
FROM PortfolioProject..Border_Crossing_Entry_Data