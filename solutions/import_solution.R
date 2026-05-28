# Load necessary libraries for data import and manipulation
library(rio)
library(tidyverse)

# Import Data ----------

# Import raw data from RDS files for flights, planes, and airlines
flights <- import("data/raw/flights.rds")
planes <- import("data/raw/planes.rds")
airlines <- import("data/raw/airlines.rds")

# Data Clean-Up --------

## Flights Data Cleaning

# Display the structure of the flights data to understand its contents
glimpse(flights)

# Convert departure and arrival times from character to numeric for proper analysis
flights$dep_time <- as.numeric(flights$dep_time)
flights$arr_time <- as.numeric(flights$arr_time)

# Rename a column in flights to correct a naming error
flights <- flights |>
  rename(month = monthh)

# explore your data. e.g. :
hist(flights$dep_time) # there are values lower than 0?
min(flights$dep_time) # -99 seems to be used for NAs
# or something like:
# sorting can be used as a trick for large
sort(table(flights$tailnum), decreasing = TRUE)

# Replace erroneous or placeholder values with NA
flights <- flights |>
  # Convert -99 in numeric columns to NA
  mutate(across( # across all collums
    where(is.numeric), # tests for numeric data type
    # if -99: make it NA, else: do nothing, return data
    ~ ifelse(. == -99, NA, .)
  )) |>
  # Convert "fehlend" in character columns to NA
  mutate(across(
    where(is.character),
    ~ ifelse(. == "fehlend", NA, .)
  ))

# Save Clean Data

# Export the cleaned datasets back to RDS files for storage and future use
rio::export(flights, "solutions/data/clean/flights.rds")
rio::export(planes, "solutions/data/clean/planes.rds")
rio::export(airlines, "solutions/data/clean/airlines.rds")

# Combine and Analyze Customer Satisfaction Data --------

# Import customer satisfaction data from multiple files
customer_satisfaction_1 <- import("data/raw/customer_satisfaction_1.rds")
customer_satisfaction_2 <- import("data/raw/customer_satisfaction_2.rds")
customer_satisfaction_3 <- import("data/raw/customer_satisfaction_3.rds")
customer_satisfaction_4 <- import("data/raw/customer_satisfaction_4.rds")

# Check the first few rows of the first dataset to understand its structure
head(customer_satisfaction_1)

# Combine all customer satisfaction datasets into one data frame
customer_satisfaction <- rbind(customer_satisfaction_1,
                               customer_satisfaction_2,
                               customer_satisfaction_3,
                               customer_satisfaction_4)

# Clean up workspace by removing individual datasets post-combination
rm(customer_satisfaction_1,
   customer_satisfaction_2,
   customer_satisfaction_3,
   customer_satisfaction_4)

# Calculate mean satisfaction per dimension for each flight
customer_satisfaction |> 
  group_by(flight_id) |>                                          # Group data by flight_id
  summarise(
    punctuality_sat = mean(punctuality_sat, na.rm = TRUE),        # Mean punctuality rating
    comfort_sat = mean(comfort_sat, na.rm = TRUE),                # Mean comfort rating
    crew_sat = mean(crew_sat, na.rm = TRUE)                       # Mean crew rating
  ) -> flight_satisfaction                                        # Store aggregated satisfaction

# Remove the combined customer satisfaction dataset to free up memory
rm(customer_satisfaction)

# Final Integration

# Join the flight satisfaction data with the flights dataset based on flight_id
flights <- flights |>
  left_join(flight_satisfaction, by = "flight_id")

rio::export(flights, "solutions/data/clean/flights.rds")

rm(flight_satisfaction)
