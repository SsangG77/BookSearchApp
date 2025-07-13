This is a simple book search application built with SwiftUI.

## Features

- Search for books using the Kakao Book Search API.
- View a list of search results.
- View the details of a book.

## Architecture

The application follows a layered architecture:

- **Presentation Layer:** Contains the SwiftUI views and view models.
- **Domain Layer:** Contains the business logic, including use cases and entities.
- **Data Layer:** Contains the repositories and data sources responsible for fetching data from the API.

## Dependencies

- **SwiftUI:** For building the user interface.
- **Combine:** For handling asynchronous operations.

## How to Run

1. Clone the repository.
2. Open the project in Xcode.
3. Add your Kakao API key to the `Secrets.xcconfig` file.
4. Build and run the application.
