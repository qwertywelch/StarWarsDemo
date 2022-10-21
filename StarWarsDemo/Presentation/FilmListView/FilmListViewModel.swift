//
//  FilmListViewModel.swift
//  StarWarsDemo
//
//  Created by Nicholas Welch on 10/20/22.
//

import Foundation

/// The view model for FilmListViewController. Retrieves films from repository, performs sorting, and provides
/// the pieces of data displayed by film cells.
class FilmListViewModel {
	// delegate is weak to avoid this reference from preventing it from getting garbage collected
	// but not unowned so this view model could potentially be used without a delegate, such as in testing
	weak var delegate: ViewModelDelegate?
	private var repository: DataRepository = SWAPIRepository.shared
	private var status: ViewModelStatus = .idle {
		didSet {
			delegate?.updated(with: status)
		}
	}
	
	private var films: [FilmModel] = []
	private var order: SortOrder = .canonical {
		didSet {
			films = sort(filmArray: films, by: order)
			status = .success
		}
	}
	
	private func sort(filmArray: [FilmModel], by newSort: SortOrder) -> [FilmModel] {
		switch order {
		case .alphabetical:
			return filmArray.sorted { $0.title < $1.title }
		case .canonical:
			return filmArray.sorted { $0.episodeNum < $1.episodeNum }
		case .released:
			return filmArray.sorted { $0.releaseDate < $1.releaseDate }
		}
	}
}

enum SortOrder: String {
	case alphabetical = "alpha"
	case canonical = "canon"
	case released = "date"
}

// MARK: Used by view
extension FilmListViewModel {
	var sortOrder: SortOrder {
		order
	}
	var numberOfFilms: Int {
		films.count
	}
	
	@objc func load() {
		status = .loading
		
		Task {
			let filmsResult = await repository.getFilms(page: 1)
			
			switch filmsResult {
			case .success(let filmData):
				films = sort(filmArray: filmData.results, by: order)
				status = .success
				break
			case .failure(let error):
				status = .error(error)
			}
		}
	}
	
	func setOrder(_ newOrder: SortOrder) {
		order = newOrder
	}
	
	func getData(for indexPath: IndexPath) -> (title: String, releaseDate: String, episodeNum: Int) {
		let film = films[indexPath.row]
		
		return (title: film.title, releaseDate: dateFormatterDisplay.string(from: film.releaseDate), episodeNum: film.episodeNum)
	}
	
	func getDetailViewModel(for indexPath: IndexPath) -> FilmDetailViewModel {
		// since the detail view uses the same FilmModel we already have, pass it into
		// the detail view model to skip another repository (network) hit
		FilmDetailViewModel(film: films[indexPath.row])
	}
}
