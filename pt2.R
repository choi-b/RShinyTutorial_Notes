#7.12.2019

#My Notes on <Part 2 - How to Customize Reactions>.
#In the Entire Tutorial video, Part 2 runs from 41:57 to 1:32:40 

#What is Reactivity?
#Think Microsoft Excel. "Inputs" & "Outputs"

#Reactive Value
#a value that changes/reacts to some sort of input.
#don't work on their own.
#They work together with reactive functions. (ex) renderPlot()

#<Reactive Toolkit>

#1.Display output with render*(), seen from part 1.
# - render*() functions make objects to display
# - Always save the result to output$
# - render*() makes an observer object that has a block of code associated with it.
# - The object will rerun the entire code block to update itself whenever it is invalidated.

#2.Modularize code with reactive()
# - Build a reactive object (reactive expression)
data = reactive( {rnorm(input$num)})
# - 1. Reactive expressions are technically functions.
# - 2. Reactive expressions cache their values. (returns most recent value unless it's invalidated)
data()

#Shiny App Example

ui = fluidPage(
  sliderInput(inputId = "num",
              label = "Choose a number",
              value = 25, min = 1, max = 100),
  plotOutput("hist"),
  verbatimTextOutput("stats")
)

server = function(input, output) {
  output$hist = renderPlot({
    hist(rnorm(input$num))
  })
  output$stats = renderPrint({
    summary(rnorm(input$num))
  })
}

shinyApp(ui = ui, server = server)


#Shiny App Example with Reactive Expression:
#Produces the same results.
ui = fluidPage(
  sliderInput(inputId = "num",
              label = "Choose a number",
              value = 25, min = 1, max = 100),
  plotOutput("hist"),
  verbatimTextOutput("stats")
)

server = function(input, output) {
  data = reactive({
    rnorm(input$num)
  })
  output$hist = renderPlot({
    hist(data())
  })
  output$stats = renderPrint({
    summary(data())
  })
}

shinyApp(ui = ui, server = server)


#3.Prevent Reactions with isolate()

#Consider the example)
#Using two inputs to create an output
ui = fluidPage(
  sliderInput(inputId = "num",
              label = "Choose a number",
              value = 25, min = 1, max = 100),
  textInput(inputId = "title",
            label = "Write a title",
            value = "Histogram of Random Normal Values"),
  plotOutput("hist")
)

server = function(input, output) {
  output$hist = renderPlot({
    hist(rnorm(input$num),
         main = input$title)
  })
}

shinyApp(ui = ui, server = server)

#But the app is already reacting AS I TYPE the title.
#Prevent the title field from updating the plot.
#Use isolate() -> returns the result as a non-reactive value.

ui = fluidPage(
  sliderInput(inputId = "num",
              label = "Choose a number",
              value = 25, min = 1, max = 100),
  textInput(inputId = "title",
            label = "Write a title",
            value = "Histogram of Random Normal Values"),
  plotOutput("hist")
)

server = function(input, output) {
  output$hist = renderPlot({
    hist(rnorm(input$num),
         main = isolate({input$title})) #use the isolate function here. The output doesn't depend on "input$title"
  })
}

shinyApp(ui = ui, server = server)


#4. Trigger Code to run on server with observeEvent()
# - Specify precisely which reactive values should invalidate the observer
# - Use observe() for a more implicit syntax

#Use Action Button -> input function like a sliderInput
#Syntax) observeEvent(input$clicks, { print(input$clicks)})
# arg 1-> "input$clicks" = reactive value(S) to respond to
# arg 2 -> block of code to run whenever observer is invalidated.

ui = fluidPage(
  actionButton(inputId = "clicks",
               label = "Click me")
)
server = function(input, output) {
  observeEvent(input$clicks, {
    print(as.numeric(input$clicks))
  })
}
shinyApp(ui = ui, server = server)

#check R script in the "Console" for the number of clicks.

#<More on Action buttons>
#Link: http://shiny.rstudio.com/articles/action-buttons.html

#observe()
#also triggers code to run on server
#uses same syntax as render*(), reactive(), and isolate()


#5. Delay reactions with eventReactive()

#Comeing back to Histogram + slider example
ui = fluidPage(
  sliderInput(inputId = "num",
              label = "Choose a number",
              value = 25, min = 1, max = 100),
  actionButton(inputId = "go",
               label = "Update"), # * actionButton added
  plotOutput("hist")
)

server = function(input, output) {
  output$hist = renderPlot({
    hist(rnorm(input$num))
  })
}

shinyApp(ui = ui, server = server)

#When you use the slider, the histogram changes
#Prevent the graph from updating until we hit the "Update" button

#Use eventReactive()
#Syntax is a lot like observeEvent()
ui = fluidPage(
  sliderInput(inputId = "num",
              label = "Choose a number",
              value = 25, min = 1, max = 100),
  actionButton(inputId = "go",
               label = "Update"), # * actionButton added
  plotOutput("hist")
)

server = function(input, output) {
  data = eventReactive(input$go, { #eventReactive() will invalidate when the go button is clicked
    rnorm(input$num) #Then recompute the dataset using "rnorm(input$num)"
  })
  output$hist = renderPlot({
    hist(data()) #use a reactive expression instead.
  })
}

shinyApp(ui = ui, server = server)

#<Recap of eventReactive()>
# Update button => use eventReactive() to delay reactions
# data() => eventReactive() creates a reactive expression
# You can specify precisely which reactive values should invalidate the expression


#6. Manage state with reactiveValues()

#reactiveValues()
#- creates a list of reactive values to manipulate programmatically
#rv = reactiveValues(data = rnorm(100))

#Example)

ui = fluidPage(
  actionButton(inputId = "norm",label = "Normal"),
  actionButton(inputId = "unif",label = "Uniform"),
  plotOutput("hist")
)

server = function(input, output) {
  
  rv = reactiveValues(data = rnorm(100))
  
  observeEvent(input$norm, { rv$data = rnorm(100)})
  observeEvent(input$unif, { rv$data = runif(100)})
 
  output$hist = renderPlot({
    hist(rv$data)
  })
}

shinyApp(ui = ui, server = server)

#clicking the button overrides the "rv$data" (input$norm or input$unif)

#<Recap of reactiveValues()>
# - creates a list of reactive values
# - you can manipulate these values programmatically (usually with observeEvent())


#<< Parting Tips >>
#1. Reduce repetition - place code where it will be re-run as little as necessary
# - Code outside the SERVER function will be run once PER R SESSION (worker)
# - Code inside the SERVER function will be run once PER END USER (connection)
# - Code inside the REACTIVE function will be run once PER REACTION (e.g. many times)
#    -> You should put the bare minimum code inside the render function.

#2. How can R possibly implement reactivity?
#How to understand reactivity in R.
#Link: http://shiny.rstudio.com/articles/understanding-reactivity.html

#Helpful Link: The Shiny Development Center
#Link: shiny.rstudio.com

#This is the End of Part 2.