//
//  HourlyTableViewCell.swift
//  MyWeatherAppDemo
//
//  Created by MT on 2/22/22.
//

import UIKit

class HourlyTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    static let indentifier = "HourlyTableViewCell"
    static func nib () -> UINib {
        return UINib (nibName: "HourlyTableViewCell", bundle: nil)
        
    }
    
}
