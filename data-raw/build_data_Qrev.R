# Génération du jeu quantitatif de démonstration

set.seed(123)

n <- 400

quanti_demo <- data.frame(
  ID = sprintf("PAT%03d", 1:n),

  Age = rnorm(n, 55, 12),
  Height = round(rnorm(n, 170, 10), 1),
  Weight = rnorm(n, 75, 15),

  Gender = sample(
    c(1, 2),
    n,
    replace = TRUE
  ),

  Treatment = sample(
    c("A", "B", "C"),
    n,
    replace = TRUE
  )
)

# Décalage par traitement

age_shift <- c(
  A = 7,
  B = 0,
  C = -3
)

weight_shift <- c(
  A = 10,
  B = 0,
  C = -4
)

ldl_shift <- c(
  A = 0.35,
  B = 0.15,
  C = -0.10
)

# Décalage par sexe

weight_gender_shift <- c(
  `1` = 0,
  `2` = 10
)

height_gender_shift <- c(
  `1` = 0,
  `2` = 10
)

# Application des décalages

quanti_demo$Age <- round(
  quanti_demo$Age +
    age_shift[as.character(quanti_demo$Treatment)]
)

quanti_demo$Weight <- round(
  quanti_demo$Weight +
    weight_shift[as.character(quanti_demo$Treatment)]+
    height_gender_shift[as.character(quanti_demo$Gender)],
  1
)

quanti_demo$Height <- round(
  quanti_demo$Height +
    height_gender_shift[as.character(quanti_demo$Gender)],
  1
)

# Variables biologiques

quanti_demo$BMI <- round(
  quanti_demo$Weight /
    (quanti_demo$Height / 100)^2,
  1
)

# LDL avec effet traitement
quanti_demo$LDL <- round(
  rnorm(n, 2.8, 0.7) +
    ldl_shift[as.character(quanti_demo$Treatment)],
  2
)


# Ajout d'outliers volontaires

quanti_demo$Height[c(45, 56, 220)] <- c(87, 225, 187)

quanti_demo$Weight[c(13,45, 120,220)] <- c(17,87, 168,187)

quanti_demo$LDL[c(20, 200)] <- c(8, 10)


# Quelques valeurs manquantes

for(v in c(
  "Age",
  "Weight"
)){

  quanti_demo[sample(n, 20), v] <- NA

}


# Passage en facteur

quanti_demo$Treatment <- factor(
  quanti_demo$Treatment
)


# Labels

labelled::var_label(quanti_demo) <- list(
  ID = "Patient ID",
  Age = "Age (years)",
  Height = "Height (cm)",
  Weight = "Weight (kg)",
  BMI = "Body mass index",
  LDL = "LDL cholesterol (mmol/L)",
  Gender = "Gender"
)

usethis::use_data(
  quanti_demo,
  overwrite = TRUE
)
