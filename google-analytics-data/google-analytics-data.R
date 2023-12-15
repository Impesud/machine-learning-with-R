# Google Analytics 4 API with R
# Visit my profile: https://github.com/impesud

# Install googleAnalyticsR v1.1.0
install.packages("googleAnalyticsR")

library(googleAnalyticsR)
library(scales)
library(ggplot2)

# Authenticate with client OAUTH credentials
# Go to Google Cloud, then 'APIs & Services' -> 'Credentials' and create it
googleAuthR::gar_set_client(json = "here_put_your_path_file_json")


# Provide the service account email and private key
# Go to Google Cloud, then 'IAM and Administration' -> 'Service Account' and create it
ga_auth(email = "here_put_your_service_account_email",
        json_file = "here_put_your_other_path_file_json")

# Get a list of all GA4 metrics
metrics_list = ga_meta(version = "data")

# Set up GA property ID
property_id = "your_property_ID"

# Test API is working
basic <- ga_data(
  property_id,
  metrics = c("activeUsers", "sessions"),
  date_range = c("2023-12-01", "2023-12-31")
)
print(basic)

# Prepare the data to export to CSV
df <- ga_data(
    property_id,
    metrics = c("activeUsers","sessions"),
    dimensions = c("date","city"),
    date_range = c("2023-12-01", "2023-12-31"),
    orderBys = ga_data_order(+date)
)
print(df)

# Export to CSV
write.csv(df, "here_put_your_path_and_name_of_your_new_CSV_file", row.names=FALSE)

ggplot(df, aes(date, activeUsers)) + geom_line() + 
  xlab("") + ylab("Active Users") + theme_bw() + 
  scale_y_continuous(labels = label_number(accuracy = 1)) +
  ggtitle("Active Users in December 2023")
