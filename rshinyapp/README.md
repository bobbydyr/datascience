# Integrated Collision Research
by Kaylei Holthe, Yuxin Cheng, Bobby Deng, Steven Bao

## Why Are We Interested
We are interested in this field/domain to better understand the effects of certain variables such as the color of cars, weather, and age of driver on things like fatality of accidents. More specifically we plan to answer the question: Do red cars really get pulled over for traffic violations more often than other color cars?


## Existing Projects in the Domain
**Project #1  
_SEA Traffic Accident Prediction_**  

This project is a student project that use publicly available and relevant data to identify predictive features and models of car accidents in Seattle, create an automatable data pipeline and build a live app reporting likelihoods.

Link: https://github.com/mnghuang/SEA_traffic_accident_prediction

**Project 2  
_Ax/Wx_**  

The project designs a tool named Ax/Wx to enhance the WSP collision database with objective observations from nearby personal weather stations.

Link: https://github.com/rexthompson/axwx


**Project #3  
_Fatal Car Crashes_**  

The project dives into the data behind signs on Illinois highways that say "957 TRAFFIC DEATHS IN 2012” and illustrates how those fatal accident happened.

Link: https://github.com/tothebeat/fatal-car-crashes


## Questions We Hope to Answer
#### 1. Does the color of car affect the chances of getting pulled over?

We can calculate the possibility or different portion of each car color and then we can have insights or distributions how the color is affecting the possibility of getting ticket.

#### 2. Of the accidents how, what proportion is fatal?

We can calculate percatage of the ones that are fatal and then compare to the total number. We can even calculate what car model or weather condition affect the fatal rate.

#### 3. What variable most affects fatality of a crash?

We can calculate each possiblity of each cause and then find the max value.

#### 4. What age range gets pulled over the most for speeding?

We can make a graph and see what age area has the greatest pullover rate.

## Our Data Source
#### Data #1
- This data was collected in Montgomery County of Maryland, it contains all electronic traffic violations issued in the country. This data is collected by the country. This data frame includes information about the day, seatbelts, fatality and color of vehicle.

- There are 1,019,492 observations and 35 features in the dataset.

- All questions from above can be answered using this dataset, except for the weather question.

- [Data source](https://www.kaggle.com/felix4guti/traffic-violations-in-usa)

#### Data #2
- Data is collected from Seattle GSI. Includes collisions in Seattle from 2004 - present. The data consists of factors involving specific collisions such as weather if bicycles were present, fatalities, and location.

- There are 208,444 observations and 40 features in the dataset.

- This dataset can be used to answer questions referring to the location of the accidents and proportion of fatalities.

- [Data source](https://data.seattle.gov/widgets/vac5-r8kk)

#### Data #3
- This is a dataset hosted by the city of Los Angeles. This dataset reflects traffic collision incidents in the City of Los Angeles dating back to 2010. This data is transcribed from original traffic reports that are typed on paper and therefore there may be some inaccuracies within the data. Some location fields with missing data are noted as (0°, 0°). Address fields are only provided to the nearest hundred block in order to maintain privacy. 

- There are 466,243 observations and 22 features in the dataset.

- How is age related to accidents?
What area has the highest accident rate? How is area related to accident rate?
Insights about sex, area, and age?

- [Data source](https://www.kaggle.com/cityofLA/los-angeles-traffic-collision-data
)
