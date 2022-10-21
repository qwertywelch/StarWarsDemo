//
//  DateHelpers.swift
//  StarWarsDemo
//
//  Created by Nicholas Welch on 10/21/22.
//

import Foundation

let dateFormatterConvert: DateFormatter = {
	let formatter = DateFormatter()
	
	formatter.dateFormat = "yyyy-MM-dd"
	
	return formatter
}()

let dateFormatterDisplay: DateFormatter = {
	let formatter = DateFormatter()
	
	formatter.dateFormat = "MMM dd, yyyy"
	
	return formatter
}()
