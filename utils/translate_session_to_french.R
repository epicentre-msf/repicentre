# Function to translate the session of your choice in French

translate_session_to_french <- function(
    session_type = "core",
    session_name) {
  # Check for DEEPL API key
  deepl_key <- Sys.getenv("DEEPL_API_KEY")
  if (deepl_key == "") {
    stop("You need to set up the DEEPL_API_KEY variable in your .Renviron using the DeepL key. See README for more details.")
  }

  # Install babeldown if not present
  if (!requireNamespace("babeldown", quietly = TRUE)) {
    install.packages("babeldown")
    # Uncomment if you prefer using pak: pak::pak("ropensci-review-tools/babeldown")
  }

  # Determine session folder based on session type
  if (session_type == "core") {
    session_folder <- here::here("sessions_core")
  } else if (session_type == "extra") {
    session_folder <- here::here("sessions_extra")
  } else {
    stop("Invalid session type. Please specify 'core' or 'extra'.")
  }

  # Update the glossary
  babeldown::deepl_upsert_glossary(
    filename = "glossary-en-fr.csv",
    target_lang = "French",
    source_lang = "English"
  )

  # Check if a French version of the file already exists
  translated_file <- here::here(session_folder, sub("\\.qmd$", ".fr.qmd", session_name))
  if (file.exists(translated_file)) {
    response <- readline("A French version already exists for this file. Shall we overwrite it? (Y/N): ")
    if (toupper(response) == "Y") {
      overwrite <- TRUE
    } else if (toupper(response) == "N") {
      overwrite <- FALSE
    } else {
      stop("Invalid input. Please type 'Y' or 'N'.")
    }
  } else {
    overwrite <- FALSE
  } 

  # Perform the translation
  suppressWarnings(
    babeldown::deepl_translate_quarto(
      book_path = session_folder,
      chapter = session_name,
      force = overwrite,
      glossary_name = "glossary-en-fr",
      source_lang = "EN",
      target_lang = "FR",
      formality = "default"
    )
  )

  # Display CLI message
  cat("🇫🇷 Translation Complete! 🥖\n\n")
  cat("The file has been successfully translated from English (EN) to French (FR) using DeepL, with the following details:\n\n")
  cat(sprintf("📂 Session Folder: %s\n", session_folder))
  cat(sprintf("📄 Session Name: %s\n", sub("\\.qmd$", ".fr.qmd", session_name)))
  cat(sprintf("🔄 Overwrite: %s\n\n", ifelse(overwrite, "Yes", "No")))
  cat("Please manually review the translation now!\n")
}

# Example ----------------------------------------------------------------
# Notice there is a final error but the translation worked ! this is because the function was designed for quarto books and not single .qmd files

# translate_session_to_french(
#   session_type = "core",
#   session_name = "02_import_data.qmd"
# )
