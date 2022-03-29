//
//  HomeTableViewCell.swift
//  WeatherApp(UseCase)
//
//  Created by MT on 3/28/22.
//

import UIKit

final class HomeTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    func config(with title: String) {
        titleLabel.text = title
    }
}

private extension HomeTableViewCell {
    func setupView() {
        titleLabel.font = .systemFont(ofSize: 18, weight: .medium)
        titleLabel.textColor = .darkText
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
    }
}
