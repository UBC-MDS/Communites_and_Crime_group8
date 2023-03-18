library(shinytest2)

test_that("{shinytest2} recording: base_test", {
  app <- AppDriver$new(variant = platform_variant(), name = "base_test", height = 737, 
      width = 1169)
  app$expect_screenshot()
  app$expect_values()
})


test_that("{shinytest2} recording: cali_scatter", {
  app <- AppDriver$new(variant = platform_variant(), name = "cali_scatter", height = 737, 
      width = 1169)
  app$set_inputs(main_page = "Scatter")
  app$set_inputs(state_plot = "California")
  app$set_inputs(var = "Asian Race Percentage")
  app$expect_screenshot()
  app$expect_values()
})
