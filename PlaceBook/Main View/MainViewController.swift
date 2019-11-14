//
//  ViewController.swift
//  PlaceBook
//
//  Created by MacBook on 11/2/19.
//  Copyright © 2019 Anton. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mainTableView: UITableView!
    
    var places: [Place] = [
        Place(name: "Придністров'я", location: "м. Тлумач", type: "ресторан"),
        Place(name: "Рай-Гора", location: "м. Тлумач", type: "Ресторан"),
        Place(name: "Хатинка", location: "Івано-Франківськ", type: "їдальня-булочна"),
        Place(name: "Баскервіль", location: "Івано-Франківськ", type: "їдальня"),
        Place(name: "Street Coffe", location: "Івано-Франківськ", type: "Кафе"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //navigationController?.navigationBar.barTintColor = .red
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
     }
    
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainTableViewCell
        
        let place = places[indexPath.row]
        cell.nameLabel.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        
        cell.placeImageView.image = place.image ?? UIImage(named: place.placeImage)
        cell.placeImageView.layer.cornerRadius = cell.placeImageView.frame.size.height / 2
        cell.placeImageView.clipsToBounds = true
        
        return cell
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: Navigation
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
      guard let newPlaceVC = segue.source as? AddPlaceTableViewController else { return }

        newPlaceVC.saveNewPlace()
        places.append(newPlaceVC.newPlace!)
        mainTableView.reloadData()
        
    }
    
}

