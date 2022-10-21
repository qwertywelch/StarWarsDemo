//
//  FilmDetailViewModel.swift
//  StarWarsDemo
//
//  Created by Nicholas Welch on 10/20/22.
//

import Foundation

/// View model for the FilmDetailViewController.
class FilmDetailViewModel {
	// delegate is weak to avoid this reference from preventing it from getting garbage collected
	// but *not* unowned so this view model could potentially be used without a delegate, such as in testing
	weak var delegate: ViewModelDelegate?
	private let repository: DataRepository
	private var status: ViewModelStatus = .idle {
		didSet {
			delegate?.updated(with: status)
		}
	}
	
	private let film: FilmModel
	
	init(film: FilmModel, repository: DataRepository = SWAPIRepository.shared) {
		self.film = film
		self.repository = repository
	}
}

// MARK: Used by view
extension FilmDetailViewModel {
	var characterIds: [String] {
		film.characterIds
	}
	var navTitle: String {
		film.title
	}
	var episodeText: String {
		"EPISODE \(film.episodeNum)"
	}
	var releaseDateText: String {
		dateFormatterDisplay.string(from: film.releaseDate)
	}
	var openingCrawlText: String {
		// Crawl text from API contains line breaks within paragraphs, which breaks the justified alignment
		// Strip out line breaks, except the double ones between paragraphs using regex with lookahead/behind
		film.openingCrawl.replacingOccurrences(of: "(?<!\r\n)\r\n(?!\r\n)", with: " ", options: [.regularExpression])
	}
}
