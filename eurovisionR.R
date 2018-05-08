library(shiny)
countries <- paste(rep('generic european country', 26), LETTERS[1:26])

# Define UI for miles per gallon app ----
ui <- fluidPage(
  
  # App title ----
  headerPanel("Eurovision party support generator"),
  
  # Sidebar panel for inputs ----
  sidebarPanel(
    # Input: Selector for variable to plot against mpg ----
    sliderInput("n_countries", "Number of countries per viewer:",
                min = 1, max = 5,
                value = 1),
      textInput('viewers', 'Enter the viewers names separated by commas', "Chad, Eric, Donald, Huw", width = '800px')
    
  ),
  
  # Main panel for displaying outputs ----
  mainPanel(
    print("Give the names of the people at your party, we'll tell you who they should support. The countries list will be updated once the finalists are announced!"),
    DT::dataTableOutput("mytable"),
    
    print("This code uses the names input to allocate a random non-overlapping subset of the potential countries to each viewer\nCode available at https://github.com/hemprichbennett/eurovisionR")
  )
)

# Define server logic to plot various variables against mpg ----
server <- function(input, output) {
  
    
    output$mytable <- DT::renderDataTable({
      viewers <- strsplit(input$viewers, split = ',')[[1]]
      viewers <- gsub(' ', '', viewers)

      rooting_for <- list()
      for(i in 1:length(viewers)){
        viewer <- viewers[i]
        nums <- sample(1:length(countries), input$n_countries)
        rooting_for[[viewer]] <- countries[nums]
        countries <- countries[-nums]
      }
      
      roots_df <- as.data.frame(rooting_for)
      
      print(roots_df)
    })
    
    
  
}

shinyApp(ui, server)
