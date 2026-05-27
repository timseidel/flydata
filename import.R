# Load necessary libraries for data import and manipulation

library(rio)

# Import Data ----------

# Import raw data from the .RDS files for flights, planes, and airlines

flights <- import("data/raw/flights.rds")
planes <- import("data/raw/planes.rds")
airlines <- import("data/raw/airlines.rds")

# Data Clean-Up --------

## Flights Data Cleaning
# Display the structure of the flights data to understand its contents
# Convert departure and arrival times from character to numeric for proper analysis
# Rename a column in flights to correct a naming error
# Replace erroneous or placeholder values with NA

flights |>
  mutate(dep_time = as.numeric(dep_time),
         arr_time = as.numeric(arr_time),
         dep_delay = case_when(dep_delay == -99 ~ NA,
                              TRUE ~ dep_delay)) |>
  rename(month = monthh) -> flights


# Save Clean Data
dir.create("data/clean", showWarnings = FALSE)
# Export the cleaned datasets back to a .RDS file for storage and future use


# Combine and Analyze Customer Satisfaction Data --------
# Import customer satisfaction data from multiple files
# Check the first few rows of the first dataset to understand its structure
# Combine all customer satisfaction datasets into one data frame
# Clean up workspace by removing individual datasets post-combination
# Calculate mean satisfaction for each flight based on survey questions
# Remove the combined customer satisfaction dataset to free up memory

# Final Integration
# Create a sequential flight_id to enable merging satisfaction data with flights.
# In this simulated dataset, satisfaction responses are matched by row position,
# so row_number() provides the necessary join key.
# Export the cleaned datasets back to a .RDS file for storage and future use
