//
//  SWAPIPagedResults.swift
//  StarWarsDemo
//
//  Created by Nicholas Welch on 10/20/22.
//

import Foundation

/// The format of the SWAPI endpoints that return multiple resources.
struct SWPagedResults<ResultType: SWAPIResponseDTO>: SWAPIResponseDTO {
	let count: Int
	let next: URL?
	let previous: URL?
	let results: [ResultType]
	
	typealias Resource = PagedResults<ResultType.Resource>
	
	func toDomainModel() throws -> Resource {
		PagedResults(total: count,
								 nextPage: pageFrom(next),
								 previousPage: pageFrom(previous),
								 results: try results.map { try $0.toDomainModel() })
	}
}

/// Helper to extract the page number from a SWAPI paginated response next/previous URLs
fileprivate func pageFrom(_ url: URL?) -> Int? {
	guard let url = url else { return nil }
	guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
	guard let pageStr = components.queryItems?.first(where: { $0.name == "page" })?.value else { return nil }
	
	return Int(pageStr)
}

