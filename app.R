library(shiny)
library(maps)
library(mapproj)
source("helpers.R")
counties <- readRDS("counties.rds")

ui <- fluidPage(
  titlePanel("Coursera Data Products class - Census visualization tool"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Create demographic maps with 
               information from the 2010 US Census.  Use the click down menus and the sliders to select the data to display."),
      
      selectInput("var1", 
                  label = "Choose a variable to display:",
                  choices = c("Percent White", "Percent Black",
                              "Percent Hispanic", "Percent Asian"),
                  selected = "Percent White"),
      
      sliderInput("range1", 
                  label = "Range:",
                  min = 0, max = 100, value = c(0, 100)),
      
    selectInput("var2", 
                label = "Choose a variable to display:",
                choices = c("Percent Hispanic", "Percent Asian", "Percent White", "Percent Black"),
                selected = "Percent Hispanic"),
    
    sliderInput("range2", 
                label = "Range:",
                min = 0, max = 100, value = c(0, 100))
  ),
    
    mainPanel(fluidRow(splitLayout(cellWidths = c("50%", "50%"), plotOutput("map"), plotOutput("map2"))))
  )
)
server <- function(input, output) {
  output$map <- renderPlot({
    args <- switch(input$var1,
                   "Percent White" = list(counties$white, "darkgreen", "% White"),
                   "Percent Black" = list(counties$black, "blue", "% Black"),
                   "Percent Hispanic" = list(counties$hispanic, "darkorange", "% Hispanic"),
                   "Percent Asian" = list(counties$asian, "darkviolet", "% Asian"))
    
    args$min <- input$range1[1]
    args$max <- input$range1[2]
    
    do.call(percent_map, args)
  })
    output$map2 <- renderPlot({
      args <- switch(input$var2,
                     "Percent White" = list(counties$white, "darkgreen", "% White"),
                     "Percent Black" = list(counties$black, "blue", "% Black"),
                     "Percent Hispanic" = list(counties$hispanic, "darkorange", "% Hispanic"),
                     "Percent Asian" = list(counties$asian, "darkviolet", "% Asian"))
      
      args$min <- input$range2[1]
      args$max <- input$range2[2]
      
      do.call(percent_map, args)
  })
}

shinyApp(ui = ui, server = server)