test_that("spag_Lrev returns a ggplot object", {
  p <- spag_Lrev(
    df = longi_demo,
    x = "Score",
    time = "Time",
    ID = "ID"
  )

  expect_s3_class(p, "ggplot")
})

test_that("spag_Lrev works with groups", {
  p <- spag_Lrev(
    df = longi_demo,
    x = "Score",
    time = "Time",
    ID = "ID",
    group = "Center"
  )

  expect_s3_class(p, "ggplot")
})

test_that("spag_Lrev works with level group filtering", {
  p <- spag_Lrev(
    df = longi_demo,
    x = "Score",
    time = "Time",
    ID = "ID",
    group = "Center",
    incl=c(1,3)
  )

  expect_s3_class(p, "ggplot")
})

test_that("spag_Lrev works with ID isolation", {
  p <- spag_Lrev(
    df = longi_demo,
    x = "Score",
    time = "Time",
    ID = "ID",
    isol = "PAT007"
  )

  expect_s3_class(p, "ggplot")
})

test_that("spag_Lrev works with discrete time", {
  p <- spag_Lrev(
    df = longi_demo,
    x = "Score",
    time = "Visit",
    ID = "ID"
  )

  expect_s3_class(p, "ggplot")
})

test_that("spag_Lrev zoom works", {
  p <- spag_Lrev(
    df = longi_demo,
    x = "Score",
    time = "Time",
    ID = "ID",
    group = "Center",
    xlim=c(90,180),
    ylim=c(10,75)
  )

  expect_s3_class(p, "ggplot")
})

test_that("spag_Lrev residuals works", {
  p <- spag_Lrev(
    df = longi_demo,
    x = "Score",
    time = "Time",
    ID = "ID",
    y_type = "Résidus"
  )

  expect_s3_class(p, "ggplot")
})

test_that("spag_Lrev residuals work with discrete time", {
  p <- spag_Lrev(
    df = longi_demo,
    x = "Score",
    time = "Visit",
    ID = "ID",
    y_type = "Résidus"
  )

  expect_s3_class(p, "ggplot")
})

test_that("spag_Lrev residuals work with groups", {
  p <- spag_Lrev(
    df = longi_demo,
    x = "Score",
    time = "Time",
    ID = "ID",
    group = "Center",
    y_type = "Résidus"
  )

  expect_s3_class(p, "ggplot")
})

test_that("spag_Lrev residuals work with level group filtering", {
  p <- spag_Lrev(
    df = longi_demo,
    x = "Score",
    time = "Time",
    ID = "ID",
    group = "Center",
    incl=c(1,3),
    y_type = "Résidus"
  )

  expect_s3_class(p, "ggplot")
})

test_that("spag_Lrevresiduals work with ID isolation", {
  p <- spag_Lrev(
    df = longi_demo,
    x = "Score",
    time = "Time",
    ID = "ID",
    isol = "PAT007",
    y_type = "Résidus"
  )

  expect_s3_class(p, "ggplot")
})

