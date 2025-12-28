# Breaking Bad Universe Explorer

This is a simple SwiftUI application for iOS that allows users to explore the universe of the TV shows "Breaking Bad" and "Better Call Saul", and the movie "El Camino".

## Features

*   Fetches and displays random quotes from the selected production.
*   Displays information about the character who said the quote, including their name, image, and birthday.
*   If the character is deceased, it displays the cause of death, the person responsible, and the last words they said.
*   Users can switch between "Breaking Bad", "Better Call Saul", and "El Camino".

## Architecture

The application is built using the Model-View-ViewModel (MVVM) architecture.

*   **Model:** The data for the application is represented by the `Quote`, `Char`, and `DeathRecord` structs, which are defined in `BreackingBad/DataStructures.swift`.
*   **View:** The UI is defined in `BreackingBad/ContentView.swift` and is composed of three main views: `ContentView`, `MainPage`, and `DetailView`.
*   **ViewModel:** The `ViewModel` class in `BreackingBad/ContentView.swift` is responsible for fetching data from the API and managing the application's state.

## Technologies Used

*   **SwiftUI:** For building the user interface.
*   **Xcode:** The integrated development environment used for developing iOS applications.
*   **RESTful API:** For fetching data from the [Breaking Bad API](https://breaking-bad-api-six.vercel.app/api/).
*   **JSON Decoding:** Using `JSONDecoder` with `Codable` for parsing API responses into native Swift data structures.

## Building and Running

To build and run the application, you will need Xcode 15 or later.

1.  Clone the repository.
2.  Open the `BreackingBad.xcodeproj` file in Xcode.
3.  Select a simulator or a physical device.
4.  Click the "Run" button.

## API

The application uses the [Breaking Bad API](https://breaking-bad-api-six.vercel.app/api/) to fetch data.
