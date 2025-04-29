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
    "GROSS..SQUARE.FEET",
    "BUILDING.CLASS.AT.TIME.OF.SALE", 
    "BUILDING.CLASS.CATEGORY"
  )
)

#head(Queens2023_Filtered)

# Alternatively, both dimensions (rows, cols)
dim(Queens2023_Filtered)   # first element is rows, second is columns


# Alternatively, using na.omit()
Queens2023_Clean <- na.omit(Queens2023_Filtered)
Queens2023_Clean <- subset(Queens2023_Clean, SALE.PRICE != 0)
Queens2023_Clean$SALE.PRICE <- as.numeric(
  gsub(",", "", Queens2023_Clean$SALE.PRICE)
)
Queens2023_Clean$GROSS..SQUARE.FEET <- as.numeric(
  gsub(",", "", as.character(Queens2023_Clean$GROSS..SQUARE.FEET))
)
Queens2023_Clean$LAND..SQUARE.FEET <- as.numeric(
  gsub(",", "", as.character(Queens2023_Clean$LAND..SQUARE.FEET))
)

nrow(Queens2023_Clean)
Queens2023_Clean <- subset(
  Queens2023_Clean,
  BUILDING.CLASS.CATEGORY %in% c(
    "01 ONE FAMILY DWELLINGS",
    "02 TWO FAMILY DWELLINGS",
    "03 THREE FAMILY DWELLINGS"
  )
)
nrow(Queens2023_Clean)



# Check that all rows are now complete
#nrow(Queens2023_Clean)
#head(Queens2023_Filtered)
print('Queens2023_Clean head: ')
head(Queens2023_Clean)
#colnames(Queens2023_Clean)



Queens2023_Model <- lm(
    SALE.PRICE ~
    #YEAR.BUILT +                          # quantitative                # quantitative
    GROSS..SQUARE.FEET +                   # quantitative
    #LAND..SQUARE.FEET 
    factor(BUILDING.CLASS.CATEGORY)  +
    factor(ZIP.CODE),
  data = Queens2023_Clean
)


# View the coefficient estimates and model summary
#summary(Queens2023_Model)

formula(Queens2023_Model)

coef(Queens2023_Model)

#class(Queens2023_Clean$GROSS..SQUARE.FEET)    
#class(Queens2023_Clean$LAND..SQUARE.FEET)  



# Extract once
res <- residuals(Queens2023_Model)
fit <- fitted(Queens2023_Model)

# Scatter + zero‐line
plot(fit, res,
     xlab = "Fitted values",
     ylab = "Residuals",
     main = "Residuals vs Fitted")
abline(h = 0, lty = 2)

# Add a lowess smooth curve
lines(lowess(fit, res), col = "red", lwd = 2)

summary(Queens2023_Model)