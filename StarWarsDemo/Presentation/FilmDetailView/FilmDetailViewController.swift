//
//  FilmDetailViewController.swift
//  StarWarsDemo
//
//  Created by Nicholas Welch on 10/19/22.
//

import Foundation
import UIKit

/// View that displays details about a single film.
class FilmDetailViewController: UIViewController {
	private let viewModel: FilmDetailViewModel
		
	private var scrollView: UIScrollView!
	private var contentStack: UIStackView!
	private var episodeLabel: UILabel!
	private var dateLabel: UILabel!
	private var crawlView: UILabel!
	private var characterCollectionView: FilmDetailCharactersView!
	private var collectionHeightConstraint: NSLayoutConstraint!
	
	init(viewModel: FilmDetailViewModel) {
		self.viewModel = viewModel
		
		// must call super.init after initializing properties, but before referencing self
		super.init(nibName: nil, bundle: nil)
		
		self.viewModel.delegate = self
	}
	
	// required to add our own init, will never be called because not using IB
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		super.loadView()
		
		scrollView = UIScrollView()
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.isDirectionalLockEnabled = true
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.backgroundColor = .black
		scrollView.alwaysBounceVertical = true

		view.addSubview(scrollView)
		
		contentStack = UIStackView()
		contentStack.translatesAutoresizingMaskIntoConstraints = false
		contentStack.spacing = 15
		contentStack.axis = .vertical
		
		scrollView.addSubview(contentStack)
		scrollView.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
		
		NSLayoutConstraint.activate([
			// pin scroll view to safe area edges
			scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),

			// pin stack view to scrollview edges
			contentStack.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
			contentStack.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
			contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 15),
			contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
			contentStack.widthAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.widthAnchor)
		])
		
		episodeLabel = UILabel()
		episodeLabel.translatesAutoresizingMaskIntoConstraints = false
		episodeLabel.textAlignment = .center
		episodeLabel.font = UIFont.preferredBoldFont(forTextStyle: .subheadline)
		episodeLabel.textColor = .lightGray

		dateLabel = UILabel()
		dateLabel.translatesAutoresizingMaskIntoConstraints = false
		dateLabel.font = UIFont.preferredBoldFont(forTextStyle: .subheadline)
		dateLabel.textColor = .lightGray

		let subtitleStack = UIStackView()
		subtitleStack.axis = .horizontal
		subtitleStack.distribution = .equalSpacing
		subtitleStack.addArrangedSubview(episodeLabel)
		subtitleStack.addArrangedSubview(dateLabel)
		
		crawlView = UILabel()
		crawlView.translatesAutoresizingMaskIntoConstraints = false
		crawlView.textAlignment = .justified
		crawlView.numberOfLines = 0
		crawlView.backgroundColor = .black
		crawlView.textColor = .systemYellow
			
		// set custom font for the crawl text
		if let crawlFont = UIFont(name: "ITC Franklin Gothic Std Demi", size: 18) {
			crawlView.font = crawlFont
		}
		
		let charactersLabel = UILabel()
		charactersLabel.font = UIFont.preferredBoldFont(forTextStyle: .subheadline)
		charactersLabel.text = "CHARACTERS IN THIS MOVIE"
		charactersLabel.textAlignment = .center
		charactersLabel.textColor = .lightGray

		characterCollectionView = FilmDetailCharactersView(viewModel: FilmDetailCharactersViewModel(characterIds: viewModel.characterIds))
		
		contentStack.addArrangedSubview(subtitleStack)
		contentStack.addArrangedSubview(crawlView)
		contentStack.addArrangedSubview(charactersLabel)
		contentStack.addArrangedSubview(characterCollectionView)
		
		collectionHeightConstraint = characterCollectionView.heightAnchor.constraint(equalToConstant: 60)
	
		NSLayoutConstraint.activate([
			characterCollectionView.leadingAnchor.constraint(equalTo: contentStack.leadingAnchor),
			characterCollectionView.trailingAnchor.constraint(equalTo: contentStack.trailingAnchor),
			collectionHeightConstraint
		])
	}

	override func viewDidLoad() {
		navigationItem.title = viewModel.navTitle
	}
	
	override func viewWillAppear(_ animated: Bool) {
		updated(with: .success)
	}
	
	// Called when subviews are laid out, notably when the view area changes such as when device is rotated
	// Since I want the collection view to display all its contents without scrolling, this is a good time
	// to adjust its height constraint
	override func viewDidLayoutSubviews() {
		// make the collection view layout recalculate its layout to match its new constrained width
		characterCollectionView.collectionViewLayout.invalidateLayout()
		// update the collection view's layout immediately so we can get its new content height
		characterCollectionView.layoutIfNeeded()
		
		// set the collection view to be the same height as its content
		let collectionContentHeight = characterCollectionView.collectionViewLayout.collectionViewContentSize.height
		collectionHeightConstraint.constant = collectionContentHeight
	}
}

// MARK: ViewModelDelegate
extension FilmDetailViewController: ViewModelDelegate {
	func updated(with status: ViewModelStatus) {
		// run on main thread
		Task { @MainActor in
			switch status {
			case .idle:
				break
			case .loading:
				// this view model has its data passed to it, so not adding any loading indicators
				break
			case .success:
				episodeLabel.text = viewModel.episodeText
				dateLabel.text = viewModel.releaseDateText
				crawlView.text = viewModel.openingCrawlText
				
				characterCollectionView.populate()
			case .error(let error):
				present(UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert), animated: true)
			}
		}
	}
}
