# Article Search and Logging Application

This project aims to create a search mechanism where users can browse through a database of articles and search for specific content. The two main features implemented are:

1. **Realtime Search:** As the user types, the UI automatically updates to show articles that match the input.
2. **Search Logging:** Records user inputs to enable later analysis of search behavior.

## Features

### Realtime Search

The realtime search updates the UI dynamically as the user types, providing immediate feedback and results based on the search query.

### Search Logging

This feature records user inputs in a log, capturing the search terms, IP address, and country. This data can later be used for analysis to understand user search behavior.

## Technologies Used

- **Rails 7:** Utilized for backend development and built-in Turbo mechanisms.
- **Tailwind CSS:** Used for styling the application.
- **RSpec:** Employed for testing the application.

## Implementation Steps

### Architecture Planning

To tackle the problem, I first visualized the software architecture to understand the desired behavior before writing any code.

![Software Architecture](/app/assets/images/realtime-seach-architecture.png)

### Scaffolding and Basic Setup

I scaffolded the articles, added simple validations, and wrote unit tests.

### Realtime Search

The realtime search is implemented using `pg_search`. A search bar was created, and a listener was added to the input form using Stimulus. When the input changes, the listener triggers a function to update the UI using Turbo Frames.

### Search Logging

The logging feature required the following steps:

1. **Create Log Model:** The model records inputs, IP addresses, and countries. External APIs are used to fetch the IP and country information.
2. **Endpoint Creation:** An endpoint was created to log the inputs when the user types in the search bar.
3. **Stimulus Controller:** A function in the Stimulus controller stores the input, fetches the IP and country, and makes a fetch request to the endpoint to create log records.

### Filtering Logs

To avoid storing every single user input, a filtering algorithm with a recursive method was implemented to process the user inputs and store the final queries. The steps followed are:

1. **Group by IP:** Inputs are grouped by their IP addresses.
2. **Order and Compare:** The inputs are ordered in ascending order and compared to see if one starts with the other.
3. **Define a Recursive Function:** This function compares the current and next input values.
4. **Comparison:** Check if the next value starts with the current value.
5. **Recursive Call:** If the next value starts with the current value, the function calls itself recursively with the next value.
6. **Store Final Value:** If the next value does not start with the current value, store the current value in the final array.

By implementing this method, only the final user input is retained, reducing unnecessary storage and ensuring meaningful data collection.

A boolean attribute in the Log model distinguishes between processed and unprocessed logs. The logs are processed to maintain only the true values for analysis, while the unprocessed logs are deleted. This filtering ensures that the stored data is clean and useful for further analytics.

### Displaying Logs

Popular gems were used to create charts and display logs to the user. This includes analytics on:

- The countries where searches were made.
- Trending searches in the last month.
- Top users by search count.
- The last five searches.

## Known Issues

Despite the implementation, there are some known flaws:

- **User Input Backspacing/Changes:** The filter algorithm does not account for backspacing or mid-sentence changes.
- **Concurrent Filter Calls:** The filter can be called while a user is making a query.
- **Scope-based Analytics:** Analytics should consider scopes rather than string literals.
- **Time-Based Filtering:** The current filter does not account for the time between logs.
- **Pending System Tests:** System tests are yet to be completed.
- **Responsive Design:** The application needs a more responsive design.

## Conclusion

This project demonstrates a basic yet functional article search and logging mechanism. Future improvements can address the known issues and enhance the application's robustness and user experience.

## Usage

To get started with this project, follow these steps:

1. **Clone the repository:**

   ```sh
   git clone git@github.com:marcosgabriel-smc/search-engine-analytics.git

   ```

2. **Change into the project directory:**

   ```sh
   cd search-engine-analytics

   ```

3. **Install the necessary gems:**

   ```sh
   bundle install

   ```

4. **Set up the database:**

   ```sh
   rails db:setup

   ```

5. **Start the development server:**

   ```sh
   ./bin/dev
   ```
