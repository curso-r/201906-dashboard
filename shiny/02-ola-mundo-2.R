library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  titlePanel("Olá Mundo"),
  fluidRow(
    column(
      width = 6,
      plotOutput(outputId = "histogram")  
    ),
    column(
      width = 6,
      plotOutput(outputId = "histogram2") 
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  output$histogram <- renderPlot({
    hist(mtcars$mpg)
  })
  
  output$histogram2 <- renderPlot({
    hist(mtcars$hp)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

# Exercício! Adicione o histograma da variável hp.