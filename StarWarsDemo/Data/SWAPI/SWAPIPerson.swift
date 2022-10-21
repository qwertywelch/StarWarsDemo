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
	
	// leaving out fields not used by app
}

// For transforming the API object into our standard resource.
extension SWAPIPerson: SWAPIResponseDTO {
	typealias Resource = PersonModel
	
	func toDomainModel() -> PersonModel {
		PersonModel(name: name)
	}
}
