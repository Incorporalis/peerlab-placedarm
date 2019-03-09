//
//  ReduxViewController.swift
//  PeerlabPD
//
//  Created by Ivan on 09/03/2019.
//  Copyright © 2019 IvanKram. All rights reserved.
//

import UIKit
import SDWebImage

class ReduxViewController: BaseViewController {
    enum Props {
        struct Repository {
            let name: String
            let descr: String
            let image: URL?
        }
        
        case loading
        case repositories(repositories: [Repository], refresh: Command)
    }

    var props = Props.loading {
        didSet {
            switch props {
            case .loading:
                showHUD()
                tableView.reloadData()
            case .repositories:
                hideHUD()
                tableView.reloadData()
            }
        }
    }

    enum CellIdentifiers: String {
        case repository = "RepositoryTableViewCell"
    }

    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()


    override func viewDidLoad() {
        super.viewDidLoad()
        updateTableView()
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
        guard case let .repositories(_, command) = props else {
            fatalError()
        }

        command.run()
    }

}

extension ReduxViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch props {
        case .loading:
            return 0
        case .repositories(let reps, _):
			return reps.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard case let .repositories(reps, _) = props else {
            fatalError()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.repository.rawValue) as! RepositoryTableViewCell

        let curRep = reps[indexPath.row]
        cell.nameLbl.text = curRep.name
        cell.descriptionLbl.text = curRep.descr
        cell.avatarView.sd_setImage(with: curRep.image)

        return cell
    }
}
