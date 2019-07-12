#7.12.2019

#My Notes on <Part 1 - How to build a Shiny app>
#In the Entire Tutorial video, Part 1 runs from 00:00 to 41:56

#Shiny App Contains Two componenets
#1. User Interface (UI) - webpage/webdoc: .html
#2. Server Instructions (R)

#App template: shortest viable shiny app
#install.packages("shiny")
library(shiny)

#Blank page
ui = fluidPage()
server = function(input, output) {}
shinyApp(ui = ui, server = server)

#Add something, a text
ui = fluidPage("Hello World")
server = function(input, output) {}
shinyApp(ui = ui, server = server)


## Build Your App around Inputs and Outputs ##
ui = fluidPage(
  # *Input() functions,
  # *Output() functions
)
server = function(input, output) {}
shinyApp(ui = ui, server = server)

##### INPUTS #####

# Ex) Slider Input
ui = fluidPage(
  sliderInput(inputId = "num",
              label = "Choose a number",
              value = 2, min = 1, max = 100)
)
server = function(input, output) {}
shinyApp(ui = ui, server = server)

#<Function Arguments>
#inputId = input name
#label = label to display
#etc: input specific arguments (min, max, value)

#<Other Input Functions>
#actionButton() ... submitButton()
#checkboxInput() ... checkboxGroupInput()
#dateInput() ... dateRangeInput()
#fileInput() ... numericInput()
#passwordInput() ... radioButtons()
#selectInput() ... textInput() 


##### OUTPUTS #####

#Plots, Tables, Text

#<List of Output Functions>
#dataTableOutput() ... htmlOutput()
#imageOutput() ... plotOutput()
#tableOutput() ... textOutput()
#uiOutput() ... verbatimTextOutput()

#Tell the server how to assemble inputs into outputs
#<3 Rules>
#1. Save objects to display to output$
#2. Build objects to display with render*()
#3. Access input values with input$

##### RENDER ##### (3rd family of functions)
#renderDataTable() ... renderImage()
#renderPlot() ... renderPrint()
#renderTable() ...renderText()
#renderUI()


#EXAMPLE) Build histogram 
#instead of rnorm(100) : specific value, plug in input$num
#input$num = the input value depending on the slider
#Create REACTIVITY by using inputs to build rendered Outputs.

ui = fluidPage(
  sliderInput(inputId = "num",
              label = "Choose a number",
              value = 2, min = 1, max = 100),
  plotOutput("hist")
)
server = function(input, output) {
  output$hist = renderPlot({
    title = "100 Random Normal Values"
    hist(rnorm(input$num), main = title)
  })
}
shinyApp(ui = ui, server = server)


## Sharing your App (pt.1 number 7) ##

#<< How to Save Your App >>
#One directory with every file the app needs:
# - app.R (your script which ends with a call to shinyApp())
# - datasets, images, css, helper scripts, etc.

#If you need to split your app into two files (for example, if your file is too large)
#Use one directory with TWO files:
# - server.R
# - ui.R

# ** Use shinyapps.io ** to share your apps online
# - a server maintained by RStudio
# - free, easy to use, secure, scalable
#You also have the freedom to build your own server.
#Check link below if interested (free & open source).
#www.rstudio.com/products/shiny/shiny-server/

#Helpful Link: The Shiny Development Center
#Link: shiny.rstudio.com

#This is the End of Part 1.