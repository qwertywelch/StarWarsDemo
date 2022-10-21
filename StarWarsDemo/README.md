# Star Wars Demo by Nicholas Welch
### Challenge Specifications
Develop an iOS application using the Star Wars API that lists out all of the Star Wars movies.

✅ The movies should be listed in canonical order with the following data in each cell: title, release date, episode number.

✅ Tapping on a movie cell will navigate the user into a detail view showing the following additional information: title, episode number, release date, characters, and opening crawl text.

✅ The application must be written in Swift, with a target of iOS 14, use UIKit, and use no third-party libraries.

## Architecture
The application is based on a MVVM architecture, with a data repository.

### DataRepository
A DataRepository protocol was written that provides methods for retrieving films and people. The DataRepository used can be swapped to back the application with (for example) Core Data, the filesystem, or static mocked results for testing. Depending on conformance to DataRepository means no changes would be needed to higher layers of the application.

**SWAPIRepository**
SWAPIRepository conforms to the DataRepository protocol and handles interaction with the [Star Wars API](https://swapi.dev). HTTP requests are done with URLSession's async `data(for:)` method. It uses data transfer objects (SWAPIFilm, SWAPIPerson, SWPagedResults) to decode the responses. The DTOs from the API conform to SWAPIResponseDTO, with method toDomainModel that returns DomainModel instances that we will utilize in our application.

If the API's response structures were to change, we would only need to modify the DTO struct definition and its toDomainModel transform method which are contained in one file per DTO. No other part of the app "knows" about the SWAPI, just how to get models from a DataRepository.

The SWAPI is a "hypermedia" API in that it provides schemas about itself and links to other resources with URLs. For the purpose of this demo, I am not consuming it in a hypermedia manner.

This app does not have any data persistence. When relaunched, or upon viewing each different movie, network requests are made again. Another DataRepository layer could be put on top of the SWAPIRepository to cache & persist across launches.

### Domain models
DataRepository methods return domain models specific to the application (FilmModel, PersonModel), whose definitions are not directly tied to the underlying data source and represent only data needed by our application (domain-specific).

### View models
Each view has a view model which is responsible for getting & providing data the view needs, and performing any operations on it needed so it can be displayed in the view. View models have a (weak) reference to their delegate (the view controller) so it can be informed of state changes. Views themselves have references to their view models only, NOT domain models.

1. **FilmListViewModel**: Retrieves films from repository. Sorts the film list. Provides film count, and film data for requested rows to view.
2. **FilmDetailViewModel**: Passed a film. Transforms crawl text so it can be properly displayed. Provides film data to view. 
3. **FilmDetailCharactersViewModel**: Passed a list of character IDs. Retrieves characters from repository. Provides character names for requested cells to view.

### Views
The layout has been done programatically, without storyboards (except for the LaunchScreen). Programmatic layouts are (in my experience) easier to debug & refactor, track in version control, and work on with a team. The root of the application is a UINavigationController.

#### FilmListViewController
* A UITableViewController that displays all of the Star Wars films.
* It is backed by the FilmListViewModel.
* Each cell is a FilmListCellView displaying the film's title, release date, and episode number.
* Selecting a cell navigates to a FilmDetailViewController.
* The table view can be pulled down to ask the view model to reload its data from the repository.
* In a loading state, the table view's UIRefreshControl shows.
* Sorting defaults to canonical (in order of episode number, per specifications) -- press Sort to change the order to Alphabetical, or Release Date.

#### FilmDetailViewController
* A UIViewController with a UIStackView embedded in a UIScrollView with details about a film.
* It is backed by the FilmDetailViewModel.
* A collection view, FilmDetailCharactersView loads and displays characters associated with the film.
* The FilmDetailCharactersView is expanded to a size to fit all of its content, so it scrolls with the rest of the view.

#### FilmDetailCharactersView
* A UICollectionView that displays a collection of characters.
* It is backed by the FilmDetailCharactersViewModel.
* Each character collection view cell is a FilmDetailCharacterCell displaying the character's name.
* When the view model gives a loading status, the collection shows a header with a UIActivityIndicatorView.
* When the view model gives an error status, the collection shows a header with an error message.
* As cells are displayed, they are faded in.

## UI Appearance
To fit a Star Wars aesthetic, I applied the following tweaks:

* Dark mode forced with `window.overrideUserInterfaceStyle = .dark`. 
* Accent color set to yellow.
* Navigation bar title font set to custom font "StarJedi". 
* Space image set as navigation bar's background (when not transparent).
* The "opening crawl text" is displayed in the "Franklin Gotchic - Demi" font, justified aligned, and yellow, just like in the films.

The app's icon features Jar Jar Binks who appeared in the Star Wars prequel trilogy, and my last name Welch.

## Notes
* Since the SWAPI calls them "films", that is how I have referred to them in the code. However, the interface calls them "movies" to match the specifications.
* SWAPIRepository does not check for the status of the network connection; however, requests will timeout after 15 seconds.
* While tests were not written, the architecture was designed with testability in mind.
* I tested the app on iOS 14, 15, and 16 on iPhone (with & without notch/island) & iPad simulators, as well as a physical iPhone 13 Pro Max on iOS 16.
* May the force be with you.
