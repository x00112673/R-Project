#James O'Reilly
#x00112673
#Repeat Project
#server.R

library(gdata)
library(DT)

shinyServer(function(input, output) {
  #athletes.txt is converted it into a dataset called Athletes.
  Athletes <- read.csv("athletes.txt")
  
  #Reads in input from dropdown menu
  sportInput <- reactive({
    switch(input$sport,
           "400m" = "t_400m",
           "Basketball" = "b_ball",
           "Field" = "field",
           "Gym" = "gym", 
           "Netball" = "netball",
           "Rowing" = "row",
           "Sprint" = "t_sprnt",
           "Swimming" = "swim",
           "Tennis" = "tennis",
           "Water Polo" = "w_polo")
    
  })
  
  plotInput <- reactive({
    switch(input$plot2,
           "Wt/BMI" = "Wt/BMI",
           "WCC/RCC" = "WCC/RCC")
  })
  
  #retrieves slider input
  sliderValues <- reactive({
    data.frame(
      Name = c("radio", "height","weight","n"),
      Value = as.character(c(input$radio,
                             paste(input$height, collapse = ''),
                             input$weight,
                             input$n)),
      stringsAsFactors = FALSE)
  })
  
  output$athletes <- renderDataTable({
    
    #this subAthletes variable is created to provide a cleaner more readable
    #R script. Using these lines of code now will save myself from having to
    #declare them again in each if statement.
    if(is.null(sportInput())){
      subAthletes <- subset(Athletes, Ht >= input$height[1] &
                              Ht <= input$height[2] &
                              Wt >= input$weight[1] & 
                              Wt <= input$weight[2])
    }else{
      subAthletes <- subset(Athletes, Ht >= input$height[1] &
                              Ht <= input$height[2] &
                              Wt >= input$weight[1] & 
                              Wt <= input$weight[2] &
                              Sport == sportInput())
    }
    if(input$radio == 1){
      subAthletes
    } else if(input$radio == 2){
      subset(subAthletes, Sex == 0 )
    } else if(input$radio == 3){
      subset(subAthletes, Sex == 1)
    }
  })
  
  #Allows the user to download the Athlete dataset as a .csv file
  output$downloadData <- downloadHandler(
    filename = "Athletes.csv",
    content = function(file) {
      write.csv(Athletes, file)
    }
  )
  
  #Generation of Sports barplot
  output$plot <- renderPlot({
    barplot(table(Athletes$Sex,Athletes$Sport), 
            xlab = "Sport",
            ylab = "Number of Athletes",
            col = c("blue", "red"),
            legend = c("Male","Female"),
            beside = TRUE)
  })
  
  #Generation of scatterPlot chosen
  output$scatPlot <- renderPlot({
    subAthletes <- Athletes[sample(input$n),]
    if(plotInput() == "Wt/BMI"){
      plot(subAthletes$Wt,subAthletes$BMI,
           xlab = "Weight",
           ylab = "BMI")
    }
    if(plotInput() == "WCC/RCC"){
      plot(subAthletes$WCC,subAthletes$RCC,
           xlab = "White Cell Count",
           ylab = "Red Cell Count")
    }
  })
  
  output$info <- renderText({
    if(plotInput() == "Wt/BMI"){
      paste0("Weight = ", input$plot_click$x, "\nBMI = ", input$plot_click$y)
    }
    else if(plotInput() == "WCC/RCC"){
      paste0("White Cell Count = ", input$plot_click$x, "\nRed Cell Count = ", input$plot_click$y)
    }
  })
  
  output$summary <- renderPrint({
    summary(Athletes)
  })
})