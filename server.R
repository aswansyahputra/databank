server <- function(input, output) {
  hide(id = "loading-content", anim = TRUE, animType = "fade")
  show("app-content")
  callModule(serveData, "rock", data = reactive(rock))
  callModule(serveData, "pressure", data = reactive(pressure))
}
