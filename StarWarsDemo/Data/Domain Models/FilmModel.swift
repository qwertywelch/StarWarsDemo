//
//  FilmModel.swift
//  StarWarsDemo
//
//  Created by Nicholas Welch on 10/19/22.
//

import Foundation

/// A single Star Wars film.
struct FilmModel: DomainModel {
	let title: String
	let episodeNum: Int
	let openingCrawl: String
	let releaseDate: Date
	let characterIds: [String]
}
