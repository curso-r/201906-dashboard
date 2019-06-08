library(shiny)
library(shinydashboard)
library(dplyr)

dados <- readRDS("dados/pkmn.rds")

lista_pokemon <- as.list(dados$pokemon)
names(lista_pokemon) <- stringr::str_to_title(lista_pokemon)

ui <- dashboardPage(
  dashboardHeader(title = "Pokemon"),
  dashboardSidebar(
    selectizeInput(
      inputId = "pokemon", 
      choices = lista_pokemon, 
      label = "Selecione um Pokemon",
      selected = "bulbasaur"
    ),
    selectizeInput(
      inputId = "tipo",
      choices = unique(dados$tipo_1),
      label = "Selecione um tipo",
      selected = unique(dados$tipo_1)[1]
    )
  ),
  dashboardBody(
    fluidRow(
      box(
        width = 4,
        title = textOutput("a"),
        htmlOutput("img")
      ),
      box(
        width = 6,
        title = "Atributos",
        valueBoxOutput("ataque", width = 12),
        valueBoxOutput("defesa", width = 12),
        valueBoxOutput("altura", width = 12),
        valueBoxOutput("altura_media", width = 12)
      )
    )
  )
)

server <- function(input, output) {
  
  pokemon_dados <- reactive({
    d <- dados %>% 
      filter(pokemon == input$pokemon) %>% 
      as.list()
    d
  })
  
  dados_tipo <- reactive({
    d <- dados %>% 
      filter(tipo_1 == pokemon_dados()$tipo_1)
    #browser()
    d
  })
  
  output$altura_media <- renderValueBox({
    valueBox(
      value = round(mean(dados_tipo()$altura), 2),
      subtitle = "Média da altura"
    )
  })
  
  output$img <- renderText({
    url <- pokemon_dados()$url_imagem
    glue::glue("<img width = 100% src='https://raw.githubusercontent.com/phalt/pokeapi/master/data/Pokemon_XY_Sprites/{url}'>")
  })
  
  output$ataque <- renderValueBox({
    valueBox(
      value = pokemon_dados()$ataque,
      subtitle = "Ataque"
    )
  })
  
  output$defesa <- renderValueBox({
    valueBox(
      value = pokemon_dados()$defesa,
      subtitle = "Defesa"
    )
  })
  
  output$altura <- renderValueBox({
    valueBox(
      value = pokemon_dados()$altura,
      subtitle = "Altura"
    )
  })
  
  output$a <- renderText({input$pokemon})
}

shinyApp(ui, server)

# Exercício. Adicone os atributos que você tinha adicionado no exercício do
# arquivo anterior. Desta vez usando a expressão reativa.