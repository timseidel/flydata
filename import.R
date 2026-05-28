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



# Combine and Analyze Customer Satisfaction Data --------
# Import customer satisfaction data from multiple files
# Check the first few rows of the first dataset to understand its structure
# Combine all customer satisfaction datasets into one data frame
# Clean up workspace by removing individual datasets post-combination
# Calculate mean satisfaction per dimension (punctuality, comfort, crew) for each flight
# Remove the combined customer satisfaction dataset to free up memory

# Final Integration
#
# Now we have two tables we want to combine:
#   - flights: one row per flight, with dep_delay, carrier, etc.
#   - flight_satisfaction: average satisfaction ratings per flight
#
# What is a Join?
# A join combines two tables using a common column — called a key —
# that appears in both. Think of it like a VLOOKUP in Excel: you look up
# a value in one table to bring in matching information from another.
#
# Here, both tables already have a flight_id column. That's our key.
# Each flight_id appears once in flights and once (or not at all) in
# flight_satisfaction.
#
# left_join() keeps all rows from the first (left) table and adds
# matching columns from the second (right):
#
#   flights <- flights |>
#     left_join(flight_satisfaction, by = "flight_id")
#
# This adds punctuality_sat, comfort_sat, and crew_sat to every flight.
# For flights with no survey response, those columns will be NA.
#
# Export the cleaned datasets back to a .RDS file for storage and future use
dir.create("data/clean", showWarnings = FALSE)
