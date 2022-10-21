//
//  ViewModelDelegate.swift
//  StarWarsDemo
//
//  Created by Nicholas Welch on 10/20/22.
//

import Foundation

/// The ViewModelDelegate of a ViewModel will typically be a view/controller itself, but it doesn't have to be!
/// Set to conform to AnyObject since it is for class instances and we want to hold a weak reference to it, which is only possible if it is class bound
protocol ViewModelDelegate: AnyObject {
	func updated(with state: ViewModelStatus)
}

/// Used to inform a ViewModelDelegate of a change in state
enum ViewModelStatus {
	case idle
	case loading
	case success
	case error(Error)
}
