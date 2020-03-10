# Data Science Portfolio
## A collection of my favorite Data Science related projects in fulfillment of the Syracuse University School of Information Studies MS in Applied Data Science.

### Ryan French
### 673100962
### All files included should be viewable via:
* Microsoft Office Sweet
* Adobe Creative Suite
* Tableau
* R Studio
* Jupyter
* VS Code

# Projects

# Spotify Top 200 Daily Tracks & Features Analysis
## Utilizing Python, SQL, & Tableau

### Summary
Probably my most used app on a daily basis, my Spotify is almost always open whether it be me creating playlists to share with my friends, listening to a podcast on the way to class, or enjoying my Discover Weekly while I code. Due to its position as one of the largest streaming platforms in the world, I was interested to take a look at the daily updated Top 200 RSS Feed (which can be found at https://spotifycharts.com/regional/global/daily/) and see if I could create a database to house the data as well as a dashboard to effectively explore it.

### Dashboard
![Dashboard Image](https://github.com/ryanhfrench/spotify_dashboard/blob/master/dashboard_image.png)
[Interact with the Dashboard on Tableau Public](https://public.tableau.com/profile/ryan.french4207#!/vizhome/SpotifyTop200DailyTracksFeaturesAnalysis/SpotifyTop200DailyTracksFeaturesAnalysis)

### Files  
**data:** The folder housing the Spotify data that I collected in CSV format for each date. <br/>
**extracts:** The folder housing the extract of the SQL data in order to allow anyone to explore the Tableau dashboard. <br/>
**dashboard.twbx:** A Tableau dashboard which presents visual insights into the data which is pulled from the MySQL database. <br/>   
**dashboard_image.png:** An image of the Tableau dashboard to provide an overview of the data for GitHub display. <br/>    
**etl.py:** The python script that performs the Extract, Transform, and Load processes for this project. First, the script identifies the current date and parses it into the URL structure of the Spotify Top 200 RSS feed page in order to then scrape the data and save it in CSV format. Next, a call is made to the Spotify API in order to pull audio features (key, tempo, time signature, etc) for each track in the data set, adding these features for each track. Finally, a MySQL database is created and the CSV files in the *data*    folder are loaded. These steps are then repeated for each day in the last month from the current date (defined as 30 days). <br/>



# Analyzing The Gaming Industry Over Time
## Utilizing R & Adobe Illustrator

![Feature Importances](https://github.com/ryanhfrench/portfolio/blob/master/analyzing_key_indicators_of_high_app_reviews/feature_importances.png)

### Summary
As an avid gamer when I discovered the Video Game Sales dataset on Kaggle (https://www.kaggle.com/rush4ratio/video-game-sales-with-ratings) I was excited to see what different forms of visualizations I could create. In regards to the overall presentation, I wanted to embrace the culture of video games from a stylistic point of view and opted for a retro-themed color scheme and image style.

### Poster
![Poster](https://github.com/ryanhfrench/portfolio/blob/master/digitizing_the_gaming_industry/poster_image.png)

### Files
**resources:** The folder that holds the resources for the poster accents and the wordcloud. <br/>
**visualizations:** The folder that holds the visualization outputs from the R script. <br/>
**Video_Games_Sales.csv:** Data on the video game industry sales for the last 30 years. <br/>
**code.R:** The Script for importing, cleaning, and munging the data from <br/> *Video_Games_Sales_as_at_22_Dec_2016.csv* as well as building the visualizations programmatically. <br/>
**poster.pdf:** The final completed poster from Adobe Illustrator. <br/>
**poster_image.png:** An image of the poster to be displayed on GitHub. <br/>
**poster_project.ai:** The Adobe Illustrator project file for further processing of the visualizations generated in R. <br/>



# Analyzing Key Indicators of Positive Reviews for iOS Apps
## Utilizing Python

### Summary
My final project for Scripting for Data Analysis, I was interested to get a better understanding how easy readily one can predict which apps on the Apple iOS app store will be successful from a reviews standpoint as well as what the most important features are when it comes to indicating such success.

### Files
**appleStore_description.csv:** Data on ~7,000 iOS apps from the app store. <br/>
**code.py:** A Jupyter Notebook which contains code for importing, exploring, cleaning, and modeling a Random Forest model with the given iOS app data. <br/>
**presentation.pptx:** My presentation to accompany my code and report my findings. <br/>



# Visualizing, Predicting, & Understanding Crime in Syracuse
## Utilizing R

### Summary
As the culmination of my Undergraduate career in at Syracuse University's School of Information Science and the Renée Crown Honors Program, I was interested in pursuing a Capstone project that both would allow me to demonstrate my Data Science skillset and also contribute to the local community. It is with this goal in mind that I set out to visualize, predict, and understand the nature of crime in the city of Syracuse with the goal of providing new insights to the Syracuse population.

### Files
**Weekly_Crime_Offenses_2017.csv:** Syracuse crime data to be analyzed, taken directly from data.syrgov.net. <br/>
**code.R:** R script for data munging, visualization, and modeling. <br/>
**report.pdf:** Report submitted in fulfillment of my Renée Crown Honors Undergraduate Capstone project. <br/>
