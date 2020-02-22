//
//  SearchTableViewController.swift
//  Labb 1 Swift
//
//  Created by Nicklas Pekkarinen on 2020-02-10.
//  Copyright © 2020 Nicklas Pekkarinen. All rights reserved.
//

import UIKit
import MapKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    var searchBar : UISearchBar!
    var itemList : Array<String>!
    var searchList : Array<String>!
    var savedLocations : Array<String>!
    var mainTableViewController : MainTableViewController!

    // MARK: - Lifetime
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchList = []
        searchBar = UISearchBar()
        addSearchController()
        
        let defaults = UserDefaults.standard
        if defaults.stringArray(forKey: "savedLocations") != nil {
            savedLocations = defaults.stringArray(forKey: "savedLocations")
        } else {
            savedLocations = []
        }
        if defaults.object(forKey: "cityList") != nil {
            itemList = defaults.stringArray(forKey: "cityList")
        } else {
            itemList = []
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        if defaults.stringArray(forKey: "savedLocations") != nil {
            savedLocations = defaults.stringArray(forKey: "savedLocations")
        } else {
            savedLocations = []
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.isFocused {
            self.dismiss(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    // MARK: - Search
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchList.removeAll()
        self.searchList = self.itemList.filter {
            $0.contains(searchText)
        }
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        
        cell.textLabel?.textColor = .systemYellow
        cell.textLabel?.text = self.searchList[indexPath.row]

        return cell
    }
    
    // Save location to userdefaults
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let formattedString = searchList[indexPath.row].replacingOccurrences(of: " ", with: "%20")
        savedLocations.append(formattedString)
        
        let defaults = UserDefaults.standard
        defaults.set(savedLocations, forKey: "savedLocations")
        self.dismiss(animated: true)
    }
    
    func addSearchController() {
        searchBar.barStyle = .default
        searchBar.delegate = self
        searchBar.autocapitalizationType = .words
        searchBar.showsCancelButton = true
        searchBar.sizeToFit()
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = .black
        searchBar.tintColor = .systemYellow
        let textField = searchBar.value(forKey: "searchField") as? UITextField
        textField?.textColor = .systemYellow
        tableView.tableHeaderView = searchBar
    }
}
