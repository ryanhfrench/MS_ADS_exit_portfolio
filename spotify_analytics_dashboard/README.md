# Spotify Top 200 Daily Tracks & Features Analysis
## Utilizing Python, SQL, & Tableau

### Summary
Probably my most used app on a daily basis, my Spotify is almost always open whether it be me creating playlists to share with my friends, listening to a podcast on the way to class, or enjoying my Discover Weekly while I code. Due to its position as one of the largest streaming platforms in the world, I was interested to take a look at the daily updated Top 200 RSS Feed (which can be found at https://spotifycharts.com/regional/global/daily/) and see if I could create a database to house the data as well as a dashboard to effectively explore it.

### Dashboard
![Dashboard Image](dashboard_image.png)
[Interact with the Dashboard on Tableau Public](https://public.tableau.com/profile/ryan.french4207#!/vizhome/SpotifyTop200DailyTracksFeaturesAnalysis/SpotifyTop200DailyTracksFeaturesAnalysis)

### Files  
**data:** The folder housing the Spotify data that I collected in CSV format for each date. </br>
**extracts:** The folder housing the extract of the SQL data in order to allow anyone to explore the Tableau dashboard. </br>
**dashboard.twbx:** A Tableau dashboard which presents visual insights into the data which is pulled from the MySQL database. </br>   
**dashboard_image.png:** An image of the Tableau dashboard to provide an overview of the data for GitHub display. </br>    
**etl.py:** The python script that performs the Extract, Transform, and Load processes for this project. First, the script identifies the current date and parses it into the URL structure of the Spotify Top 200 RSS feed page in order to then scrape the data and save it in CSV format. Next, a call is made to the Spotify API in order to pull audio features (key, tempo, time signature, etc) for each track in the data set, adding these features for each track. Finally, a MySQL database is created and the CSV files in the *data*    folder are loaded. These steps are then repeated for each day in the last month from the current date (defined as 30 days). </br>

### Attributes
#### As represented in the MySQL database and Tableau dashboard, definitions provided by Spotify  
**primary_key:** The Primary Key which consists of a composite of each songs ID and the current date.  *(VARCHAR)* </br>     
**date:**  The date of the chart. *(DATETIME)* </br>   
**position:**  The position of the song on the chart. *(INTEGER)* </br>   
**track_name:**  The name of the song. *(VARCHAR)* </br>   
**artist:**  The artist who wrote the song. *(VARCHAR)* </br>   
**streams:**  The number of Streams that the song had up to the given date. *(INTEGER)* </br>   
**url:** The URL to play the song on the Spotify web player *(VARCHAR)* </br>   
**id:** The Spotify ID for the track. *(VARCHAR)* </br>   
**acousticness:**  A confidence measure from 0.0 to 1.0 of whether the track is acoustic. 1.0 represents high confidence the track is acoustic. *(FLOAT)* </br>   
**analysis_url:**	An HTTP URL to access the full audio analysis of this track. An access token is required to access this data. *(VARCHAR)* </br>   
**danceability:** Danceability describes how suitable a track is for dancing based on a combination of musical elements including tempo, rhythm stability, beat strength, and overall regularity. A value of 0.0 is least danceable and 1.0 is most danceable. *(FLOAT)* </br>   
**duration_ms:** 	The duration of the track in milliseconds. *(INTEGER)* </br>  
**energy:** Energy is a measure from 0.0 to 1.0 and represents a perceptual measure of intensity and activity. Typically, energetic tracks feel fast, loud, and noisy. For example, death metal has high energy, while a Bach prelude scores low on the scale. Perceptual features contributing to this attribute include dynamic range, perceived loudness, timbre, onset rate, and general entropy. *(FLOAT)* </br>  
**instrumentalness:** Predicts whether a track contains no vocals. “Ooh” and “aah” sounds are treated as instrumental in this context. Rap or spoken word tracks are clearly “vocal”. The closer the instrumentalness value is to 1.0, the greater likelihood the track contains no vocal content. Values above 0.5 are intended to represent instrumental tracks, but confidence is higher as the value approaches 1.0. *(FLOAT)* </br>  
**song_key:** The estimated overall key of the track. Integers map to pitches using standard Pitch Class notation . E.g. 0 = C, 1 = C♯/D♭, 2 = D, and so on. If no key was detected, the value is -1. *(INTEGER)* </br>  
**liveness:** Detects the presence of an audience in the recording. Higher liveness values represent an increased probability that the track was performed live. A value above 0.8 provides strong likelihood that the track is live. *(FLOAT)* </br>  
**loudness:** The overall loudness of a track in decibels (dB). Loudness values are averaged across the entire track and are useful for comparing relative loudness of tracks. Loudness is the quality of a sound that is the primary psychological correlate of physical strength (amplitude). Values typical range between -60 and 0 db. *(FLOAT)* </br>  
**mode:** Mode indicates the modality (major or minor) of a track, the type of scale from which its melodic content is derived. Major is represented by 1 and minor is 0. *(INTEGER)* </br>  
**speechiness:** Speechiness detects the presence of spoken words in a track. The more exclusively speech-like the recording (e.g. talk show, audio book, poetry), the closer to 1.0 the attribute value. Values above 0.66 describe tracks that are probably made entirely of spoken words. Values between 0.33 and 0.66 describe tracks that may contain both music and speech, either in sections or layered, including such cases as rap music. Values below 0.33 most likely represent music and other non-speech-like tracks. *(FLOAT* </br>  
**tempo:** 	The overall estimated tempo of a track in beats per minute (BPM). In musical terminology, tempo is the speed or pace of a given piece and derives directly from the average beat duration. *(FLOAT)* </br>  
**time_signature:** An estimated overall time signature of a track. The time signature (meter) is a notational convention to specify how many beats are in each bar (or measure). *(INTEGER)* </br>  
**track_href:** A link to the Web API endpoint providing full details of the track. *(VARCHAR)* </br>  
**uri:** 	The Spotify URI for the track. *(VARCHAR)* </br>  
**valence:** 	A measure from 0.0 to 1.0 describing the musical positiveness conveyed by a track. Tracks with high valence sound more positive (e.g. happy, cheerful, euphoric), while tracks with low valence sound more negative (e.g. sad, depressed, angry). *(FLOAT)* </br>   
