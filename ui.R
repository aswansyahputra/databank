ui <- tagList(
  useShinyjs(),
  inlineCSS(
    "
    #loading-content {
    position: absolute;
    background: #FFFFFF;
    opacity: 0.9;
    z-index: 100;
    left: 0;
    right: 0;
    height: 100%;
    text-align: center;
    }
    "
  ),
  div(
    id = "loading-content",
    h2("Loading...")
  ),
  hidden(
    div(
      id = "app-content",
      navbarPage(
        "Data Bank",
        theme = shinytheme("cerulean"),
        navbarMenu(
          "What do you want to know?",
          tabPanel(
            "Tell me about Rock!",
            serveDataUI("rock", "Handful of Rock")
          ),
          tabPanel(
            "Tell me about Pressure!",
            serveDataUI("pressure", "Under Pressure")
          )
        ),
        tabPanel(
          "About",
          icon = icon("support"),
          includeMarkdown("README.md")
        )
      )
    )
  )
)
