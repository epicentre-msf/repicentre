# Solution script for the Outbreaker2 module of the bayesian inference workshop

# Load packages -----------------------------------------------------------
library(epicontacts)
library(tidyverse)

# Load data ----------------------------------------------------

#all data
dat <- readRDS(here::here("data", "clean", "simulated_evd_data.rds"))

# Epicontacts -------------------------------------------------------------

epi_tree <- make_epicontacts(
  linelist = dat$evd_linelist,
  contacts = dat$evd_chain,
  id = "id",
  from = "from",
  to = "to",
  directed = TRUE
)

epi_tree


# Basic Visualisation ---------------------------------------------------

plot(epi_tree)

# add colors
plot(epi_tree, node_color = "classification", edge_width = 5)

# add shapes and width
plot(
  epi_tree,
  node_color = "sex",
  edge_width = 5,
  node_shape = "sex",
  node_size = 40,
  shapes = c(male = "male", female = "female")
)


# Temporal Visualisation -----------------------------------------------------------

plot(
  epi_tree,
  x_axis = "t_inf",
  n_breaks = 10,
  node_color = "classification",
  edge_width = 5
)

# move to rectangle
plot(
  epi_tree,
  x_axis = "t_inf",
  n_breaks = 10,
  network_shape = "rectangle",
  parent_pos = "top",
  position_dodge = TRUE,
  node_color = "classification",
  edge_width = 5
)

# Timelines Visualisation ----------------------------------------------------------

timeline <- epi_tree$linelist |>
  transmute(
    id,
    start = t_onset,
    end = t_outcome,
    classification,
    outcome = outcome,
    hospitalised,
    health_zone
  )

shapes <- c(
  dead = "asterisk",
  recovered = "heartbeat"
)

## define colours
colours <- c(
  "confirmed" = "#c5283d",
  "probable" = "#e9724c",
  "suspected" = "#ffc857",
  "non-case" = "#377771",
  "NA" = "grey"
)

tree <- plot(
  epi_tree,
  x_axis = "t_onset",
  n_breaks = 10,
  network_shape = "rectangle",
  parent_pos = "top",
  position_dodge = TRUE,
  node_color = "classification",
  timeline = timeline,
  tl_end_node_shape = "outcome",
  tl_edge_color = "health_zone",
  tl_edge_width = 10,
  tl_edge_label = "id",
  shapes = shapes,
  col_pal = colours,
  arrow_size = 0.5,
  height = 1500,
  width = 1200,
  label = FALSE
)

tree

# Save the trees

saveRDS(tree, "output/timeline_tree.rds")
visNetwork::visSave(tree, "output/timeline_tree.html")
webshot::webshot(
  url = "output/timeline_tree.html",
  file = "output/timeline_tree.png"
)

# Extra challenge ---------------------------------------------------------

# add contact type to the default tree visualisation
# we need to join the contact data type to the consensus tree - when a link is present we add the type of contact

#contact data
dat$evd_contact

#add contact type to consensus tree if available
type_tree <- dat$evd_chain |>
  mutate(across(c(to, from), ~ as.character(.x))) |>
  left_join(dat$evd_contact, by = c("from", "to"))

#make epicontact
epi_tree <- make_epicontacts(
  linelist = dat$evd_linelist,
  contacts = type_tree,
  id = "id",
  from = "from",
  to = "to",
  directed = TRUE
)

#visualise with edge colorise by contact type
plot(
  epi_tree,
  node_color = "classification",
  edge_color = "type_contact",
  edge_width = 10
)
