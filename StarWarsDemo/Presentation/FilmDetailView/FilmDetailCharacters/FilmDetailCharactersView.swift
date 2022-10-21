//
//  FilmDetailCharactersView.swift
//  StarWarsDemo
//
//  Created by Nicholas Welch on 10/20/22.
//

import Foundation
import UIKit

/// Collection view of film characters.
class FilmDetailCharactersView: UICollectionView {
	private let viewModel: FilmDetailCharactersViewModel
	private var status: ViewModelStatus = .loading
		
	init(viewModel: FilmDetailCharactersViewModel) {
		self.viewModel = viewModel
		
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		layout.itemSize = CGSize(width: 100, height: 60)
		
		super.init(frame: .zero, collectionViewLayout: layout)
		
		self.viewModel.delegate = self

		dataSource = self
		delegate = self
		isScrollEnabled = false
		
		register(FilmDetailCharactersViewCell.self, forCellWithReuseIdentifier: "characterCell")
		register(CollectionStatusHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func populate() {
		// only fetch if none have been loaded
		if viewModel.numberOfCharacters == 0 {
			viewModel.loadCharacters()
		}
	}
}

// MARK: UICollectionViewDataSource
extension FilmDetailCharactersView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		viewModel.numberOfCharacters
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCell", for: indexPath) as! FilmDetailCharactersViewCell
		
		// default cell to transparent so we can fade it in
		cell.contentView.alpha = 0
		cell.populate(name: viewModel.getCharacterName(for: indexPath))
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		if kind == UICollectionView.elementKindSectionHeader {
			if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? CollectionStatusHeader {
				// if we have an error status, show message to user, otherwise show activity indicator
				switch status {
				case .error(_):
					header.showText("Unable to load characters.")
				default:
					header.showActivityIndicator()
				}
				
				return header
			}
		}
		
		return UICollectionReusableView()
	}
}

// MARK: UICollectionViewDelegate
extension FilmDetailCharactersView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		// if cell is transparent, fade it in!
		if cell.contentView.alpha == 0 {
			let delay = Double(indexPath.row + 1) * 0.1
			
			UIView.animate(withDuration: 0.2, delay: delay, options: .curveEaseOut) {
				cell.contentView.alpha = 1
			}
		}
	}
}

// MARK: UICollectionViewDelegateFlowLayout
extension FilmDetailCharactersView: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		// if we are loading or have an error, show the collection header
		switch status {
		case .loading, .error(_):
			return CGSize(width: 1, height: 60)
		case .success, .idle:
			return .zero
		}
	}
}

// MARK: ViewModelDelegate
extension FilmDetailCharactersView: ViewModelDelegate {
	func updated(with status: ViewModelStatus) {
		self.status = status
		// run on main thread
		Task { @MainActor in
			reloadData()
			
			// required on iOS 15+, otherwise it sticks to its initial size and doesn't show all the cells
			invalidateIntrinsicContentSize()
		}
	}
}
