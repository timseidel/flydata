# import
## Projekt von Github klonen
## IMPORT-SCRIPT Korrigieren 
### -> Probleme: Number in String, Faktor als Nummer, Falscher Var Name, Rownames, NAs als -99 und fehlend ausschließen
## Codebook erstellen
## Airbus Industries zu airbus

# Verarbeitung
## Analyse nach Airline, Airport
## Neue Variable "hohe Verspätung"
## Skala "Kundenzufriedenheit"

# export und grafiken
## Markdown
## fehlerhafte ggPlots
## Plotly selbst einarbeiten!
## Report exportieren

save <- function() {
  rio::export(flights, "input/flights.rds")
  rio::export(airports, "input/airports.rds")
  rio::export(airlines, "input/airlines.rds")
  rio::export(planes, "input/planes.rds")
  rio::export(weather, "input/weather.rds")
}

remotes::install_github("moderndive/nycflights23")
library(nycflights23)
library(tidyverse)

# Flights
rm(flights)
flights <- flights

# NAs als -99 und fehlend ausschließen

flights <- flights %>%
  mutate(
    # Replace NA in numeric columns with -99
    across(where(is.numeric), ~ ifelse(is.na(.), -99, .)),
    
    # Replace NA in character columns with "fehlend"
    across(where(is.character), ~ ifelse(is.na(.), "fehlend", .))
  )

# Number in String
flights$dep_time <- as.character(flights$dep_time)
flights$arr_time <- as.character(flights$arr_time)

# Falscher Var Name
flights <- flights |>
  rename(monthh = month)


airports <- airports
airlines <- airlines
planes <- planes
weather <- weather

# Zufriedenheitsumfrage ---------------
# Flights
rm(flights)
flights <- flights
planes <- planes

flights <- left_join(flights, planes, by = "tailnum")
flights$passengers <- round(flights$seats * rbeta(length(flights$seats), 5, 1) - 
  abs(rnorm(length(flights$seats), mean = 0, sd = 0.05)),0)


fake_ticket_client(vol = 1000000) |>
  dplyr::select("first", "last", "age") -> clients

satisfaction <- function(passengers, delay, arr_time) {

  
  fake_ticket_client(vol = passengers) |>
    dplyr::select("first", "last", "age") -> clients
  
  raw <- mvrnorm(passengers, mu = rep(0, 3),
                 Sigma = matrix(c(1, rnorm(3, 0.5, 0.1),
                                  1, rnorm(3, 0.5, 0.1),
                                  1), 3, 3))
  
  scaled_data <- apply(raw, 2, function(x) {
    rank_x <- rank(x)                # Rank the data
    scaled_rank <- (rank_x - 1) / (length(rank_x) - 1)  # Scale to [0, 1]
    scaled_rank * 4 + 1              # Scale to [1, 5]
  })
  
  satisfaction <- as.data.frame(round(scaled_data))
  
  # Create a function to adjust satisfaction based on delay and arrival time
  adjust_satisfaction <- function(sat, delay, arr_time) {
    # Define a multiplier for delay impact
    delay_impact <- -0.05 * delay  # Adjust this factor as needed
    
    # Define an additional impact for night time arrivals
    night_penalty <- ifelse(arr_time >= 2200 | arr_time < 600, -0.2, 0)
    
    # Calculate the new satisfaction score
    new_sat <- pmax(1, sat + delay_impact + night_penalty)
    new_sat <- pmin(5, new_sat)    # Ensure satisfaction scores stay within [1, 5]
    return(round(new_sat))
  }
  
  # Apply adjustment to satisfaction scores
  clients <- clients |> mutate(
    sat_1 = adjust_satisfaction(satisfaction$V1, delay, arr_time),
    sat_2 = adjust_satisfaction(satisfaction$V2, delay, arr_time),
    sat_3 = adjust_satisfaction(satisfaction$V3, delay, arr_time)
  )
  
  return(clients)
}


# Use a list to store the results of each function call
satisfaction_list <- vector("list", length = nrow(flights))

# Loop through each row in the flights dataframe
for (flight in seq_len(nrow(flights))) {
  if (is.na(flights$passengers[flight])) {
    next
  }
  # Get the satisfaction dataframe for each flight
  sats <- satisfaction(flights$passengers[flight],
                       flights$arr_delay[flight],
                       flights$arr_time[flight])
  
  # Add an identifier to the rows, such as a flight number or row index
  sats <- sats |> mutate(flight_id = flight)
  
  # Store the result in the list
  satisfaction_list[[flight]] <- sats
}

# Combine all data frames in the list into one large data frame
combined_satisfaction <- dplyr::bind_rows(satisfaction_list)
rio::export(combined_satisfaction, "output/combined_satisfaction.csv")

temp <- flights[1:38406,]
