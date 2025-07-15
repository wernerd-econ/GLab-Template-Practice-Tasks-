# =============================================================================
# Short description of script's purpose
# =============================================================================

library(tidyverse)
library(stargazer)
library(ggplot2)
library(lfe)

# Paths
input_dir <- "../../1_data/output"
output_dir <- "../output"

# =============================================================================

main <- function() {
  load("../input/mpg.Rdata")
  regression_table(mpg_clean)
  city_figure(mpg_clean)
  hwy_figure(mpg_clean)
}

regression_table <- function(data) {
  reg_cty <- felm(displ ~ cty | 0 | 0 | year, data = data)
  cty_se <- summary(reg_cty)$coefficients[, "Cluster s.e."]

  reg_hwy <- felm(displ ~ hwy | 0 | 0 | year, data = data)
  hwy_se <- summary(reg_hwy)$coefficients[, "Cluster s.e."]

  reg_hwy_cty <- felm(displ ~ hwy + cty | 0 | 0 | year, data = data)
  hwy_cty_se <- summary(reg_hwy_cty)$coefficients[, "Cluster s.e."]

  stargazer(reg_cty, reg_hwy, reg_hwy_cty, 
            se = list(cty_se, hwy_se, hwy_cty_se),
            title = "Results (Clustered SE)", align = TRUE,
            dep.var.labels = c("Engine displacement (L)"),
            covariate.labels = c("City fuel economy (mpg)",
                                 "Highway fuel economy (mpg)"),
            float = FALSE,
            out = "../output/table_reg.tex")
}

city_figure <- function(data) {
  data <- data %>% mutate(log_cty = log(cty))
  p <- ggplot(data, aes(x = displ, y = log_cty, color = year)) +
    geom_point() +
    xlab("Engine displacement (L)") +
    ylab("Log of city fuel economy (mpg)")
  ggsave("../output/figure_city.jpg", plot = p)
}

hwy_figure <- function(data) {
  data <- data %>% mutate(log_hwy = log(hwy))
  p <- ggplot(data, aes(x = displ, y = log_hwy, color = year)) +
    geom_point() +
    xlab("Engine displacement (L)") +
    ylab("Log of highway fuel economy (mpg)")
  ggsave("../output/figure_hwy.jpg", plot = p)
}

# Execute
main()
