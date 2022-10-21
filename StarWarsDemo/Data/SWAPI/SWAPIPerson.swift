//
//  SWAPIPerson.swift
//  StarWarsDemo
//
//  Created by Nicholas Welch on 10/19/22.
//

import Foundation

/// A single Star Wars person resource from the Star Wars API (https://swapi.dev/documentation#people)
/// This is a data transfer object used for decoding the API response, and transforming it into a domain resource.
struct SWAPIPerson {
	let name: String
	let birth_year: String
	let eye_color: String
	let gender: String
	let hair_color: String
	let height: String
	let mass: String
	let skin_color: String
	let homeworld: String
}

// For transforming the API object into our standard resource.
extension SWAPIPerson: SWAPIResponseDTO {
	typealias Resource = PersonModel
	
	func toDomainModel() -> PersonModel {
		PersonModel(name: name, birthYear: birth_year, eyeColor: eye_color, gender: gender, hairColor: hair_color, height: height, mass: mass, skinColor: skin_color, homeworld: homeworld)
	}
}
