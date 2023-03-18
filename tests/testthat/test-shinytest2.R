library(shinytest2)



test_that("{shinytest2} recording: cali_map", {
  app <- AppDriver$new(variant = platform_variant(), name = "cali_map", height = 737, 
      width = 1169)
  app$set_inputs(state = character(0))
  app$set_inputs(state = "California")
  app$expect_values()
  app$expect_screenshot()
})


test_that("{shinytest2} recording: new_york_scatter_asian", {
  app <- AppDriver$new(variant = platform_variant(), name = "new_york_scatter_asian", 
      height = 737, width = 1169)
  app$set_inputs(main_page = "Scatter")
  app$set_inputs(var = "Asian Race Percentage")
  app$set_inputs(state_plot = "New York")
  app$expect_screenshot()
  app$expect_values()
})


test_that("{shinytest2} recording: more-info", {
  app <- AppDriver$new(variant = platform_variant(), name = "more-info", height = 737, 
      width = 1169)
  app$set_inputs(main_page = "More Information")
  app$expect_screenshot()
})
