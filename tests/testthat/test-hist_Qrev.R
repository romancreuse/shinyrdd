test_that("hist_Qrev returns a ggplot object", {
  p <- hist_Qrev(
    df = quanti_demo,
    x = "BMI"
  )

  expect_s3_class(p, "ggplot")
})

test_that("hist_Qrev returns with modifies bins returns a ggplot object", {
  p <- hist_Qrev(
    df = quanti_demo,
    x = "BMI",
    bins = 35
  )

  expect_s3_class(p, "ggplot")
})

test_that("hist_Qrev with min/max values returns a ggplot object", {
  p <- hist_Qrev(
    df = quanti_demo,
    x = "BMI",
    group = "Treatment",
    bmin = 12,
    bmax = 45,
    bins = 35
  )
})

test_that("hist_Qrev with groups returns a ggplot object", {
  p <- hist_Qrev(
    df = quanti_demo,
    x = "BMI",
    group = "Treatment",
    bmin = 12,
    bmax = 45,
    bins = 35
  )

  expect_s3_class(p, "ggplot")
})
