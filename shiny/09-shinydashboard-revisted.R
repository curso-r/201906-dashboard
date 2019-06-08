library(shiny)
library(shinydashboard)

dados <- readRDS("../dados/imdb.rds")

ui <- dashboardPage(
  dashboardHeader(title = "IMDB"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Filmes", tabName = "filmes", icon = icon("dashboard")),
      menuItem("Diretores", tabName = "diretores", icon = icon("user"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "filmes",
        fluidRow(
          box(
            title = "Filmes",
            selectizeInput(
              inputId = "filme", 
              label = "Selecione um filme", 
              choices = unique(dados$titulo)
            )
          ),
          box(
            title = "Resultados",
            valueBoxOutput("filme_receita", width = 12),
            valueBoxOutput("filme_orcamento", width = 12),
            valueBoxOutput("filme_balanco", width = 12)
          )
        )
      ),
      tabItem(tabName = "diretores"
              
      )
    )
  )
)

server <- function(input, output) {
 
  filme <- reactive({
    dados %>% 
      filter(titulo == input$filme) %>% 
      as.list()
  })
  
  output$filme_receita <- renderValueBox({
    valor <- scales::dollar(filme()$receita)
    valueBox(valor, "Receita")
  })
  
  output$filme_orcamento <- renderValueBox({
    valor <- scales::dollar(filme()$orcamento)
    valueBox(valor, "Orçamento")
  })
  
  output$filme_balanco <- renderValueBox({
    
    if (filme()$balanco > 0)
      cor <- "green"
    else
      cor <- "red"
    
    
    valor <- scales::dollar(filme()$balanco)
    
    valueBox(valor, "Balanço", color =  cor)
  })
  
}

shinyApp(ui, server)

# Exercício. Adicione um input e um output na aba dos diretores.