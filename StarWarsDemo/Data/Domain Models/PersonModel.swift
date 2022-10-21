//
//  PersonModel.swift
//  StarWarsDemo
//
//  Created by Nicholas Welch on 10/19/22.
//

import Foundation

/// A single Star Wars character.
/// See https://swapi.dev/documentation#films.
struct PersonModel: DomainModel {
	let name: String
}
