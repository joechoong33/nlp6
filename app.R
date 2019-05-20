require(visNetwork)
require(shiny)
dfnet <- read.csv('ng.csv',header=T,stringsAsFactors = F)
dfnet <- dfnet[1:20,]
nodes <- data.frame(id = unique(dfnet$term1), label = unique(dfnet$term1),
                    group = unique(dfnet$term1))

edges <- data.frame(from = dfnet$term1, to = dfnet$term2)

server <- function(input, output, session) {
  output$network <- renderVisNetwork({
    visNetwork(nodes, edges, 
               height = "100%", width = "100%",
               main = "") %>%
      visEvents(click = "function(nodes){
                Shiny.onInputChange('click', nodes.nodes[0]);
                ;}"
      )
})
  
  output$shiny_return <- renderPrint({
    visNetworkProxy("network") %>%
      visNearestNodes(target = input$click)
  })
  }

ui <- fluidPage(
  visNetworkOutput("network"), 
  verbatimTextOutput("shiny_return")  
)

shinyApp(ui = ui, server = server)