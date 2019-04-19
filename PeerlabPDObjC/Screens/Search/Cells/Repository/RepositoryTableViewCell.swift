//
//  RepositoryTableViewCell.swift
//  PeerlabPD
//
//  Created by Ivan.Kramarenko on 11.09.2018.
//  Copyright © 2018 IvanKram. All rights reserved.
//

import UIKit
import SDWebImage

class RepositoryTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!

    func configure(with viewModel: IRepositoryCellViewModel) {
		avatarView.sd_setImage(with: viewModel.userAvatar, placeholderImage: viewModel.placeholder)
        nameLbl.text = viewModel.name
        descriptionLbl.text = viewModel.repoDescription
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.avatarView.image = nil
    }

}
