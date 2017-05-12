#James O'Reilly
#x00112673
#Repeat Project
#ui.R

library(DT)
library(shinythemes)

shinyUI(navbarPage(theme = shinytheme("cerulean"),
                   
                   # Application title
                   title = 'Repeat Project',
                   tabPanel('Table',
                            sidebarPanel(
                              selectInput("sport", "Select a sport:", 
                                          choices = c("All","400m", "Basketball",
                                                      "Field","Gym", "Netball",
                                                      "Rowing","Sprint", "Swimming",
                                                      "Tennis", "Water Polo")),
                              radioButtons("radio", label = "Male/Female", 
                                           choices = list("Male & Female" =  1,
                                                          "Male (0)" = 2,
                                                          "Female (1)" = 3),
                                           selected = 1),
                              sliderInput("height", "Height Range(cm):",
                                          min = 130, max = 220 , value = c(130,220)),
                              sliderInput("weight", "Weight Range(kg):",
                                          min = 30, max = 130, value = c(30,130)),
                              downloadButton('downloadData', 'Download')),
                            mainPanel(
                              dataTableOutput("athletes"))                                                 
                   ),
                   tabPanel('Visual Breakdown',
                            tabsetPanel(
                              tabPanel("Barplot",
                                       h4("Popularity of sport"),
                                       plotOutput("plot")
                              ),
                              tabPanel("Plot",
                                       sidebarPanel(
                                         selectInput("plot2", "Select chart:",
                                                     choices = c("Wt/BMI","WCC/RCC")),
                                         verbatimTextOutput("info"),
                                         sliderInput("n", "Number of athletes", 10, 202,
                                                     value = 101, step = 10)
                                       ),
                                       mainPanel(
                                         plotOutput("scatPlot",  click = "plot_click")
                                       )
                              )
                            )
                   ),
                   navbarMenu("More",
                              tabPanel("Summary",
                                       verbatimTextOutput("summary")),
                              tabPanel('About',
                                       paste("The data is basic information collected on athletes.
                                  The columns can be understood as statistical data with the following meaning:
                                  Ht: Height, Wt: Weight, LBM: lean body mass, BMI: body mass index, RCC: red cell count, WCC: white cell count, Bfat: body fat, Ferr: blood cell ferritin.
                                  The sex of the athlete is given as either 0 (male) 1 (female).")
                              )
                   )
))