## ui.R ##
library(shiny)
library(shinydashboard)
library(ggplot2)
library(gridExtra)
library(devtools)
library(rCharts)

sidebar <- dashboardSidebar(
  # Decimal interval with step value
  sliderInput("sample_size", "Sample Size:", min = 100, max = 2000, value = 1000, step= 100),
  sidebarMenu(
   menuItem("Correlation", tabName = "Correlation", icon = icon("th")),
   menuItem("Bootstrapping", icon = icon("bar-chart"), tabName = "Bootstrapping")
  )

#   disable = TRUE
)

body <- dashboardBody(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "main.css")
  ),
  tabItems(
    tabItem(tabName = "Correlation",
      # Boxes need to be put in a row (or column)
      fluidRow(
        # Dynamic valueBoxes
        valueBoxOutput("correlationBox"),
        valueBoxOutput("CI")
      ),
      fluidRow(
        box(
          title = "Correlation Scatterplot", width = 9, solidHeader = TRUE, status = "primary",
          plotOutput("plot1")
        ),
        box(
          title = "File Upload", width = 3, solidHeader = TRUE,collapsible = TRUE, status = "warning",
          fileInput('file1', 'Choose file to upload',
            accept = c(
              'text/csv',
              'text/comma-separated-values',
              'text/tab-separated-values',
              'text/plain',
              '.csv',
              '.tsv'
            ),
            multiple=FALSE
          ),
          checkboxInput('header', 'Header', TRUE),
          radioButtons('sep', 'Separator',
            c(Comma=',',
            Semicolon=';',
            Tab='\t'),
            ','
          ),
          radioButtons('quote', 'Quote',
            c(None='',
            'Double Quote'='"',
            'Single Quote'="'"),
            '"'
          ),
          tags$hr()
        )       
      )
    ),
    tabItem(tabName = "Bootstrapping",
      fluidRow(
        box(
          title = "Correlation CI Graph", width = 9, solidHeader = TRUE, status = "primary",
          plotOutput("bootGraph")
        )
      )
    )
  )
)

dashboardPage(
  skin = "blue",
  dashboardHeader(title = "Correlation Calculator"),
  sidebar,
  body
)