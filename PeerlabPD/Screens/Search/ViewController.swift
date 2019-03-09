//
//  ViewController.swift
//  PeerlabPD
//
//  Created by Ivan.Kramarenko on 10.09.2018.
//  Copyright © 2018 IvanKram. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {

    enum CellIdentifiers: String {
        case repository = "RepositoryTableViewCell"
    }

    @IBOutlet weak var tableView: UITableView!
	var refreshControl = UIRefreshControl()

    // MARK: - Private properties -

    private(set) var viewModel: IRepositoriesViewModel!

    // MARK: - Configuration -

    func config(viewModel: IRepositoriesViewModel) {
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
		updateTableView()
        viewModel.viewIsReady()
    }

    private func updateTableView() {
        tableView.dataSource = self

        //remove standard header offset
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        tableView.tableFooterView = UIView(frame: frame)

        refreshControl.addTarget(self, action: #selector(refreshView), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }

    override func hideHUD() {
        super.hideHUD()

        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }

	@objc func refreshView() {
		viewModel.refreshData()
    }

}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.elements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.repository.rawValue) as! RepositoryTableViewCell
        cell.configure(with: viewModel.elements[indexPath.row])
        return cell
    }

}

extension ViewController: RepositoriesViewModelDelegate {

    func refreshUI() {
        tableView.reloadData()
    }

}

