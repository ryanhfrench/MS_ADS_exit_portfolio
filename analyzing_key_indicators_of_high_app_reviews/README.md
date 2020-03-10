# Analyzing Key Indicators of Positive Reviews for iOS Apps
## Utilizing Python

![Feature Importances](https://github.com/ryanhfrench/portfolio/blob/master/analyzing_key_indicators_of_high_app_reviews/feature_importances.png)

### Summary
My final project for Scripting for Data Analysis, I was interested to get a better understanding how easy readily one can predict which apps on the Apple iOS app store will be successful from a reviews standpoint as well as what the most important features are when it comes to indicating such success.

### Files
**appleStore_description.csv:** Data on ~7,000 iOS apps from the app store. <br/>
**code.py:** A Jupyter Notebook which contains code for importing, exploring, cleaning, and modeling a Random Forest model with the given iOS app data. <br/>
**presentation.pptx:** My presentation to accompany my code and report my findings. <br/>

### Attributes
#### As obtained from Kaggle https://www.kaggle.com/ramamet4/app-store-apple-data-set-10k-apps
**id:** The individual ID for each application <br/>
**track_name:** The individual title for each application </br>
**size_bytes:** The size of the application </br>
**currency:** The native currency of the application (in this case all USD) </br>
**price:** Cost of the application </br>
**rating_count_tot:** How many ratings the application has received in its lifetime </br>
**rating_count_ver:** How many ratings the application has received for this version </br>
**user_rating:** The aggregate user rating for the applicaton </br>
**user_rating_ver:** The aggregate user rating for the application at its current version </br>
**ver:** The current application version </br>
**cont_rating:** The content rating for the application (4+, 9+, etc) </br>
**prime_genre:** Genre for the application </br>
**sup_devices.num:** Number of devices supported by the application </br>
**ipadSc_urls.num:** Number of screenshots shown on the application page </br>
**lang.num:** Number of supported languages </br>
**vpp_lic:** Whether or not Vpp device based licensing enabled</br>
