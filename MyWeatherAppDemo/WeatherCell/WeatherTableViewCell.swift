//
//  WeatherTableViewCell.swift
//  MyWeatherAppDemo
//
//  Created by MT on 2/22/22.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var highTempLabel: UILabel!
    @IBOutlet var lowTempLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    static let indentifier = "WeatherTableViewCell"
    static func nib () -> UINib {
        return UINib (nibName: "WeatherTableViewCell", bundle: nil)
        
    }
    func configure(with model : DailyWeatherEntry) {
        self.highTempLabel.textAlignment = .center
        self.lowTempLabel.textAlignment = .center
        self.lowTempLabel.text = "\(Int(model.temperatureLow))°"
        self.highTempLabel.text = "\(Int(model.temperatureHigh))°"
        self.dayLabel.text = getDayForDate(Date(timeIntervalSince1970: Double(model.time)))
        self.iconImageView.contentMode = .scaleAspectFit
        
        let icon = model.icon.lowercased()
        if icon.contains("Clear") {
            self .iconImageView.image = UIImage(named: "Clear")
        }
        else if icon.contains("Rain") {
            self .iconImageView.image = UIImage(named: "Rain")
        }
        else {
            
            // Cloud Icon
            self .iconImageView.image = UIImage(named : "Clear")
            
        }
        
    }
    func getDayForDate(_ date: Date?) -> String {
        guard let inputDate = date else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE" // Monday
        return formatter.string(from: inputDate)
        
    }
}

