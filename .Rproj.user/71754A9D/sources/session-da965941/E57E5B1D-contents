

library(shiny)
library(httr2)
library(log4r)

api_url <- "http://127.0.0.1:46261/predict"
log <- log4r::logger()

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Penguin Mass Predictor App"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("bill_length",
                        "Bill Length (mm):",
                        min = 30,
                        max = 60,
                        value = 45,
                        step = 0.1
                        ),
            selectInput("sex",
                        "Sex",
                        c("Male", "Female")
                        ),
            selectInput("species",
                       "Species",
                       c("Adelie", "Chinstrap", "Gentoo")
                       ),
            actionButton("predict",
                         "Predict"
                         )
                    
        ),

        mainPanel(
          h2("Penguin Parameters"),
          verbatimTextOutput("vals"),
          h2("Predicted Penguin Mass (g)"),
          textOutput("pred")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  log4r::info(log, "App Started")
#input params
  vals <- reactive(
    data.frame(
      bill_length_mm = input$bill_length,
      species = input$species,
      sex = tolower(input$sex)
    )
  )
  
# Fetch prediction from API
  pred <- eventReactive(
    input$predict,
    {
    log4r::info(log, "Prediction Requested")
    r <- httr2::request(api_url) |>
      httr2::req_body_json(vals()) |>
      httr2::req_perform()
    log4r::info(log, "Preduction Returned")
    
    if (httr2::resp_is_error(r)) {
      log4r::error(log, paste("HTTP Error"))
    }
    
    httr2::resp_body_json(r)
  },
    ignoreInit = TRUE
  )
  
  # Render to UI
  output$pred <- renderText(pred()$.pred[[1]])
  output$vals <- renderPrint(vals())
  
}
  
# Run the application 
shinyApp(ui = ui, server = server)
