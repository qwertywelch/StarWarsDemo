//
//  FilmDetailCharactersViewModel.swift
//  StarWarsDemo
//
//  Created by Nicholas Welch on 10/20/22.
//

import Foundation

/// View model for FilmDetailCharactersView. Retrieves characters from repository and provides their names to the collection view.
class FilmDetailCharactersViewModel {
	// delegate is weak to avoid this reference from preventing it from getting garbage collected
	// but *not* unowned so this view model could potentially be used without a delegate, such as in testing
	weak var delegate: ViewModelDelegate?
	private let repository: DataRepository
	private var status: ViewModelStatus = .idle {
		didSet {
			delegate?.updated(with: status)
		}
	}
	
	private let characterIds: [String]
	private var characters: [PersonModel] = []
	
	init(characterIds: [String], repository: DataRepository = SWAPIRepository.shared) {
		self.characterIds = characterIds
		self.repository = repository
	}
}

// MARK: Used by view
extension FilmDetailCharactersViewModel {
	var numberOfCharacters: Int {
		characters.count
	}
	
	// Fetch characters by their IDs from the repository.
	func loadCharacters() {
		Task {
			// To demonstrate parallel async requests, I will be loading each PersonModel within in a TaskGroup
			
			// To cut down on network requests, an alternate solution could be to load all PersonModels with the bulk
			// /people/ paged endpoint and then fetch them by ID in memory.
			
			// In an ideal world, the paged endpoints would allow fetching multiple resources by a list of their IDs at once.
			
			let characters = try? await withThrowingTaskGroup(of: PersonModel.self) { group -> [PersonModel] in
				for id in characterIds {
					group.addTask {
						let result = await self.repository.getPerson(id: id)
						switch result {
						case .success(let person):
							return person
						case .failure(let error):
							throw error
						}
					}
				}
				
				var resources: [PersonModel] = []
				
				for try await person in group {
					resources.append(person)
				}
				
				return resources
			}
			
			guard let characters = characters else {
				status = .error(DataRetrievalError.transport)
				
				return
			}
			
			self.characters = characters.sorted { $0.name < $1.name }
			status = .success
		}
	}
	
	func getCharacterName(for indexPath: IndexPath) -> String {
		characters[indexPath.row].name
	}
}
