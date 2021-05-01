# %%
import pandas as pd
import numpy as np
import json 
import plotly.express as px 
import plotly.io as pio 
pio.renderers.default = 'browser'


df = pd.read_csv('data/filtered_countlove_df.csv')
us = json.load(open('us_state.json', 'r'))
#us['features'][0].keys()
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

#