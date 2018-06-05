serveDataUI <- function(id, heading = "Data") {
  ns <- NS(id)
  
  tagList(
    fluidPage(
      h1(heading),
      tabsetPanel(
        tabPanel(
          "Data",
          icon = icon("table"),
          br(),
          withSpinner(DT::dataTableOutput(ns("data")), type = 4, color = "#44ade9")
        ),
        tabPanel(
          "Summary",
          icon = icon("dashboard"),
          br(),
          sidebarLayout(
            sidebarPanel(
              tagList(icon = icon("sliders", "fa-2x")),
              br(),
              radioButtons(
                ns("profile"),
                "Please select profile of interest",
                choices = c(
                  "All",
                  "Country"
                )
              ),
              conditionalPanel(
                condition = "input.profile == 'Country'",
                ns = ns,
                pickerInput(
                  ns("country"),
                  "Please select Country of intereset",
                  choices = NULL,
                  multiple = TRUE,
                  options = list(
                    "actions-box" = TRUE
                  )
                )
              ),
              actionButton(ns("apply"), "Apply")
            ),
            mainPanel(
              h3("Summary Table"),
              withSpinner(htmlOutput(ns("summary")), type = 4, color = "#44ade9")
            )
          )
        ),
        tabPanel(
          "Time Series Plot",
          icon = icon("image"),
          br(),
          sidebarLayout(
            sidebarPanel(
              "This is sidebar"
            ),
            mainPanel(
              "This is main panel"
            )
          )
        )
      )
    )
  )
}

serveData <- function(input, output, session, data) {
  ns <- session$ns
  
  # Data ----
  output$data <- DT::renderDataTable({
    data() %>%
      datatable(
        rownames = FALSE,
        extensions = c("Scroller", "Buttons"),
        options = list(
          dom = "Brti",
          autoWidth = FALSE,
          scrollX = TRUE,
          deferRender = TRUE,
          scrollY = 300,
          scroller = TRUE,
          buttons =
            list(
              list(
                extend = "copy"
              ),
              list(
                extend = "collection",
                buttons = c("csv", "excel"),
                text = "Download"
              )
            )
          ,
          initComplete = JS(
            "function(settings, json) {",
            "$(this.api().table().header()).css({'background-color': '#44ade9', 'color': '#fff'});",
            "}"
          )
        )
      )
  },
  server = FALSE
  )
  
  # Summary ----
  observeEvent(input$profile == "Country", {
    updatePickerInput(
      session = session,
      inputId = "country",
      choices = unique(data()$Country)
    )
  }, 
  ignoreInit = TRUE
  )
  
  observe({
    toggleState(
      id = "apply",
      condition = input$profile == "All" | {input$profile == "All" | !is.null(input$country)}
    )
  })
  
  df <- eventReactive(input$apply, {
    if (input$profile == "All") {
      data()
    } else if (input$profile == "Country") {
      data() %>% 
        filter(Country %in% input$country)
    }
  })
  
  output$summary <- renderUI({
    print(dfSummary(df(), varnumbers = FALSE, graph.magnif = 0.8, style = "multiline"),
          method = "render",
          omit.headings = TRUE,
          bootstrap.css = FALSE,
          custom.css = "./www/custom-summarytools.css",
          footnote = NA
    )
  })
  
  
  # Time Series plot
}