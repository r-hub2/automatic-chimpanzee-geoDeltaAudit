test_that("clean_geo_headers aborts when required column is missing", {
  bad_df <- data.frame(wrong_col = 1:3, another_col = 4:6)
  
  expect_error(
    clean_geo_headers(
      df   = bad_df,
      map  = c(zip = "zip|zipcode"),
      keep = "zip"
    ),
    "Missing required column"
  )
})