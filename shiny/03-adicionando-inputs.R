library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  titlePanel("Olá Mundo"),
  fluidRow(
    column(
      width = 4,
      sliderInput("slider", min = 1, max = 30, value = 5, label = "# bins")
    ),
    column(
      width = 8,
      plotOutput("histogram") 
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  output$histogram <- renderPlot({
    hist(mtcars$mpg, breaks = input$slider)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

# Exercício 1. Adicione um inpout para controlar também título do gráfico.
# Você pode usar a função textInput.

# Exercício 2. Adicione mais uma linha com o histograma da variável drat.
# O número de breaks deste histograma deve ser controlado pelo mesmo
# slider do outro histograma.