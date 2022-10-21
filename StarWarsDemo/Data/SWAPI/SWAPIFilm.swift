//
//  SWAPIFilm.swift
//  StarWarsDemo
//
//  Created by Nicholas Welch on 10/19/22.
//

import Foundation

/// A single Star Wars film resource from the Star Wars API (https://swapi.dev/documentation#films)
/// This is a data transfer object used for decoding the API response, and transforming it into a domain resource.
struct SWAPIFilm {
	let title: String
	let episode_id: Int
	let opening_crawl: String
	let release_date: String
	let characters: [URL]
	
	// leaving out fields not used by app
}

// For transforming the API object into our standard resource.
extension SWAPIFilm: SWAPIResponseDTO {
	typealias Resource = FilmModel

	func toDomainModel() throws -> FilmModel {
		guard let releaseDate = dateFormatterConvert.date(from: release_date) else {
			throw DataRetrievalError.decoding
		}
		
		// for the scope of this project, not using the hypermedia URLs,
		// so simply extract the character ID from the end of the URL
		
		let characterIds = characters.map { $0.lastPathComponent }
		
		return FilmModel(title: title,
				 episodeNum: episode_id,
				 openingCrawl: opening_crawl,
				 releaseDate: releaseDate,
				 characterIds: characterIds)
	}
}
