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
	let birthYear: String
	let eyeColor: String
	let gender: String
	let hairColor: String
	let height: String
	let mass: String
	let skinColor: String
	let homeworld: String
}
