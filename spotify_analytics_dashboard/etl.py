
import datetime
import os
import csv
from io import StringIO
import pandas as pd
import requests
import sys
import spotipy
import spotipy.util as util
import time
import plotly.dashboard_objs as dashboard
import IPython.display
from IPython.display import Image
import pymysql
import mysql.connector

# Set Spotify credentials
CLIENT_ID = 'ff965144621b4bd7a8153a64d65ff418'
CLIENT_SECRET = 'ebe38d8381714c979e3ac2829b4cbc72'
username = 'rhfrenchy'
token = util.prompt_for_user_token(username, 'playlist-modify-public', CLIENT_ID, CLIENT_SECRET, 'http://localhost')

def create_data_directory():
    """Creates the data directory and returns the path.
    Inputs: None
    Outputs: The string path where the Spotify data will be stored in CSV \
             format.
    Processes:
        -Gets current directory
        -Creates a new folder to house the Spotify data
        -Returns the path to said folder
    """
    # Get current path
    path = os.getcwd()
    # Attempt to create 'data' folder
    try:
        os.mkdir(path + '/data')
    except Exception as e:
        print(e)
    return path



def get_formatted_date(day):
    """Converts a day number to datetime format.
    Inputs: The given day integer relative to the current date.
    Outputs: The day in datetime format.
    Processes:
        -Calculates difference between the current date and the day number.
        -Gets the year, month, and day for the identified date.
        -Returns the date in this format.
    """
    try:
        # Format the day in datetime
        formatted_date = datetime.date.today() + datetime.timedelta(days =- day)
        formatted_date = formatted_date.strftime("%Y-%m-%d")
        return formatted_date
    except Exception as e:
        print(e)

def get_url(formatted_date):
    """Builds the URL to access Spotify data for a specific date.
    Inputs: The given day in datetime format.
    Outputs: The URL to access the data for the given day.
    Processes:
        -Initializes the standard URL prefix and suffix
        -Creates the access URL by combining the prefix and suffix with the \
         given date.
        -Returns the resulting URL.
    """
    # Set URL prefix and suffix
    url_prefix = 'https://spotifycharts.com/regional/global/daily/'
    url_suffix = '/download'
    try:
        # Create URL to get data from date and URL prefix/suffix
        url = url_prefix + formatted_date + url_suffix
        return url
    except Exception as e:
        print(e)

def get_songs(url, formatted_date):
    """Scrapes the song data for the given URL and returns it in a list.
    Inputs: The access URL for a specific date, the date in datetime format.
    Outputs: A dataframe containing various songs and their attributes.
    Processes:
        -Requests the data for the URL via the Spotify API.
        -Reads the given data with pandas.
        -Inserts a new column and extracts the song's ID into said column.
        -Puts all of the data into a Pandas dataframe.
        -Returns said dataframe.
    """
    # Establish headers
    headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64) \
                              AppleWebKit/537.36 (KHTML, like Gecko) \
                              Chrome/56.0.2924.76 Safari/537.36'}
    # Request song data using custom URL
    request = requests.get(url, headers = headers).text
    # Create data frame from requested data
    songs = pd.read_csv(StringIO(request), sep = ',', header = 1)
    # Add date column to database with date of chart
    songs.insert(0, 'date', formatted_date)
    try:
        # Create ID column by extracting it from each song's URL
        ID = []
        for i in songs['URL']:
            ID.append((i[-22:]))
        songs['ID'] = ID
        # Create data frame from collected songs
        songs = pd.DataFrame(songs)
        return songs
    except Exception as e:
        print(e)

def get_audio_features(songs):
    """Obtains the audio features for the collected songs and associates them \
       appropriately before returning the resulting dataframe.
    Inputs: The songs dataframe.
    Outputs: A dataframe containing the songs and their features.
    Processes:
        -Authenticates the user with the Spotify API.
        -Pulls down results in groups in order to not overwhelm the API.
        -Adds results into the songs dataframe and remove unnecessary columns.
        -Returns the resulting dataframe.
    """
    # Check for token and pull down audio features for each song collected
    try:
        sp = spotipy.Spotify(auth = token)
        results_1 = sp.audio_features(tracks = songs['ID'][:51])
        results_2 = sp.audio_features(tracks = songs['ID'][51:101])
        results_3 = sp.audio_features(tracks = songs['ID'][101:151])
        results_4 = sp.audio_features(tracks = songs['ID'][151:201])
        results = results_1 + results_2 + results_3 + results_4
        audio_features = pd.DataFrame(results)
        # Remove unneeded columns after call
        drop_cols = ['id', 'type']
        audio_features = audio_features.drop(drop_cols, 1)
        # Add song features to original data frame of songs
        songs_and_features = pd.concat([songs.reset_index(drop = True), audio_features], axis = 1)
        return songs_and_features
    except Exception as e:
        print(e)
        print(songs_and_features)

def create_primary_key(songs_and_features):
    """Creates the primary key for the database by combining the date and the \
       song's ID.
    Inputs: The songs dataframe.
    Outputs: A dataframe containing the songs and their features.
    Processes:
        -Creates a primary key by iterating through the data frame and \
         combining the song's ID with the current date.
        -Returns the dataframe with the newly created primary key column.
    """
    primary_key = []
    try:
        i = 0
        # Iterate through songs creating composite primary key from ID and date
        while i < len(songs_and_features['ID']):
            primary_key.append(songs_and_features['ID'][i] + '_' + songs_and_features['date'][i])
            i += 1
        songs_and_features.insert(0, 'primary_key', primary_key)
        return songs_and_features
    except Exception as e:
        print(e)

