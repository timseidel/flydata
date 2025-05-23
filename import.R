# Load necessary libraries for data import and manipulation


# Import Data ----------

# Import raw data from the .RDS files for flights, planes, and airlines


# Data Clean-Up --------

## Flights Data Cleaning
# Display the structure of the flights data to understand its contents
# Convert departure and arrival times from character to numeric for proper analysis
# Rename a column in flights to correct a naming error
# Replace erroneous or placeholder values with NA

# Save Clean Data
# Export the cleaned datasets back to a .RDS file for storage and future use


# Combine and Analyze Customer Satisfaction Data --------
# Import customer satisfaction data from multiple files
# Check the first few rows of the first dataset to understand its structure
# Combine all customer satisfaction datasets into one data frame
# Clean up workspace by removing individual datasets post-combination
# Calculate mean satisfaction for each flight based on survey questions
# Remove the combined customer satisfaction dataset to free up memory

# Final Integration
# Create a flight_id column for `flights` to enable proper data merging
# Export the cleaned datasets back to a .RDS file for storage and future use
