//
//  ViewController.swift
//  PlaceBook
//
//  Created by MacBook on 11/2/19.
//  Copyright © 2019 Anton. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var places: Results<Place>!
    private var filteredPlaces: Results<Place>!
    private var ascendingSorting = true
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isSearching: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet var reversedSortingButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Realm
        places = realm.objects(Place.self)
        
        // Setup navigation Bar
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.631372549, green: 0.8470588235, blue: 0.6666666667, alpha: 1)
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    //MARK: TableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredPlaces.count
        } else {
            return places.count
        }
     }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as! MainTableViewCell
        
        var place = Place()
        if isSearching {
            place = filteredPlaces[indexPath.row]
        } else {
            place = places[indexPath.row]
        }
        
        cell.nameLabel.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        cell.placeImageView.image = UIImage(data: place.imageData!)
        cell.placeImageView.layer.cornerRadius = cell.placeImageView.frame.size.height / 2
        cell.placeImageView.clipsToBounds = true
        return cell
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: TableViewDelegate
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let contextItem = UIContextualAction(style: .destructive, title: "Delete"){_,_,_ in
            StorageManager.deleteObject(place: self.places[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        
        return swipeActions
    }
    
    //MARK: Navigation
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
      guard let newPlaceVC = segue.source as? AddPlaceTableViewController else { return }
        newPlaceVC.savePlace()
        mainTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            guard let indexPath = mainTableView.indexPathForSelectedRow else { return }
            var place = Place()
            if isSearching {
                place = filteredPlaces[indexPath.row]
            } else {
                place = places[indexPath.row]
            }
            
            let newPlaceVC = segue.destination as! AddPlaceTableViewController
            newPlaceVC.currentPlace = place
        }
    }
    
    //MARK: Sorting
    
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
        sorting()
    }
    
    @IBAction func reversedSorting(_ sender: UIBarButtonItem) {
        ascendingSorting.toggle()
        if ascendingSorting {
            reversedSortingButton.image = #imageLiteral(resourceName: "AZ")
        } else {
            reversedSortingButton.image = #imageLiteral(resourceName: "ZA")
        }
        sorting()
    }
    
    private func sorting() {
        if segmentedControl.selectedSegmentIndex == 0 {
            places = places.sorted(byKeyPath: "date", ascending: ascendingSorting)
        } else {
            places = places.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }
        mainTableView.reloadData()
    }
    
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(searchText: String) {
        filteredPlaces = places.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@", searchText, searchText)
        mainTableView.reloadData()
    }
}
