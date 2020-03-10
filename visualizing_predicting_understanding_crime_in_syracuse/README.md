# Visualizing, Predicting, & Understanding Crime in Syracuse
## Utilizing R

### Summary
As the culmination of my Undergraduate career in at Syracuse University's School of Information Science and the Renée Crown Honors Program, I was interested in pursuing a Capstone project that both would allow me to demonstrate my Data Science skillset and also contribute to the local community. It is with this goal in mind that I set out to visualize, predict, and understand the nature of crime in the city of Syracuse with the goal of providing new insights to the Syracuse population.

### Files
**Weekly_Crime_Offenses_2017.csv:** Syracuse crime data to be analyzed, taken directly from data.syrgov.net. </br>
**code.R:** R script for data munging, visualization, and modeling. </br>
**report.pdf:** Report submitted in fulfillment of my Renée Crown Honors Undergraduate Capstone project. </br>

### Attributes
#### As obtained from Syracuse government GitHub page https://github.com/CityofSyracuse/OpenDataDictionaries/blob/master/PartICrimeSelected.pdf
**ADDRESS:** The address at which the crime occurred, scaled to the block level for anonymization purposes. *(string)* <br/>
**Arrest:** Whether or not an arrest occurred. *(string)* <br/>    
**Attempt:** Whether a crime was completed or merely attempted. *(string)* <br/>   
**CODE DEFINED:** The code associated with the type of crime (LARCENY, ROBBERY, AGRIVATED ASSAULT, etc). *(string)* <br/>     
**DATE:** The date on which the crime was reported. *(datetime)* <br/>     
**DRNUMB:** The unique ID for each instance of crime reported. *(int)* <br/>    
**FID:** The unique ID for each row in the data from the repository. *(int)* <br/>   
**LarcenyCode:** The location at which the Larceny took place (From Mailbox, From Building, From Motor Vehicle). *(string)* <br/>       
**TIMEEND:** The time at which responding to the crime ended. *(int)* <br/>  
**TIMESTART:** The time at which the crime was first reported. *(int)* <br/>   
