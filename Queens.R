library(rstudioapi)
script_path <- getActiveDocumentContext()$path
setwd(dirname(script_path))

# skip the first 6 rows so that row 7 is read in as the header
Queens2023 <- read.csv("2023_queens.csv", 
                       header = TRUE,   # treat the first line *after* skipping as names
                       skip   = 6)      # drop rows 1–6 entirely

# now Queen2023 has proper names from row 7
#head(Queens2023)

colnames(Queens2023)

Queens2023_Filtered <- subset(
  Queens2023,
  select = c(
    "TAX.CLASS.AT.PRESENT",
    "ZIP.CODE",
    "TOTAL..UNITS",
    "YEAR.BUILT",
    "SALE.PRICE",
    "LAND..SQUARE.FEET",
    "GROSS..SQUARE.FEET"
  )
)


head(Queens2023_Filtered)

# Alternatively, both dimensions (rows, cols)
dim(Queens2023_Filtered)   # first element is rows, second is columns
