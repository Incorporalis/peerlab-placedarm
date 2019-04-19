//
//  ItemViperViewController.swift
//  PeerlabPD
//
//  Created by Ivan on 12/01/2019.
//  Copyright © 2019 IvanKram. All rights reserved.
//

import UIKit

protocol IItemViperViewInput: class, ShowActivityController, ShowAlertController {

    var navigationController: UINavigationController? { get }

    func config(with output: IItemViperViewOutput)
    func refreshUI(with props: ItemViperViewController.ItemViperViewControllerProps)

}

protocol IItemViperViewOutput: class {

	func viewIsReady()

}

class ItemViperViewController: BaseViewController, IItemViperViewInput {

    struct ItemViperViewControllerProps {
        var avatarImage: URL?
        var name: String?
        var descr: String?

        func placeholder() -> UIImage? {
            return UIImage(named: "profile_placeholder")
        }
    }

    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!

    // MARK: - Private properties -

    private(set) var output: IItemViperViewOutput!

    // MARK: - Configuration -

    func config(with output: IItemViperViewOutput) {
        self.output = output
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }

    func refreshUI(with props: ItemViperViewControllerProps) {
        avatarView.sd_setImage(with: props.avatarImage, placeholderImage: props.placeholder())
        nameLbl.text = props.name
        descriptionLbl.text = props.descr
    }

}
