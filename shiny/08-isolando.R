library(shiny)
library(shinydashboard)
library(dplyr)
library(DT)
library(highcharter)

dados <- readRDS("../dados/credit.rds")

options(shiny.reactlog = TRUE)

ui <- dashboardPage(
  dashboardHeader(title = "Credit Dashboard"),
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
      value = c(min(dados$renda), max(dados$renda))
    ),
    checkboxInput("renda_na", label = "Considerar renda NA", value = TRUE),
    actionButton("go", "Filtrar!")
  ),
  dashboardBody(
    fluidRow(
      box(
        title = "Dados",
        dataTableOutput("tabela")
      ),
      box(
        title = "Status",
        highchartOutput("status")
      )
    )
  )
)

server <- function(input, output) {
  
  dados_filtrados <- eventReactive(input$go, {
    dados %>% 
      filter(idade >= input$idade[1], idade <= input$idade[2]) %>% 
      filter(coalesce(trabalho, "NA") %in% input$trabalho) %>% 
      filter(
        ((renda >= input$renda[1]) | is.na(renda)) &
          ((renda <= input$renda[2]) | is.na(renda)) &
          (is.na(renda) %in% c(FALSE, input$renda_na))
      )
  }, ignoreNULL = FALSE)
  
  output$tabela <- renderDataTable({
    datatable(dados_filtrados(), options = list(scrollX = TRUE))
  })
  
  output$status <- renderHighchart({
    hcpie(dados_filtrados()$status)
  })
  
}

shinyApp(ui, server)

# Exercício final.