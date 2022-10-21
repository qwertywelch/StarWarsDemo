//
//  CollectionStatusHeader.swift
//  StarWarsDemo
//
//  Created by Nicholas Welch on 10/21/22.
//

import Foundation
import UIKit

/// Collection header view for showing a loading indicator or text label.
class CollectionStatusHeader: UICollectionReusableView {
	private let activityIndicator: UIActivityIndicatorView
	private let textLabel: UILabel
	
	override init(frame: CGRect) {
		activityIndicator = UIActivityIndicatorView(style: .large)
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		
		textLabel = UILabel()
		textLabel.translatesAutoresizingMaskIntoConstraints = false
		textLabel.numberOfLines = 2
		
		super.init(frame: frame)
		
		addSubview(activityIndicator)
		addSubview(textLabel)
		
		NSLayoutConstraint.activate([
			activityIndicator.leadingAnchor.constraint(equalTo: leadingAnchor),
			activityIndicator.trailingAnchor.constraint(equalTo: trailingAnchor),
			activityIndicator.topAnchor.constraint(equalTo: topAnchor),
			activityIndicator.bottomAnchor.constraint(equalTo: bottomAnchor),
			
			textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
			textLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
			textLabel.topAnchor.constraint(equalTo: topAnchor),
			textLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func showText(_ text: String) {
		textLabel.text = text
		textLabel.isHidden = false
		activityIndicator.stopAnimating()
		activityIndicator.isHidden = true
	}
	
	func showActivityIndicator() {
		textLabel.isHidden = true
		activityIndicator.startAnimating()
		activityIndicator.isHidden = false
	}
}
