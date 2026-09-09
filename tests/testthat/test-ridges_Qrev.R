test_that("spag_Qrev returns a ggplot object", {

p <- ridges_Qrev(
  df = quanti_demo,
  x = "BMI",
  group = "Treatment"
)
  expect_s3_class(p, "ggplot")
})
