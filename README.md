## Choropleth Map
The choropleth map shows the number of protests in different states from 1/15/2017 to 1/31/2021. You can find the original raw data here: https://countlove.org/data/data.csv

California and New York show a substantially more significant number of protests (N~2700). The number is roughly even across the midwestern US. 

<p align="center"><img src="https://raw.githubusercontent.com/michaelGRU/choropleth_map_protests/main/python_choropleth.jpeg"></p>


<details>
<summary>SQL</summary>

```sql
SELECT [State], Code, N 
FROM 
(SELECT state_abbrev, count(df.Source) N
FROM dbo.df
GROUP BY state_abbrev) as subq1,
(SELECT * FROM dbo.us_state) as subq2 
WHERE subq1.state_abbrev = subq2.Code
```
</details>



<details>
<summary>Python</summary>

```python
import pandas as pd
import numpy as np
import json 
import plotly.express as px 
import plotly.io as pio 
pio.renderers.default = 'browser'


df = pd.read_csv('data/filtered_countlove_df.csv')
us = json.load(open('us_state.json', 'r'))
id_map = {}
for feature in us['features']:
    feature['id'] = feature['properties']['STATE']
    id_map[feature['properties']['NAME']] = feature['id']

df['id'] = df['full'].apply(lambda x:id_map[x])
df['N(log10)'] = np.log10(df['N'])


fig = px.choropleth_mapbox(df, locations='id', geojson=us, 
                    color='N(log10)', center={'lat':43, 'lon':-101},
                    hover_name='full', hover_data='N',
                    mapbox_style='carto-positron', opacity=0.6, zoom=3)
fig.show()

```
</details>


<details>
<summary>R</summary>

```r
library(dplyr)
data <- read.csv('data/count_love.csv', stringsAsFactors = FALSE)
data$state_abbrev <- toupper(stringr::str_sub(data$Location, start = -2))
# a data frame of US states 
us_state <- read.csv('data/us_state.csv', stringsAsFactors = FALSE)
df <- data %>% 
  group_by(state_abbrev) %>% 
  summarise(N = n()) %>% 
  inner_join(us_state, by = c("state_abbrev" = "Code")) %>% 
  select(-Abbrev) %>% 
  arrange(desc(N))
colnames(df) <- c("abbv", "N", "full")
write.csv(df, 'data/filtered_countlove_df.csv', row.names = FALSE)
```
</details>




