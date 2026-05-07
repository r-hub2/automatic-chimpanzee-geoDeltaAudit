test_that("prep_hud_crosswalk stops when required columns are missing", {
  bad_df <- data.frame(wrong_col = 1:3)
  
  expect_error(
    prep_hud_crosswalk(bad_df),
    "HUD crosswalk missing required columns"
  )
})