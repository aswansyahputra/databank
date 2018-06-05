library(shiny)
library(shinythemes)
library(shinyjs)
library(shinyWidgets)
library(shinycssloaders)
library(tidyverse)
library(DT)
library(plotly)
library(ggcorrplot)
library(summarytools)

invisible(map(list.files("./modules", full.names = TRUE), source))
# invisible(map(list.files("./helpers", full.names = TRUE), source))

rock <- read_delim("./data/data_rock.csv", delim = ";")

pressure <- read_delim("./data/data_pressure.csv", delim = ";")
