## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  echo = TRUE,
  message = FALSE,
  warning = FALSE
)

## ----libs, message=FALSE, warning=FALSE---------------------------------------
library(geoDeltaAudit)
library(dplyr)
library(stringr)
library(janitor)

## ----assoc-build, message=FALSE, warning=FALSE--------------------------------
## --- load toy baseline (relationship-defined) ---
acs_path <- system.file("extdata", "toy_acs_zcta_hennepin.csv", package = "geoDeltaAudit")
stopifnot(nchar(acs_path) > 0)

acs_zcta_hennepin <- readr::read_csv(acs_path, show_col_types = FALSE) %>%
  janitor::clean_names() %>%
  dplyr::mutate(zcta = stringr::str_pad(as.character(.data$zcta), 5, pad = "0"))

# Toy assoc: 1:1 ZCTA -> ZIP (same 5-digit IDs)
zcta_zip_hennepin <- acs_zcta_hennepin %>%
  dplyr::distinct(.data$zcta) %>%
  dplyr::transmute(zcta = .data$zcta, zip = .data$zcta) %>%
  dplyr::distinct()

assoc_structure <- zcta_zip_hennepin %>%
  dplyr::summarise(
    n_rows  = dplyr::n(),
    n_zctas = dplyr::n_distinct(.data$zcta),
    n_zips  = dplyr::n_distinct(.data$zip)
  )

assoc_structure

## ----assoc-diagnostics, message=FALSE, warning=FALSE--------------------------
unmapped <- acs_zcta_hennepin %>%
  dplyr::anti_join(zcta_zip_hennepin %>% dplyr::distinct(.data$zcta), by = "zcta")

fanout_stats <- zcta_zip_hennepin %>%
  dplyr::count(.data$zcta, name = "n_zip") %>%
  dplyr::summarise(
    min    = min(.data$n_zip),
    median = median(.data$n_zip),
    mean   = mean(.data$n_zip),
    max    = max(.data$n_zip)
  )

list(
  n_unmapped_zctas = nrow(unmapped),
  fanout = fanout_stats
)

## ----hennepin-pngs, echo=FALSE, message=FALSE, warning=FALSE, results="asis"----
knitr::include_graphics(c(
  "baseline_hennepin.png",
  "hennepin_relationship.png"
))

