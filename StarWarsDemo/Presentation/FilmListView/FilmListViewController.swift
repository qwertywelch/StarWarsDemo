//
//  FilmListViewController.swift
//  StarWarsDemo
//
//  Created by Nicholas Welch on 10/19/22.
//

import Foundation
import UIKit

/// The FilmListViewController is a controller with a table view that lists Star Wars movies. It is a subclass of
/// UITableViewController to take advantage of its built-in niceties over a UIViewController + UITableView.
class FilmListViewController: UITableViewController {
	private let viewModel: FilmListViewModel
	
	let sortButton = UIBarButtonItem(title: "Sort")

	// A mocked ViewModel could be injected here
	init(viewModel: FilmListViewModel = FilmListViewModel()) {
		self.viewModel = viewModel
		
		// must call super.init after initializing properties, but before referencing self
		super.init(nibName: nil, bundle: nil)
		
		self.viewModel.delegate = self
	}
	
	// required to add our own init, will never be called
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		navigationItem.title = "Star Wars Movies"
		
		refreshControl = UIRefreshControl()
		refreshControl!.addTarget(viewModel, action: #selector(viewModel.load), for: .valueChanged)
		refreshControl?.beginRefreshing()

		tableView.register(FilmListViewCell.self, forCellReuseIdentifier: "filmCell")
		
		navigationItem.rightBarButtonItem = sortButton
	}
	
	// have our view model start loading what it needs before the view goes onscreen
	override func viewWillAppear(_ animated: Bool) {
		viewModel.load()
	}
	
	// when this view goes offscreen, make sure the row is deselected
	override func viewDidDisappear(_ animated: Bool) {
		if let selectedRow = tableView.indexPathForSelectedRow {
			tableView.deselectRow(at: selectedRow, animated: false)
		}
	}
	
	// UIMenu children are immutable, must re-generate it to change their states
	func generateSortMenu() {
		let alphaSortAction = UIAction(title: "Alphabetical",
																	 image: UIImage(systemName: "textformat.abc"),
																	 identifier: .init(SortOrder.alphabetical.rawValue),
																	 state: viewModel.sortOrder == .alphabetical ? .on : .off,
																	 handler: sortActionSelected)
		let canonSortAction = UIAction(title: "Canonical",
																	 image: UIImage(systemName: "number"),
																	 identifier: .init(SortOrder.canonical.rawValue),
																	 state: viewModel.sortOrder == .canonical ? .on : .off,
																	 handler: sortActionSelected)
		let releasedSortAction = UIAction(title: "Release Date",
																			image: UIImage(systemName: "calendar"),
																			identifier: .init(SortOrder.released.rawValue),
																			state: viewModel.sortOrder == .released ? .on : .off,
																			handler: sortActionSelected)
		
		
		sortButton.menu = UIMenu(title: "", children: [alphaSortAction, canonSortAction, releasedSortAction])
	}
	
	func sortActionSelected(action: UIAction) {
		guard let newOrder = SortOrder.init(rawValue: action.identifier.rawValue) else {
			return
		}
		
		viewModel.setOrder(newOrder)
	}
}

// MARK: UITableViewDataSource
extension FilmListViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.numberOfFilms
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "filmCell", for: indexPath) as! FilmListViewCell
		
		cell.populate(data: viewModel.getData(for: indexPath))
		
		return cell
	}
}

// MARK: UITableViewDelegate
extension FilmListViewController {
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		navigationController?.pushViewController(FilmDetailViewController(viewModel: viewModel.getDetailViewModel(for: indexPath)), animated: true)
	}
}

// MARK: ViewModelDelegate
extension FilmListViewController: ViewModelDelegate {
	func updated(with state: ViewModelStatus) {
		// run on main thread
		Task { @MainActor in
			switch state {
			case .idle:
				break
			case .loading:
				if refreshControl?.isRefreshing == false {
					refreshControl?.beginRefreshing()
				}
			case .success:
				refreshControl?.endRefreshing()
				generateSortMenu()
				tableView.reloadData()
			case .error(_):
				refreshControl?.endRefreshing()
				
				let errorAlert = UIAlertController(title: "Error Loading", message: "Something went wrong loading the data. Please try again.", preferredStyle: .alert)
				let okButton = UIAlertAction(title: "OK", style: .default)
				errorAlert.addAction(okButton)
				
				present(errorAlert, animated: true)
			}
		}
	}
	
}
