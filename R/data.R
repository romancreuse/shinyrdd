#' Example quantitative data for Qrev
#'
#' A synthetic dataset used to demonstrate the quantitative data review
#' application [shiny_Qrev()] and the plotting function [hist_Qrev()].
#'
#' @format A data frame with 200 observations and 8 variables:
#' \describe{
#' \item{ID}{Individual identifier.}
#' \item{Treatment}{Treatment group.}
#' \item{Height}{Height in cms}
#' \item{Weight}{Weight in kilograms}
#' \item{Gender}{Sex of the individual.}
#' \item{Age}{Age in years.}
#' \item{BMI}{Body mass index computed from Height and Weight variables}
#' \item{LDL}{LDL-cholestérol}
#' }
#'
#' @source Synthetic data generated for demonstration purposes.
"quanti_demo"
#'
#'
#' Example longitudinal data for Lrev
#'
#' A synthetic longitudinal dataset used to demonstrate the longitudinal
#' data review application [shiny_Lrev()] and the plotting function
#' [spag_Lrev()].
#'
#' @format A data frame with observations collected repeatedly for
#' multiple individuals:
#' \describe{
#' \item{ID}{Individual identifier.}
#' \item{Gender}{Sex of the individual.}
#' \item{Center}{Center of treatment}
#' \item{Treatment}{Treatment group.}
#' \item{Age}{Age in years.}
#' \item{Time}{Time of measurement in days}
#' \item{Score}{Clinical score with multiple measures per individual}
#' \item{Visit}{Discrete time variable}
#' }
#'
#' @source Synthetic data generated for demonstration purposes.
"longi_demo"
