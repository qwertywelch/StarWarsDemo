//
//  FilmDetailCharactersViewCell.swift
//  StarWarsDemo
//
//  Created by Nicholas Welch on 10/20/22.
//

import Foundation
import UIKit

/// A collection view cell with a character's name.
class FilmDetailCharactersViewCell: UICollectionViewCell {
	private let nameLabel: UILabel
	
	override init(frame: CGRect) {
		nameLabel = UILabel()
		nameLabel.font = UIFont.preferredFont(forTextStyle: .callout)
		nameLabel.textColor = .white
		nameLabel.textAlignment = .center
		nameLabel.numberOfLines = 2
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		
		super.init(frame: frame)

		// subviews go in the cell's contentView!
		contentView.addSubview(nameLabel)
		
		NSLayoutConstraint.activate([
			nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
			nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func populate(name: String) {
		nameLabel.text = name
	}
}
