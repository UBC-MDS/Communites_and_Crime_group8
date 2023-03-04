## Reflection

- <b> Q - What have we implemented in our dashboard? </b>
Our dashboard allows the user to view the crime rate in each state in a Leaflet map. We also created clusters where counties in a state were too closer to each other or were overlapping. Our dashboard also allows us to view the scatter plot with a linear regression line between violent crime rate and select factors (that have enough data and less missing values) in the dataset per state. The user can choose the state and the desired factor to be plotted against violent crime using two dropdown menus. Lastly, our dashboard allows the user to view the correlation between the desired factors and violent crime rate per state to help determine if more factors are associated with a high crime rate in some states more than the others.

- <b> Q - What has not been implemented in our dashboard? </b>

We are testing 3D functionality fot the main map including a rising section and state summaries. We had to ditch the time series line plot for a correlation plot due to lack of specific information (there is not enough time series data). We also want to implement more aesthetic changes such as the addition of a logo and a standard resolution.



- <b> Q - What are the limitations of our dashboard? </b>
The data is limited to the year 1994 with a datapoint per community (cities, villages, boroughs, etc.) which means there is a limit on historical analysis. We also are limited to violent crimes and do not have a selection of multiple crime types.



- <b> Q - What are good future improvements and additions to our dashboard? </b>
A possible addition is to add some of the other variables in our map. For example, coloring the state by population so a higher population would have a darker red background for the state whereas a lower population would have a light red color, etc... Another addition is to add an extra plot that is not related to correlation, such as a bar chart of one 2-4 variables per state. 
