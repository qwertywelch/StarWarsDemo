//
//  SWAPIRepository.swift
//  StarWarsDemo
//
//  Created by Nicholas Welch on 10/19/22.
//

import Foundation

/// SWAPIRepository conforms to DataRepository and is backed by the HTTP API at swapi.dev.
class SWAPIRepository {
	static let shared = SWAPIRepository()
	
	private let apiRoot = "https://swapi.py4e.com/api/" // identical but with less lag than https://swapi.dev/api/
	private let decoder = JSONDecoder()
	
	// create custom URLSession so I can override the timeout
	private let session: URLSession = {
		let config = URLSessionConfiguration.default
		config.timeoutIntervalForResource = 15
		return URLSession(configuration: config)
	}()
	
	/// Make a request to the Star Wars API. Provide the endpoint, type of data expected, and optionally some query string parameters.
	func request<SWResource: SWAPIResponseDTO>(to endpoint: String, dataType: SWResource.Type, queryParams: [String: LosslessStringConvertible] = [:]) async -> DataSourceResult<SWResource.Resource> {
		var urlString = "\(apiRoot)\(endpoint)/"
		
		// I had code here to support the API's wookiee format, but it alters the response fields :(
		
		let queryString = queryParams.map { "\($0)=\($1)" }.joined(separator: "&")
		
		if queryString != "" {
			urlString.append("?\(queryString)")
		}

		guard let url = URL(string: urlString) else {
			return .failure(DataRetrievalError.request)
		}
		
		var urlRequest: URLRequest = URLRequest(url: url)
		
		urlRequest.httpMethod = "GET"
		urlRequest.addValue("application/json", forHTTPHeaderField: "Accept") // API returns JSON only
		
		guard let (data, response) = try? await session.data(for: urlRequest) else {
			return .failure(DataRetrievalError.transport)
		}
		
		// if the response is not an HTTPURLResponse, something went wrong
		guard let httpResponse = response as? HTTPURLResponse else {
			return .failure(DataRetrievalError.transport)
		}
		
		if httpResponse.statusCode == 404 {
			return .failure(DataRetrievalError.missing)
		}
		if httpResponse.statusCode > 400 && httpResponse.statusCode < 500 {
			return .failure(DataRetrievalError.request)
		}
		if httpResponse.statusCode != 200 {
			return .failure(DataRetrievalError.source)
		}

		guard let apiResponse = try? decoder.decode(dataType, from: data) else {
			return .failure(.decoding)
		}
		
		guard let model = try? apiResponse.toDomainModel() else {
			return .failure(.decoding)
		}
		
		return .success(model)
	}
}

// MARK: DataRepository 
extension SWAPIRepository: DataRepository {
	func getFilms(page: Int) async -> DataSourceResult<PagedResults<FilmModel>> {
		await request(to: "films", dataType: SWPagedResults<SWAPIFilm>.self, queryParams: ["page": page])
	}
	
	func getFilm(id: String) async -> DataSourceResult<FilmModel> {
		await request(to: "films/\(id)", dataType: SWAPIFilm.self)
	}
	
	func getPeople(page: Int) async -> DataSourceResult<PagedResults<PersonModel>> {
		await request(to: "people", dataType: SWPagedResults<SWAPIPerson>.self, queryParams: ["page": page])
	}
	
	func getPerson(id: String) async -> DataSourceResult<PersonModel> {
		await request(to: "people/\(id)", dataType: SWAPIPerson.self)
	}
}

/// A response returned from the SWAPI. Has a method to convert to its DomainModel counterpart.
protocol SWAPIResponseDTO: Decodable {
	associatedtype Resource: DomainModel
	
	func toDomainModel() throws -> Resource
}

