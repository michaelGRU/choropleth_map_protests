
SELECT [State], Code, N FROM 
(SELECT state_abbrev, count(df.Source) N
FROM dbo.df
GROUP BY state_abbrev) as subq1,
(SELECT * FROM dbo.us_state) as subq2 
WHERE subq1.state_abbrev = subq2.Code


