#7.12.2019

#My Notes on <Part 3 - How to Customize Appearance>.
#In the Entire Tutorial video, Part 3 runs from 1:32:41 to 2:25


## Add Static Content ##
#HTML tags.
#R functions: 
# tags$h1() <-> <h1></h1>
# tags$a() <-> <a></a>

#List of tags elements.
names(tags)

#Tags Syntax
#1. The list named tags
#2. The function/tag name (followed by parentheses)
#3. Named arguments appear as tag attributes (set boolean attributes to NA)
#4. Unnamed arguments appear inside the tags

#EXAMPLES)

#a()
#hyperlink with the href argument
ui = fluidPage(
  tags$a(href= "http://github.com/git",
         "GitHub")
)
shinyApp(ui = ui, server = server)

#text
fluidPage(
  "This is a Shiny app.",
  "It is also a web page."
)

#p() - a new paragraph
fluidPage(
  tags$p("This is a Shiny app."),
  tags$p("It is also a web page.")
)

#em() - emphasized (italic) text
fluidPage(
  tags$em("This is a Shiny app.")
)

#strong() - bold text
#code() - monospaced text (code)

#Nesting
fluidPage(
  tags$p("This is a",
         tags$strong("Shiny"),
         "app.")
)

#br() - a line break
fluidPage(
  "This is a Shiny app.",
  tags$br(),
  "It is also a web page."
)

#hr() - a horizontal rule (line)
#img() - add an image. Use src argument to point to the image URL

#**adding your own images from the computer
#Save the file in a subdirectory (under App-directory folder) named www

#Raw HTML - Use HTML() to pass a character string as raw HTML
fluidPage(
  HTML("<h1>My Shiny App</h1>")
)
 # Recap: Static Elements #
#Add elements with the tags$ functions
#Unnamed arguments are passed into HTML tags
#Named arguments are passed as HTML tag attributes
#Add raw html with HTML()


## Layout Functions ##

#Add HTML that divides the UI into a grid.

fluidRow() #"horizontal strip".
#ui = fluidPage(
#  fluidRow()
#  fluidRow()
#)
column(width = 2)
#creates a space inside of the row that has a certain width
#each new column goes to the L of the previous column.
ui = fluidPage(
  fluidRow(
    column(3),
    column(5)),
  fluidRow(
    column(4, offset = 8)
))

## Panels ##
#Panels group multiple elements into a single unit with its own properties.

#wellPanel() - Group elements into a grey "well"

#<Three methods involved with stacking>

#1) tabPanel() - creates a stackable layer of elements. Each tab is like a small UI on its own
#tabPanel("A title", whatever elements to appear in the tab)
#Combine tabPanel() with...

#2) tabsetPanel() - combines tabs into a single panel. Use TABS to navigate between tabs.

#3) navlistPanel() - combines tabs into a single panel. Use LINKS to navigate between tabs


## Prepackaged Layouts ##
#use with sidebarPanel() and mainPanel() to divide app into two sections.
ui = fluidPage(
  sidebarLayout(
    sidebarPanel(),
    mainPanel()
  )
)
#fixedPage() - creates a page that defaults to a width of 724, 940, or 1170 pixels
#use with fixedRow() - to create a fixed (non-fluid design)

#navbarPage() - combines tabs into a single page. Replaces fluidPage(). Requires title
#navbarmenu() - helper function that lets you put even more tabs into a navbar.

#use the shinyDashboard package to create dashboard layouts


## Style with CSS ##
#Cascading Style Sheets (CSS) - a framework for customizing the appearance of elements in a web page.

#Style a web page in three ways: 
#1. Link to an external CSS file
#Or place a link in the app's header with to the file with tags$head() and tags$link()

#2. Write global CSS in header -> tags$head() and tags$style() and HTML(). 
#Or save the CSS as a file in your app directory and include it with includeCSS()

#3. Write individual CSS in a tag's style attribute
#Set the style argument in Shiny's tag functions

#Match styling to:
#1. Tag
#2. Class
#3. id

#Hierarchi 3->2->1

#** Shiny uses the Bootstrap 3 CSS framework
#getbootstrap.com

#Link to an external CSS file?
#Place .css file in the www folder of your app directory


## **To learn more about CSS & HTML
#http://www.codecademy.com/tracks/web