# Function to create database to retain Spotify data
def create_db():
    """Creates the database to be utilized for storing the Spotify data.
    Inputs: None.
    Outputs: None.
    Processes:
        -Creates a database with the given credentials.
    """
    try:
        # Set parameters for SQL data base
        db = pymysql.connect(host = 'localhost',
                               user = 'root',
                               passwd = 'toortoor')
        # Initialize cursor
        cursor = db.cursor()
        cursor.execute('CREATE DATABASE spotify_data')
    except:
        print('Database already exists or could not be created.')

def create_schema():
    """Creates the table schema for the database to hold the Spotify data.
    Inputs: None.
    Outputs: None.
    Processes:
        -Connects to the database using the given credentials.
        -Creates the table with the proper column names and data types to \
         house the Spotify data.
        -Alter's the table to the UTF8MB3 character set.
    """
    try:
        # Set parameters for SQL data base
        db = pymysql.connect(host = 'localhost',
                               user = 'root',
                               passwd = 'toortoor',
                               db = 'spotify_data')
        create_table_query = 'CREATE TABLE songs_and_features_db ( \
                              primary_key VARCHAR(255), \
                              date_of_chart DATETIME, \
                              position INTEGER(10), \
                              track_name VARCHAR(255), \
                              artist VARCHAR(255), \
                              streams INTEGER(15), \
                              url VARCHAR(255), \
                              id VARCHAR(255), \
                              acousticness FLOAT(10), \
                              analysis_url VARCHAR(255), \
                              danceability FLOAT(10), \
                              duration_ms INTEGER(10), \
                              energy FLOAT(10), \
                              instrumentalness FLOAT(10), \
                              song_key INTEGER(10), \
                              liveness FLOAT(10), \
                              loudness FLOAT(10), \
                              mode INTEGER(10), \
                              speechiness FLOAT(10), \
                              tempo FLOAT(10), \
                              time_signature INTEGER(10), \
                              track_href VARCHAR(255), \
                              uri VARCHAR(255), \
                              valence FLOAT(10), \
                              PRIMARY KEY (primary_key));'
        alter_table_query = 'ALTER TABLE spotify_data.songs_and_features_db \
                             CONVERT TO CHARACTER SET UTF8MB3;'
        # Initialize cursor
        cursor = db.cursor()
        cursor.execute(create_table_query)
        cursor.execute(alter_table_query)
    except:
        print('Database already exists or could not be created.')

# Function to export CSV to data base
def export_to_db(csv_path):
    """Populates the database with the Spotify data from the CSV files.
    Inputs: String path to the CSV files.
    Outputs: None.
    Processes:
        -Connects to the database using the given credentials.
        -Inserts the data from the CSV files into the database.
    """
    # Open created .CSV file
    csv_data = csv.reader(open(csv_path, encoding = 'utf8'))
    # Connect to SQL server
    db = pymysql.connect(host = 'localhost',
                           user = 'root',
                           passwd = 'toortoor',
                           db = 'spotify_data')
    # Initialize cursor
    cursor = db.cursor()
    insert_data_query = 'INSERT IGNORE INTO spotify_data.songs_and_features_db( \
                         primary_key, \
                         date_of_chart, \
                         position, \
                         track_name, \
                         artist, \
                         streams, \
                         url, \
                         id, \
                         acousticness, \
                         analysis_url, \
                         danceability, \
                         duration_ms, \
                         energy, \
                         instrumentalness, \
                         song_key, \
                         liveness, \
                         loudness, \
                         mode, \
                         speechiness, \
                         tempo, \
                         time_signature, \
                         track_href, \
                         uri, \
                         valence) \
                         VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, \
                                %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, \
                                %s, %s, %s, %s);'
    # Add data frame information to SQL server
    row_count = 0
    for row in csv_data:
        if row_count != 0:
            try:
                cursor.execute(insert_data_query, (row))
            except pymysql.IntegrityError:
                print('Entry is either a duplicate or could not be created.')
        row_count += 1
    # Commit changes to SQL server and close connection
    db.commit()
    cursor.close()

# Execute functions
# Create 'data' folder to store .CSV Spotify data
path = create_data_directory()
# Create SQL database
create_db()
# Create SQL schema
create_schema()
# Get Spotify data and related audio features for the past month
# Start at 2 days ago as this data is reliably accessible
day = 2
while day <= 31:
    formatted_date = get_formatted_date(day)
    url = get_url(formatted_date)
    songs = get_songs(url, formatted_date)
    songs_and_features = get_audio_features(songs)
    songs_and_features = create_primary_key(songs_and_features)
    # Save resulting data frame as a .CSV file
    csv_path = path + '/data/spotify_top_200_' + formatted_date + '.csv'
    songs_and_features.to_csv(r'' + csv_path, index = False)
    # Export resulting data to SQL server
    export_to_db(csv_path)
    time.sleep(3)
    day += 1
