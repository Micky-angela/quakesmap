library(shiny)
require(leaflet)
require(lubridate)

# Define UI for application that draws a histogram
shinyUI(

        fluidPage(
        
        # Application title
        titlePanel("Map of quakes detected on earth (from 1951 to 2016)"),
        
        # Sidebar with a slider input for the number of bins
        fluidRow(
                # Show a plot of the generated distribution
                column(12,
                       sliderInput("Input2", "Year:", width = "200%",
                                   timeFormat="%Y",
                                   min = as.POSIXct("1951", format = "%Y"), 
                                   max = as.POSIXct("2016", format = "%Y"),
                                   value = as.POSIXct("2010", format = "%Y")) 
                ),
                column(9,
                       leafletOutput("distPlot")
                ),
                column(3,
                       selectInput("region", "Region:",
                                   c("Worldwide" = 1,
                                     "Central, Western and S. Africa" = 10,  	
                                     "Northern Africa" = 15,
                                     "Antarctica" = 20,
                                     "East Asia" = 30,
                                     "Central Asia and Caucasus" = 40,
                                     "Kamchatka and Kuril Islands" = 50,
                                     "S. and SE. Asia and Indian Ocean" = 60,
                                     "Atlantic Ocean" = 70,
                                     "Bering Sea" = 80,
                                     "Caribbean" = 90,
                                     "Central America" = 100,
                                     "Eastern Europe" = 110,
                                     "Northern and Western Europe" = 120,
                                     "Southern Europe" = 130,
                                     "Middle East" = 140,
                                     "North America and Hawaii" = 150,
                                     "South America" = 160,
                                     "Central and South Pacific" = 170)                                   )
                ),
                column(3,
                       helpText("Note: select the year and region of interest to see the quakes registered in the", a("Significant Earthquake Database.",     href="https://www.ngdc.noaa.gov/nndc/struts/form?t=101650&s=1&d=1", target="_blank")),
                       helpText("The radii are proportional to the magnitude of the quakes. Hover the mouse over the circles for more information about date and magnitude."),
                       helpText("The total number of quakes in a given region and year is provided below."),
                       h4("Number of earthquakes"),
                       textOutput("sumEQ")
                       
                )
        )
))
