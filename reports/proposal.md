\#

<div align="center">

Proposal

<div align="center">

# Motivation and purpose

<b> Our Role: </b> We are data scientists working with the FBI in Quantico in 1996\
<b> Target Audience: </b> Chief Criminal Analysts at the FBI

Understanding where, how and why crime happens is important for fighting and lowering crime rates, hence increasing safety in communities. Since 1930, the FBI has been collecting data on the types, amounts, and impact of crime in the United States through the Uniform Crime Reporting Program. So, our dashboard will aim to figure out the socioeconomic conditions, sociodemographic and community factors influencing crime rate in different US counties as well as provide access to crime data in an understandable and intuitive manner. Data must be easy to slice and the insights have to be able to be backed up by the actual data.

# Research Questions and Usage Scenario

## Research Questions

The crime rate in a community is an important factor that citizens consider when making decisions about whether to live or invest. A high crime rate in a city may impact personal safety, property values, and overall quality of life. The crime rate can be influenced by many factors, and our dataset potentially captures some of them to answer the following research questions:

-   Which state was the most crime-ridden in the USA in 1995?

-   What factors are most statistically associated with the crime rate of an area?

-   Is the number of police officers per population statistically correlated with the crime rate of a community? If so, is it a positive or negative correlation?

## Usage scenario

Laura is a criminology student who has been hired by the government to perform an analysis on the contributing factors of crime rates in a city. She has been given a dataset with over 100 columns and wants to explore it in order to find meaningful associations between crime rates and other possible features in the dataset. With a background in criminology, Laura has prior knowledge of which factors might be correlated with crime rates; however, she wants to visually present the relationships between available columns in the dataset if her boss is interested. Furthermore, she wants to visualize the crime rate using an interactive map representation, which would be intuitive for others to understand the overall idea of the crime that has happened in the US.

Laura then installs the "Communities and Crime" app. She sees a map of the US with the implemented crime rate. This first page gives her the distribution of crime in the US according to her dataset. The map can be further zoomed in, given a city query, and a local display of crime rates will be presented. On the second page, she is able to view the demographic decomposition of a community, as well as a graphical representation of the relationship between crime rates and other features. The features can be selected on the left panel in the search bar to discover the desired feature that might be statistically associated with crime rates. She hypothesize that the amount of the police force is has is statistically significant and would like to utilize the app for her next report meeting.

# Description of the data

We will be visualizing the Communities within the United States dataset which combines socio-economic data from the 1990 US Census, law enforcement data from the 1990 US LEMAS survey, and crime data from the 1995 FBI UCR and has approximately 1,994 instances with 128 attributes, some of which are the percent of the population considered urban, median family income, and involving law enforcement, per capita number of police officers and percent of officers assigned to drug units. The variables that we will be using are -- community name (`communityname`), population density in persons per square mile (`PopDens`), percentage of population that is African American (`racepctblack`), percentage of population that is Caucasian (`racePctWhite`), percentage of population that is of Asian heritage (`racePctAsian`), percentage of population that is of Hispanic heritage (`racePctHisp`), percentage of population that is 12-29 in age (`agePct12t29`), percentage of population that is 65 and over in age (`agePct65up`), median household income (`medIncome`), number of homeless people counted on the street as opposed to administrative (`NumStreet`), percentage of people 16 and over, in the labor force, and unemployed (`PctUnemployed`), number of sworn full time police officers (`LemasSwornFT`), number of sworn full time police officers in field operations (`LemasSwFTFieldOps`), percent of sworn full time police officers on patrol (`LemasPctPolicOnPatr`), total requests for police `LemasTotalReq`, number of police cars (`PolicCars`), police operating budget (`PolicOperBudg`), number of different kinds of drugs seized (`NumKindsDrugsSeiz`) and, finally, the total number of violent crimes per 100K population (`ViolentCrimesPerPop`)

```python

```
