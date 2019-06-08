library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  titlePanel("Olá Mundo"),
  fluidRow(
    plotOutput("histogram")
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  output$histogram <- renderPlot({
    hist(mtcars$mpg)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

# Exercício! Adicione o histograma da variável hp.