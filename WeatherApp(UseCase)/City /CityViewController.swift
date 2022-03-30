//
//  CityViewController.swift
//  WeatherApp(UseCase)
//
//  Created by MT on 3/28/22.
//

import UIKit

class CityViewController: UIViewController {
    static func create(city: String) -> CityViewController {
        let storyboard = UIStoryboard(name: "City", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "CityViewController") as! CityViewController
        viewController.viewModel = CityViewModel(city: city)
        return viewController
    }

    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    private var viewModel: CityViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBinding()
        viewModel.fetchWeather()
    }
}

private extension CityViewController {
    func setupView() {
        setUpNavigationBar()
        setupWeatherIconImageView()
        setupLabel(humidityLabel)
        setupLabel(weatherDescriptionLabel)
        setupLabel(temperatureLabel)
    }

    func setUpNavigationBar() {
        title = viewModel.city
    }

    func setupBinding() {
        viewModel.reloadImageData = { [weak self] data in
            DispatchQueue.main.async {
                self?.weatherIconImageView.image = UIImage(data: data)
            }
        }

        //ab
        viewModel.reloadData = { [weak self] data in
            DispatchQueue.main.async {
                self?.humidityLabel.text = data.humidity
                self?.weatherDescriptionLabel.text = data.description
                self?.temperatureLabel.text = data.temperature
            }
        }
    }

    func setupWeatherIconImageView() {
        weatherIconImageView.contentMode = .scaleAspectFit
    }

    func setupLabel(_ label: UILabel) {
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .darkText
        label.textAlignment = .left
        label.numberOfLines = 0
        label.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0 , alpha: 1.0)
        view.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0 , alpha: 1.0)
    }
}
