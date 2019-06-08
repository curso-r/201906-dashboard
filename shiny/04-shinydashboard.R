library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  title = "abcd",
  dashboardHeader(title = HTML(paste(icon("user"), "titulo"))),
  dashboardSidebar(
    textInput("titulo", label = "Título do gráfico", placeholder = "Título"),
    sliderInput("slider", min = 1, max = 30, value = 5, label = "# bins")
  ),
  dashboardBody(
    fluidRow(
      box(
        title = "Histograma",
        status = "warning",
        solidHeader = TRUE,
        collapsible = TRUE,
        collapsed = TRUE,
        plotOutput("histogram") 
      ),
      box(
        title = "Histograma2",
        status = "warning",
        solidHeader = TRUE,
        collapsible = TRUE,
        collapsed = TRUE,
        plotOutput("histogram2") 
      )
    )
  )
)

server <- function(input, output) {
  output$histogram <- renderPlot({
    hist(mtcars$mpg, breaks = input$slider, main = input$titulo)
  })
  
  output$histogram2 <- renderPlot({
    hist(mtcars$drat, breaks = input$slider, main = input$titulo)
  })
}

shinyApp(ui, server)

# Exercício. Adicione os mesmos inputs e histogramas que você precisou adicionar
# no arquivo anterior (03-adicionando-inputs).