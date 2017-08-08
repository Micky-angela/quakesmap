library(shiny)
require(leaflet)
require(lubridate)

quakes <- read.csv("results_2",
                   sep = "\t", header = TRUE)

datquake <- subset(quakes, select = c("YEAR", "MONTH", "DAY", "LATITUDE", "LONGITUDE", "EQ_PRIMARY","LOCATION_NAME","REGION_CODE"))
datquake <- datquake[complete.cases(datquake), ]

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
        
        # Expression that generates a histogram. The expression is
        # wrapped in a call to renderPlot to indicate that:
        #
        #  1) It is "reactive" and therefore should re-execute automatically
        #     when inputs change
        #  2) Its output type is a plot
        
        output$distPlot <- renderLeaflet({
                quakeyear <- subset(datquake, YEAR == year(input$Input2))
                if(input$region == 1) {
                        quakeyearregion <- quakeyear
                }else{
                        quakeyearregion <- subset(quakeyear, REGION_CODE == input$region)
                }

                if(nrow(quakeyearregion) == 0){
                        leaflet() %>%
                                addTiles() %>% 
                                fitBounds(163.4, 
                                          56.2, 
                                          -121.698, 
                                          -10.012) 
                }else{
                        df <- data.frame( popup = paste0(paste(quakeyearregion$DAY, month(quakeyearregion$MONTH, label = TRUE)),
                                                         paste(", magnitude:", quakeyearregion$EQ_PRIMARY)),
                                          lat = quakeyearregion$LATITUDE, 
                                          lng =  quakeyearregion$LONGITUDE, 
                                          radius = 3*((quakeyearregion$EQ_PRIMARY)- 1.5),
                                          stringsAsFactors = FALSE)
                        
                        df %>% leaflet() %>%
                                addTiles() %>% 
                                fitBounds(max(quakeyearregion$LONGITUDE + 0.5), 
                                          max(quakeyearregion$LATITUDE + 0.5), 
                                          min(quakeyearregion$LONGITUDE - 0.5), 
                                          min(quakeyearregion$LATITUDE - 0.5))  %>% 
                                addCircleMarkers( radius = df$radius, label = df$popup) 
                }
        })
        
        totalEQ <- reactive({
                quakeyear <- subset(datquake, YEAR == year(input$Input2))
                if(input$region == 1) {
                        quakeyearregion <- quakeyear
                }else{
                        quakeyearregion <- subset(quakeyear, REGION_CODE == input$region)
                }
                nrow(quakeyearregion)
        })
        
        output$sumEQ <- renderText({
                totalEQ()
        })
})
