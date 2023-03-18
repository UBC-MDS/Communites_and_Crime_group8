library(shinytest2)

test_that("{shinytest2} recording: base_test", {
  app <- AppDriver$new(variant = platform_variant(), name = "base_test", height = 737, 
      width = 1169)
  app$expect_screenshot()
})



test_that("{shinytest2} recording: cali_map", {
  app <- AppDriver$new(variant = platform_variant(), name = "cali_map", height = 737, 
      width = 1169)
  app$set_inputs(state = character(0))
  app$set_inputs(state = "California")
  app$expect_screenshot()
})



test_that("{shinytest2} recording: colo_scatter", {
  app <- AppDriver$new(variant = platform_variant(), name = "colo_scatter", height = 737, 
      width = 1169)
  app$set_inputs(main_page = "Correlation")
  app$set_inputs(corr_plot = "Colorado")
  app$expect_screenshot()
})



test_that("{shinytest2} recording: base_scatter", {
  app <- AppDriver$new(variant = platform_variant(), name = "base_scatter", height = 737, 
      width = 1169)
  app$set_inputs(main_page = "Scatter")
  app$expect_screenshot()
})

