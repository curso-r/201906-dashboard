library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Olá Mundo"),
  dashboardSidebar(
    sliderInput("slider", min = 1, max = 30, value = 5, label = "# bins")
  ),
  dashboardBody(
    box(
      title = "Histograma",
      plotOutput("histogram") 
    )
  )
)

server <- function(input, output) {
  output$histogram <- renderPlot({
    hist(mtcars$mpg, breaks = input$slider)
  })
}

shinyApp(ui, server)

# Exercício. Adicione os mesmos inputs e histogramas que você precisou adicionar
# no arquivo anterior (03-adicionando-inputs).