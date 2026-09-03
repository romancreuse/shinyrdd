# Extraction du label s'il existe, du nom de la variable sinon

choice_from_label <- function(df, var) {
  
  lab <- attr(df[[var]], "label")
  
  if (is.null(lab) || identical(lab, "")) {
    var
  } else {
    lab
  }
  
}

# Application de var_label à un vecteur de noms de variables

choices_from_labels <- function(df, vars) {
  
  stats::setNames(
    vars,
    vapply(vars, choice_from_label, character(1), df = df)
  )
}