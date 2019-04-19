//
//  SearchViperViewController.swift
//  PeerlabPD
//
//  Created by Ivan on 12/01/2019.
//  Copyright © 2019 IvanKram. All rights reserved.
//

import UIKit

protocol ISearchViperViewInput: class, ShowActivityController, ShowAlertController {

    var navigationController: UINavigationController? { get }

    func config(with output: ISearchViperViewOutput)
    func refreshUI()

}

protocol ISearchViperViewOutput: class {

    var elements: [IRepositoryCellViewModel] { get }

	func refreshData()
    func viewIsReady()
    func viewDidPressDetailsButton(with index: Int)

}

class SearchViperViewController: BaseViewController, ISearchViperViewInput {

    enum CellIdentifiers: String {
        case repository = "RepositoryTableViewCell"
    }

    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()

    // MARK: - Private properties -

    private(set) var output: ISearchViperViewOutput!

    // MARK: - Configuration -

    func config(with output: ISearchViperViewOutput) {
        self.output = output
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = UserDefaults.standard.object(forKey: "RepositoryName") as? String
        updateTableView()
        output.viewIsReady()
    }

    private func updateTableView() {
        tableView.dataSource = self
        tableView.delegate = self

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
        output.refreshData()
    }

    func refreshUI() {
        tableView.reloadData()
    }

}

extension SearchViperViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output.elements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.repository.rawValue) as! RepositoryTableViewCell
        cell.configure(with: output.elements[indexPath.row])
        return cell
    }

}

extension SearchViperViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output.viewDidPressDetailsButton(with: indexPath.row)
    }

}
