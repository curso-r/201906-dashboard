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
    )
  ),
  dashboardBody(
    fluidRow(
      box(
        width = 4,
        title = "Imagem",
        htmlOutput("img")
      ),
      box(
        width = 4,
        title = "Atributos",
        valueBoxOutput("ataque", width = 12)
      )
    )
  )
)

server <- function(input, output) {
  
  pokemon_dados <- reactive({
    dados %>% 
      filter(pokemon == input$pokemon) %>% 
      as.list()
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
}

shinyApp(ui, server)

# Exercício. Adicone os atributos que você tinha adicionado no exercício do
# arquivo anterior. Desta vez usando a expressão reativa.