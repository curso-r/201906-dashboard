library(shiny)
library(shinydashboard)
library(dplyr)
library(DT)
library(highcharter)

dados <- readRDS("dados/credit.rds")

ui <- dashboardPage(
  dashboardHeader(title = "Credit"),
  dashboardSidebar(
    sliderInput(
      inputId = "idade", 
      label = "Idade:",
      min = min(dados$idade), 
      max = max(dados$idade), 
      value = c(min(dados$idade), max(dados$idade))
    ),
    selectizeInput(
      inputId = "trabalho", 
      label = "Trabalho",
      choices = unique(dados$trabalho),
      selected = unique(dados$trabalho),
      multiple = TRUE
    ),
    sliderInput(
      inputId = "renda", 
      label = "Renda:",
      min = min(dados$renda, na.rm = TRUE), 
      max = max(dados$renda, na.rm = TRUE), 
      value = c(min(dados$renda, na.rm = TRUE), max(dados$renda, na.rm = TRUE))
    ),
    checkboxInput("renda_na", label = "Considerar renda NA", value = TRUE),
    selectizeInput(
      inputId = "tipo_de_moradia", 
      label = "Tipo de moradia",
      choices = unique(dados$moradia),
      selected = unique(dados$moradia),
      multiple = TRUE
    )
  ),
  dashboardBody(
    fluidRow(
      column(
        width = 6,
        box(
          width = 12,
          title = "Dados",
          dataTableOutput("tabela")
        ),
        box(
          width = 12,
          title = "Histograma",
          plotOutput("histograma_preco")
        )
      ),
      column(offset = 0,
        width = 6,
        box(
          offset = 0,
          width = 12,
          title = "Status",
          highchartOutput("status")
        ),
        box(
          width = 12,
          title = "Histograma2",
          highchartOutput("histograma_trabalho")
        )
      )
    )
  )
)

server <- function(input, output) {
  
  dados_filtrados <- reactive({
    input$renda
    dados %>% 
      filter(idade >= input$idade[1], idade <= input$idade[2]) %>% 
      filter(coalesce(trabalho, "NA") %in% input$trabalho) %>% 
      filter(
        ((renda >= input$renda[1]) | is.na(renda)) &
          ((renda <= input$renda[2]) | is.na(renda)) &
          (is.na(renda) %in% c(FALSE, input$renda_na))
      ) %>% 
      filter(coalesce(moradia, "NA") %in% input$tipo_de_moradia)
  })
  
  output$tabela <- renderDataTable({
    datatable(dados_filtrados(), options = list(scrollX = TRUE))
  })
  
  output$status <- renderHighchart({
    hcpie(dados_filtrados()$status, name = "")
  })
  
  output$histograma_preco <- renderPlot({
    ggplot2::qplot(dados_filtrados()$preco_do_bem, geom="histogram")
  })
  
  output$histograma_trabalho <- renderHighchart({
    hchist(dados_filtrados()$valor_emprestimo)
  })
  
}

shinyApp(ui, server)

# Exercício 1. Adicione mais algum atributo para filtrar a base de dados.
# Exercício 2. Faça 2 gráficos da sua escolha em boxes na parte inferior.