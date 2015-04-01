## ui.R ##
library(shiny)
library(shinydashboard)
library(ggplot2)
library(gridExtra)
library(devtools)

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Correlation", tabName = "Correlation", icon = icon("th")),
    menuItem("Bootstrapping", icon = icon("bar-chart"), tabName = "Bootstrapping"),
    menuItem("Table View", icon = icon("file-image-o"), tabName = "TableView")
  ),
  sliderInput("sample_size", "Sample Size:", min = 100, max = 5000, value = 1000, step= 100),
  mainPanel(
    tags$br(),
    tags$br(),
    tags$br(),
    tags$br(),
    tags$br(),
    tags$br(),
    tags$br(),
    tags$br(),
    h1("Instructions"),
    tags$ul(
        tags$li("Upload a File"),
        tags$li("Ensure file is 2 columns with a header i.e.")
      ),
    imageOutput("myImage", height=100)
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
          title = "Correlation Bootstrap Graph", width = 12, solidHeader = TRUE, status = "primary",
          plotOutput("bootGraph")
        )
      )
    ),
    tabItem(tabName = "TableView",
      fluidRow(
        box(
          title = "Table View", width = 12, solidHeader = TRUE, status = "primary",
          dataTableOutput("datatable")
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