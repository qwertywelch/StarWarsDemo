//
//  DataRepository.swift
//  StarWarsDemo
//
//  Created by Nicholas Welch on 10/19/22.
//

import Foundation

/// A DataRepository defines methods to get different kinds of Star Wars data from a source. It is a protocol which can
/// be conformed to; most importantly by the SWAPIRepository, or can be mocked in testing. It returns DomainModels which
/// are normalized from the formats retrieved from the actual data sources.
protocol DataRepository {
	func getFilms(page: Int) async -> DataSourceResult<PagedResults<FilmModel>>
	func getFilm(id: String) async -> DataSourceResult<FilmModel>
	
	func getPerson(id: String) async -> DataSourceResult<PersonModel>
	
	// only film and people resources are used in this demo
}

/// DataRepository methods wrap their result in a DataSourceResult, which has a success and failure
/// case. A success result includes the response data, whereas the failure result contains the error.
enum DataSourceResult<Value> {
	case success(_ response: Value)
	case failure(_ error: DataRetrievalError)
}

/// All models retrieved from a DataSource conform to DomainModel.
protocol DomainModel {
	
}

/// When fetching lists of models, they are returned in a paginated manner.
struct PagedResults<Resource: DomainModel>: DomainModel {
	let total: Int
	let nextPage: Int?
	let previousPage: Int?
	
	let results: [Resource]
}

/// DataRetrievalError cases allow you to specify what kind of error caused the failure in a DataSourceResult.
enum DataRetrievalError: Error {
	/// Problem with the request
	case request
	/// Problem with making the request.
	case transport
	/// Problem decoding response.
	case decoding
	/// Requested data is missing.
	case missing
	/// Problem at the source.
	case source
}
