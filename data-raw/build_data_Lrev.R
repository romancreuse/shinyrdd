# Génération du jeu longitudinal de démonstration

set.seed(456)

n_id <- 200
n_time <- 10


patients <- data.frame(

  ID = sprintf("PAT%03d",1:n_id),

  Gender = sample(
    c("1","2"),
    n_id,
    replace = TRUE
  ),

  Center = sample(
    c("1","2","3"),
    n_id,
    replace = TRUE
  ),

  Treatment = sample(
    c("A","B"),
    n_id,
    replace = TRUE
  ),

  Age = round(rnorm(n_id,60,10))

)



Time <- 0:(n_time-1)



longi_demo <- merge(
  patients,
  data.frame(Time=Time)
)



# Effets individuels

intercept <- rnorm(
  n_id,
  0,
  8
)

pente <- rnorm(
  n_id,
  -1,
  0.3
)


longi_demo$Score <-
  50 +
  intercept[match(longi_demo$ID,
                  patients$ID)] +
  pente[match(longi_demo$ID,
              patients$ID)] *
  longi_demo$Time +
  ifelse(
    longi_demo$Treatment=="B",
    -5,
    0
  ) +
  rnorm(
    nrow(longi_demo),
    0,
    3
  )

# Time catégoriel

longi_demo$Visit <- factor(
  paste0(
    "V",
    longi_demo$Time
  ),
  levels =
    paste0("V",0:7)
)



# Valeurs aberrantes longitudinales

# Sujet avec une pente anormale
longi_demo$Score[
  longi_demo$ID=="PAT023"
] <-
  longi_demo$Score[
    longi_demo$ID=="PAT023"
  ] +
  seq(
    0,
    60,
    length.out =
      sum(longi_demo$ID=="PAT023")
  )


# Valeur isolée
longi_demo$Score[
  longi_demo$ID=="PAT041" &
    longi_demo$Time==4
] <- 140


# Sujet très bruité

idx <- longi_demo$ID=="PAT067"

longi_demo$Score[idx] <-
  longi_demo$Score[idx] +
  rnorm(sum(idx),0,20)



# Données manquantes

longi_demo$Score[
  longi_demo$ID=="PAT054" &
    longi_demo$Time %in% c(2,5,6)
] <- NA



# Facteurs

longi_demo$ID <- factor(longi_demo$ID)

longi_demo$Gender <- factor(longi_demo$Gender)

longi_demo$Center <- factor(longi_demo$Center)

longi_demo$Treatment <- factor(longi_demo$Treatment)

# Variation du temps longitudinal

longi_demo$Time <- ifelse(longi_demo$Time==0,0,longi_demo$Time*30 + sample(c(-7:7),replace = T,size = n_id*n_time))

# Labels

labelled::var_label(longi_demo) <- list(

  ID = "Patient ID",
  Time = "Time since inclusion (days)",
  Score = "Clinical score",
  Gender = "Gender",
  Age = "Age (years)"
)


usethis::use_data(
  longi_demo,
  overwrite = TRUE
)
