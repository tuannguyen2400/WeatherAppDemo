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

class ViewController: UIViewController, CLLocationManagerDelegate,UITableViewDelegate {
    
    @IBOutlet var tabel : UITableView!
    var models = [DailyWeatherEntry]()
    var hourlyModels = [HourlyWeatherEntry]()
    let locationManager = CLLocationManager()
    var coordinates : CLLocationManager?
    var currentLocation: CLLocation?
    var current: CurrentWeather?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register 2 cells
        tabel.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.indentifier)
        tabel.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.indentifier)
        tabel.rowHeight = UITableView.automaticDimension
        tabel.dataSource = self
        tabel.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0 , alpha: 1.0)
        view.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0 , alpha: 1.0)
     
        
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
            
            let urlString = "http://api.worldweatheronline.com/premium/v1/weather.ashx?key=0c3821cc308b46fb8a594405221403&q=48.85%2C2.35&num_of_days=2&tp=3&format=xml&fbclid=IwAR2yglbvPumf5HOV4tPj5DSRcwEAnkjkhETIrjSJrbi9j9PcVnCRdgQO9f4"
            
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
                let current = result .currently
                self.current = current
                
                // update user interface
                DispatchQueue.main.async {
                    self.tabel.reloadData()
                    self.hourlyModels = result.hourly.data
                    self.tabel.tableHeaderView = self.createTableHeader()
                }
                
            }) .resume()
        }
    }
}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            // 1 cell that is collectiontableviewcell
            return 1
        }
        // return models count
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.indentifier,for: indexPath) as! HourlyTableViewCell
            cell.configure(with: hourlyModels)
            cell.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0 , alpha: 1.0)
            
            return cell
            
        }
        //
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.indentifier,for: indexPath) as! WeatherTableViewCell
        cell.configure(with: models[indexPath.row])
        cell.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0 , alpha: 1.0)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
    }
    func createTableHeader() -> UIView {
        let headerVIew = UIView(frame : CGRect(x: 0,y: 0, width: view.frame.size.width, height: view.frame.size.width ))
        
        headerVIew.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0 , alpha: 1.0)
        
        let locationLabel = UILabel(frame: CGRect(x: 0,y: 0, width: view.frame.size.width-20, height: headerVIew.frame.size.height/5))
        let summaryLabel = UILabel(frame: CGRect(x: 10,y: 20+locationLabel.frame.size.height,width: view.frame.size.width-20, height : headerVIew.frame.size.height/5))
        let tempLabel = UILabel(frame: CGRect(x: 10 , y:20+locationLabel.frame.size.height+summaryLabel.frame.size.height,width: view.frame.size.width-20, height: headerVIew.frame.size.height/2))
        
        headerVIew.addSubview(locationLabel)
        headerVIew.addSubview(tempLabel)
        headerVIew.addSubview(summaryLabel)
        
        tempLabel.textAlignment = .center
        locationLabel.textAlignment = .center
        summaryLabel.textAlignment = .center
        
        locationLabel.text = "Current Location"
        guard let currentWeather = self.current else {
            return UIView()
        }
        
        tempLabel.text = "\(currentWeather.temperature)°"
        tempLabel.font = UIFont(name: "Helvetica-Bold", size: 32)
        summaryLabel.text = "Clear"
        
        return headerVIew
    }
}

