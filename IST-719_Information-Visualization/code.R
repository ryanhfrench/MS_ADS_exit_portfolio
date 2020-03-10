# Import packages
library(viridis)
library(dplyr)
library(plotly)
library(GGally)
library(treemapify)
library(tm)
library(wordcloud2)
library(processx)
library(rstudioapi)

# Get working directory
current_path = rstudioapi::getActiveDocumentContext()$path 
setwd(dirname(current_path))
path = getwd()

# Set Mapbox token for Orca
Sys.setenv("MAPBOX_TOKEN" = "YOUR_MAPBOX_TOKEN_HERE")

# Import data
data <- read.csv("Video_Game_Sales.csv", header = TRUE, stringsAsFactors = FALSE)
vg <- data

# View information on the data
str(vg)

# Fix numeric columns classed as characters
vg$Year_of_Release <- as.numeric(as.character(vg$Year_of_Release))
vg$User_Count <- as.numeric(as.character(vg$User_Count))
vg$User_Score <- as.numeric(as.character(vg$User_Score))

# Get columns with NA values
colnames(vg)[colSums(is.na(vg)) > 0]

# Only look at data up until 2017 (when this data was last updated, there are some outliers)
vg <- vg[vg$Year_of_Release <= 2017, ]

# Fill empty Genre, Developer, and Rating data with "Unknown"
vg$Developer <- sub("^$", "Unknown", vg$Developer)
vg$Rating <- sub("^$", "Unknown", vg$Rating)
vg$Genre <- sub("^$", "Misc", vg$Genre)

# Create color palette
colors <- viridis(6)



# Subset data by last and current generation consoles
cc <- vg %>% filter(Platform %in% c("Wii", "X360", "PS3", "WiiU", "XOne", "PS4"))

# Create separate data frames for last and current generation consoles
cc_last <- cc %>% filter(Platform %in% c("Wii", "X360", "PS3")) 
cc_current <- cc %>% filter(Platform %in% c("WiiU", "XOne", "PS4"))

