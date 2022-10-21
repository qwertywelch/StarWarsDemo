//
//  FilmListViewCell.swift
//  StarWarsDemo
//
//  Created by Nicholas Welch on 10/20/22.
//

import Foundation
import UIKit

/// A table view cell with a film's episode number, title, and release date.
class FilmListViewCell: UITableViewCell {
	private let episodeLabel: UILabel
	private let titleLabel: UILabel
	private let dateLabel: UILabel
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		episodeLabel = UILabel()
		episodeLabel.font = UIFont.preferredBoldFont(forTextStyle: .callout)
		episodeLabel.textColor = .lightGray
		episodeLabel.translatesAutoresizingMaskIntoConstraints = false
		
		titleLabel = UILabel()
		titleLabel.font = UIFont.preferredBoldFont(forTextStyle: .headline)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		
		dateLabel = UILabel()
		dateLabel.font = UIFont.preferredBoldFont(forTextStyle: .callout)
		dateLabel.textColor = .lightGray
		dateLabel.translatesAutoresizingMaskIntoConstraints = false
		
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		accessoryType = .disclosureIndicator

		addSubview(episodeLabel)
		addSubview(titleLabel)
		addSubview(dateLabel)
		
		// labels stacked vertically with 5 points of padding between them, pinned to the edges of the cell
		NSLayoutConstraint.activate([
			episodeLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
			episodeLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
			episodeLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
			
			titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
			titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
			titleLabel.topAnchor.constraint(equalTo: episodeLabel.bottomAnchor, constant: 5),
			
			dateLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
			dateLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
			dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
			dateLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func populate(data: (title: String, releaseDate: String, episodeNum: Int)) {
		episodeLabel.text = "EPISODE \(data.episodeNum)"
		titleLabel.text = data.title
		dateLabel.text = data.releaseDate
	}
}
