library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
    titlePanel("Olá Mundo"),
    HTML("<h3> Olá </h3>")
)

# Define server logic required to draw a histogram
server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)
