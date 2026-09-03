# pour Lrev_server

export_Lrev <- function(x){
  downloadHandler(
  
  filename = function() {
    paste0(
      "liste_outliers_",
      Sys.Date(),
      ".xlsx"
    )
  },
  
  content = function(file) {
    
    req(nrow(x) > 0)
    
    openxlsx::write.xlsx(
      x,
      file = file,
      overwrite = TRUE
    )
    
  }
  
)
}
  
# pour Qrev_server

export_Qrev <- function(x){
downloadHandler(
  
  filename = function() {
    paste0(
      "liste_outliers_",
      Sys.Date(),
      ".xlsx"
    )
  },
  
  content = function(file) {
    
    safe_names <- names(x) |>
      gsub("[\\/:*?\\[\\]]", "_", x = _) |>
      substr(1, 31)
    
    names_to_export <- x
    names(names_to_export) <- safe_names
    
    req(length(x) > 0)
    
    openxlsx::write.xlsx(
      names_to_export,
      file = file,
      overwrite = TRUE
    )
    
  }
  
)
}