library(shiny)
library(shinydashboard)

dados <- readRDS("dados/pkmn.rds")

lista_pokemon <- as.list(dados$pokemon)
names(lista_pokemon) <- stringr::str_to_title(lista_pokemon)

ui <- dashboardPage(
  dashboardHeader(title = "Pokemon"),
  dashboardSidebar(
    tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.css")),
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
        valueBoxOutput("ataque", width = 12),
        valueBoxOutput("defesa", width = 12)
      ),
      box(
        width = 4,
        valueBoxOutput("altura", width = 12)
      )
    )
  )
)

server <- function(input, output) {
  
  output$img <- renderText({
    url <- dados$url_imagem[dados$pokemon == input$pokemon]
    glue::glue(
      "<img width = 100% src='https://raw.githubusercontent.com/phalt/pokeapi/master/data/Pokemon_XY_Sprites/{url}'>"
      )
  })
  
  output$ataque <- renderValueBox({
    valueBox(
      value = dados$ataque[dados$pokemon == input$pokemon], 
      subtitle = "Ataque",icon = tags$i(class="fab fa-suse"),
      color = ifelse(dados$ataque[dados$pokemon == input$pokemon] > 100, "blue", "red")
    )
  })
  
  output$defesa <- renderValueBox({
    valueBox(
      value = dados$defesa[dados$pokemon == input$pokemon], 
      subtitle = "Defesa",icon = tags$i(class="fab fa-suse"),
      color = ifelse(dados$ataque[dados$pokemon == input$pokemon] > 100, "blue", "red")
    )
  })
  
  output$altura <- renderValueBox({
    valueBox(
      value = dados$altura[dados$pokemon == input$pokemon], 
      subtitle = "Altura",icon = tags$i(class="fab fa-suse"),
      color = ifelse(dados$ataque[dados$pokemon == input$pokemon] > 100, "blue", "red")
    )
  })
}

shinyApp(ui, server)

# Exercício. Adicione outros valueBoxes para os demais atributos do pokemon.
# Talvez você queira colocá-los em outros boxes.