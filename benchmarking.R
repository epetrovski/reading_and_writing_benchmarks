library(data.table)
library(readr)

# Make readr silent
options(readr.num_columns = 0)

# Function for making test data
make_data <- function(n){
  data.frame(char = sprintf("%08d", 1:n),
             int = 1L:n,
             double_a = runif(n, -1000000, 1000000),
             double_b = runif(n, -1000000, 1000000),
             stringsAsFactors = FALSE)
}

# n rows of data to generate
n_rows <- c(500000, 2000000, 5000000, 10000000, 20000000)

# vectors for storing results
size_MB <- fwrite <- write_csv <- fread <- read_csv <- threads <- c()

# Function for benchmarking
benchmark <- function(threads){
  
  # Set threads
  setDTthreads(threads)
  
  # Benchmarking in a loop
  run <- 1
  for (i in n_rows) {
    
    df <- make_data(i)
    
    # Writing benchmarks
    fwrite[run] <- system.time(fwrite(df, "df_dt.csv", showProgress = FALSE))[[3]]
    write_csv[run] <- system.time(write_csv(df, "df_rdr.csv"))[[3]]
    
    # Write file with base R for neutral reading benchmarks
    write.csv(df, "df.csv", row.names = FALSE)
    
    # Calculate file size
    size_MB[run] <- round(file.size("df.csv") / 1e+6)
    
    # Reading benchmarks
    fread[run] <- system.time(df_dt <- fread("df.csv", showProgress = FALSE))[[3]]
    read_csv[run] <- system.time(df_rdr <- read_csv("df.csv", progress = FALSE))[[3]]
    
    threads[run] <- getDTthreads()
    run <- run + 1
  }
  
  # Bind and calculate results
  data.table(threads, size_MB, write_csv, read_csv, fwrite, fread)
}

# Run benchmarking
benchmarks <- rbind(benchmark(0), benchmark(1L))

# Calculate differences between fread and readr
benchmarks <- benchmarks[, `:=`(write_ratio = round(write_csv / fwrite, 1),
                                read_ratio = round(read_csv / fread, 1))]

# Save benchmarks
saveRDS(benchmarks, "benchmarks.RDS")

# Cleanup
sapply(c("df.csv", "df_dt.csv", "df_rdr.csv"), file.remove)




