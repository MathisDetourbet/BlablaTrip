//
//  SearchResultsViewController.swift
//  BlablaTrip
//
//  Created by Mathis Detourbet on 19/2/20.
//  Copyright © 2020 Mathis Detourbet. All rights reserved.
//

import UIKit
import RxSwift

final class SearchResultsViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private weak var tableView: UITableView!
    fileprivate var viewModel: SearchResultsViewModel!
    
    static func instantiate(with viewModel: SearchResultsViewModel) -> SearchResultsViewController {
        let searchVC = SearchResultsViewController()
        searchVC.viewModel = viewModel
        return searchVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = makeTableView()
        
        viewModel
            .fetchTrips()
            .subscribeOn(MainScheduler.instance)
            .subscribe(onCompleted: { [weak self] in
                self?.tableView.reloadData()
            }) { [weak self] error in
                self?.displayError(error)
            }.disposed(by: disposeBag)
    }
    
    private func displayError(_ error: Error) {
        
    }
    
    private func makeTableView() -> UITableView {
        let tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 150
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        ])
        
        let tripTableViewCellNib = UINib(nibName: String(describing: TripTableViewCell.self), bundle: nil)
        tableView.register(tripTableViewCellNib, forCellReuseIdentifier: TripTableViewCell.cellIdentifier)
        
        return tableView
    }
}

// MARK: -  TableView Data Source
extension SearchResultsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowIn(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tripCell = tableView.dequeueReusableCell(withIdentifier: TripTableViewCell.cellIdentifier, for: indexPath) as? TripTableViewCell else {
            fatalError("Error Instantiate Dequeue Reusable Cell. Identifier is probably wrong.")
        }
        let tripViewModel = viewModel.elementAt(indexPath)
        tripCell.fill(with: tripViewModel)
        return tripCell
    }
}

// MARK: - TableView Delegate
extension SearchResultsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

