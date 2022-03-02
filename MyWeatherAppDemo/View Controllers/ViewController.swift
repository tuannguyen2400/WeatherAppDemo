//
//  ViewController.swift
//  MyWeatherAppDemo
//
//  Created by MT on 2/22/22.
//

import UIKit
import CoreLocation
// Location : CoreLocation
// Table view
// Custom Cell : Collection View
// API / Request to get the data

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var tabel : UITableView!
    var models = [DailyWeatherEntry]()
    let locationManager = CLLocationManager()
    var coordinates : CLLocationManager?
    var currentLocation: CLLocation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register 2 cells
        tabel.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.indentifier)
        tabel.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.indentifier)
        tabel.rowHeight = UITableView.automaticDimension
        tabel.dataSource = self
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
        
    }
    // Location
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
            
        }
        func requestWeatherForLocation() {
            guard let currentLocation = currentLocation else {
                return
            }
            let long = currentLocation.coordinate.longitude
            let lat = currentLocation.coordinate.latitude
            
            let urlString = "https://api.darksky.net/forecast/ddcc4ebb2a7c9930b90d9e59bda0ba7a/\(lat),\(long)?exclude=[flags,minutely]"
            let url = URL(string: urlString)!
            print(url)
            
            URLSession.shared.dataTask(with: url, completionHandler:{ data ,response, error in
                
                // validation
                guard let data = data ,error == nil  else {
                    print ("something went wrong")
                    return
                }
                
                
                // Convert data to models/some object
                
                var json : WeatherResponse?
                do {
                    json = try JSONDecoder().decode(WeatherResponse.self, from: data)
                }
                catch {
                    print("error: \(error)")
                    
                }
                guard let result = json else {
                    return
                }
                let entries = result.daily.data
                print(entries.count)
                self.models.append(contentsOf: entries)
                
                // update user interface
                DispatchQueue.main.async {
                    self.tabel.reloadData()
                    
                    self.tabel.tableHeaderView = self.createTableHeader()
                }
                
            }) .resume()
            
        }
        func createTableHeader() -> UIView {
            let headerVIew = UIView(frame : CGRect(x: 0,y: 0, width: view.frame.size.width, height: view.frame.size.width ))
            
            headerVIew.backgroundColor = .red
            
            return headerVIew
        }
        
    }
}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.indentifier,for: indexPath) as! WeatherTableViewCell
        cell.configure(with: models[indexPath.row])
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
