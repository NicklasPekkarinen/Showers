//
//  MainTableViewController.swift
//  Labb 1 Swift
//
//  Created by Nicklas Pekkarinen on 2020-02-05.
//  Copyright © 2020 Nicklas Pekkarinen. All rights reserved.
//

import UIKit
import Lottie

class MainTableViewController: UITableViewController {
    
    var savedLocations : Array<String>!
    var itemList : Array<String>!
    let defaults = UserDefaults.standard
    var forecasts : Array<Forecast> = []
    var selectedRow : Int!
    
    struct CityInfo {
        static var cityName = ""
    }
    
    // MARK: - Lifetime
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCities()
        saveData(list: self.itemList, key: "cityList")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadSavedLocations()
        getForecasts()
    }
    
    func loadCities() {
        self.itemList = []
        let cityParse = CityParse()
        guard let cityList = cityParse.parse() else { return }
        for city in cityList {
            self.itemList.append(city)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! CityTableViewCell

        if (view.frame.size.width <= 320) {
            cell.cityLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
            cell.tempLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        }
        
        if forecasts.count != 0 {
            let forecast = forecasts[indexPath.row]
            cell.cityLabel.text = forecast.name
            cell.tempLabel.text = String(Int(forecast.main.temp.rounded())) + "°C"
            cell.animatedWeatherIcon.animation = Animation.named(forecast.weather[0].icon)
            cell.animatedWeatherIcon.loopMode = .loop
            cell.animatedWeatherIcon.play()
        }
        return cell
    }
    
    func getForecasts() {
        self.forecasts.removeAll()
        let weatherAPI = WeatherAPI()
        for location in savedLocations {
            weatherAPI.getWeatherData(cityName: location) { (result) in
                switch result {
                case .success(let forecast) : DispatchQueue.main.async {
                    self.forecasts.append(forecast)
                    self.tableView.reloadData()
                }
                case .failure(let error) : print("Error: \(error)")
                }
            }
        }
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            forecasts.remove(at: indexPath.row)
            savedLocations.remove(at: indexPath.row)
            saveData(list: savedLocations, key: "savedLocations")
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        self.performSegue(withIdentifier: "detailsSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailsSegue") {
            let nextView = segue.destination as! DetailsViewController
            nextView.forecast = forecasts[selectedRow]
        }
        if (segue.identifier == "searchSegue") {
            let nextView = segue.destination as! SearchTableViewController
            nextView.mainTableViewController = self
        }
    }
    
    // MARK: - UserDefaults
    
    func saveData(list:[String], key:String) {
        defaults.set(list, forKey: key)
    }
    
    func loadSavedLocations() {
        if defaults.stringArray(forKey: "savedLocations") != nil {
            savedLocations = defaults.stringArray(forKey: "savedLocations")!
        } else {
            savedLocations = []
        }
    }
}