# Donut plots of sales per console by generation
market_plot_last <- cc_last %>%
  group_by(Platform) %>%
  summarize(count = n()) %>%
  plot_ly(labels = ~Platform, values = ~count, marker = list(colors = colors[c(4, 3, 5)], line = list(color = '#FFFFFF', width = 1))) %>%
  add_pie(hole = 0.6) %>%
  layout(title = "Last Generation Sales by Console",  showlegend = T,
         xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
         yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
market_plot_last
# Export plot using orca
orca(market_plot_last, "/visualizations/donut_last_gen.pdf")



market_plot_current <- cc_current %>%
  group_by(Platform) %>%
  summarize(count = n()) %>%
  plot_ly(labels = ~Platform, values = ~count, marker = list(colors = colors[c(4, 3, 5)], line = list(color = '#FFFFFF', width = 1))) %>%
  add_pie(hole = 0.6) %>%
  layout(title = "Current Generation Sales by Console (as of 2016)",  showlegend = T,
         xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
         yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
market_plot_current
# Export plot using orca
orca(market_plot_current, "/visualizations/donut_cur_gen.pdf")



# Subset sales variables from data
cor <- vg[, c(6, 7, 8, 9, 10)]

# Correlation plot of sales variables
corr_sales <- ggcorr(cor, nbreaks = 8, low = colors[2], mid = colors[2], high = colors[4], label = TRUE, label_size = 5, 
       label_color = "white")
corr_sales
# Export plot using orca
orca(corr_sales, "/visualizations/corr_sales.pdf")



# Time series of releases over time by Platform
ts <- vg[, c(3, 2)]
ts <- ts %>% group_by(Year_of_Release, Platform) %>% summarize(n())
colnames(ts)[3] <- "count"

# Add brand for each console
ts["brand"] <- NA
ts$brand[ts$Platform == "2600"] <- "Atari"
ts$brand[ts$Platform == "3DS"] <- "Nintendo"
ts$brand[ts$Platform == "DC"] <- "Sega"
ts$brand[ts$Platform == "DS"] <- "Nintendo"
ts$brand[ts$Platform == "GB"] <- "Nintendo"
ts$brand[ts$Platform == "GBA"] <- "Nintendo"
ts$brand[ts$Platform == "GC"] <- "Nintendo"
ts$brand[ts$Platform == "GEN"] <- "Sega"
ts$brand[ts$Platform == "GG"] <- "Sega"
ts$brand[ts$Platform == "N64"] <- "Nintendo"
ts$brand[ts$Platform == "NES"] <- "Nintendo"
ts$brand[ts$Platform == "PC"] <- "PC"
ts$brand[ts$Platform == "PS"] <- "Sony"
ts$brand[ts$Platform == "PS2"] <- "Sony"
ts$brand[ts$Platform == "PS3"] <- "Sony"
ts$brand[ts$Platform == "PS4"] <- "Sony"
ts$brand[ts$Platform == "PSP"] <- "Sony"
ts$brand[ts$Platform == "PSV"] <- "Sony"
ts$brand[ts$Platform == "SAT"] <- "Sega"
ts$brand[ts$Platform == "SCD"] <- "Sega"
ts$brand[ts$Platform == "SNES"] <- "Nintendo"
ts$brand[ts$Platform == "Wii"] <- "Nintendo"
ts$brand[ts$Platform == "WiiU"] <- "Nintendo"
ts$brand[ts$Platform == "X360"] <- "Microsoft"
ts$brand[ts$Platform == "XB"] <- "Microsoft"
ts$brand[ts$Platform == "XOne"] <- "Microsoft"

# Drop outlying gaming systems
drop_consoles <- names(ts) %in% c("WS", "TG16", "NG", "3DO", "PCFX") 
ts <- ts[!drop_consoles]

# Remove single NA row generated in process of creation
ts <- na.omit(ts)
ts <- aggregate(ts[3], ts[, c(1, 4)], FUN = sum )

time_series_brands <- ggplot(ts, aes(x = Year_of_Release, y = count, group = brand, color = brand)) + 
  geom_point(size = 1) + viridis::scale_color_viridis(discrete = TRUE) + 
  geom_line() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + 
  labs(title = "Releases by Platform over Time")
time_series_brands
# Export plot using orca
orca(time_series_brands, "/visualizations/ts_brands.pdf")



# Time series of releases over time by Genre
ts <- vg[, c(4, 3)]
ts <- ts %>% group_by(Year_of_Release, Genre) %>% summarize(n())
colnames(ts)[3] <- "count"
# Remove single NA row generated in process of creation
ts <- na.omit(ts)
time_series_genre <- ggplot(ts, aes(x = Year_of_Release, y = count, group = Genre, color = Genre)) + 
  geom_point(size = 1) + viridis::scale_color_viridis(discrete = TRUE) + 
  geom_line() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + 
  labs(title = "Releases by Genre over Time")
time_series_genre
# Export plot using orca
orca(time_series_genre, "/visualizations/ts_genre.pdf")



# Time series of releases over time by Rating
ts <- vg[, c(16, 3)]
ts <- ts %>% group_by(Year_of_Release, Rating) %>% summarize(n())
colnames(ts)[3] <- "count"
# Remove single NA row generated in process of creation
ts <- na.omit(ts)
time_series_rating <- ggplot(ts, aes(x = Year_of_Release, y = count, group = Rating, color = Rating)) + 
  geom_point(size = 1) + viridis::scale_color_viridis(discrete = TRUE) + 
  geom_line() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + 
  labs(title = "Releases by Rating over Time")
time_series_rating
# Export plot using orca
orca(time_series_genre, "/visualizations/ts_rating.pdf")



# Box plot of Critic & User Score by Genre
c_bp <- vg[, c(4, 11)]
colnames(c_bp) <- c("genre", "score")
c_bp$label <- "critics"
u_bp <- vg[, c(4, 13)]
colnames(u_bp) <- c("genre", "score")
u_bp$label <- "users"

# Adjust user ratings by multiplying by 10 so that the scale is equivalent to that of the critics
u_bp$score <- u_bp$score * 10

# Combine separate tables
bp <- rbind(c_bp, u_bp)
bp$genre <- as.factor(bp$genre)
bp$label <- as.factor(bp$label)

# Remove rows with no Score
bp <- na.omit(bp)
boxplot_score <- ggplot(bp, aes(genre, score, fill = label)) + geom_boxplot(size = 1) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) + ggtitle("Critic vs User Score by Genre")
boxplot_score <- boxplot_score + scale_fill_manual(values=c(colors[3], colors[5]))
boxplot_score
# Export plot using orca
orca(boxplot_score, "/visualizations/boxplot_critic_vs_user.pdf")



# Word cloud of game titles
corpus <- Corpus(VectorSource(vg$Name))

# Clean text
# Convert the text to lower case
corpus <- tm_map(corpus, content_transformer(tolower))
# Remove numbers
corpus <- tm_map(corpus, removeNumbers)
# Remove english stopwords
corpus <- tm_map(corpus, removeWords, stopwords("english"))
# Remove punctuations
corpus <- tm_map(corpus, removePunctuation)
# Eliminate extra white spaces
corpus <- tm_map(corpus, stripWhitespace)

# Orangize data
dtm <- TermDocumentMatrix(corpus)
m <- as.matrix(dtm)
v <- sort(rowSums(m), decreasing = TRUE)
title_frequencies <- data.frame(word = names(v),freq = v)

# Create cloud
fig_path = paste(path, "/resources/controller.png", sep="")
png("/visualizations/word_cloud.png", units = "in", width = 10, height = 10, res = 300)
wordcloud2(title_frequencies, figPath = fig_path, size = 1.5, color = colors[4])
dev.off()
