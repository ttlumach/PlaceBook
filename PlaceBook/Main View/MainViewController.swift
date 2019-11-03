//
//  ViewController.swift
//  PlaceBook
//
//  Created by MacBook on 11/2/19.
//  Copyright © 2019 Anton. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    let places: [Place] = [
        Place(name: "Придністров'я", location: "м. Тлумач", type: "ресторан"),
        Place(name: "Рай-Гора", location: "м. Тлумач", type: "Ресторан"),
        Place(name: "Хатинка", location: "Івано-Франківськ", type: "їдальня-булочна"),
        Place(name: "Баскервіль", location: "Івано-Франківськ", type: "їдальня"),
        Place(name: "Street Coffe", location: "Івано-Франківськ", type: "Кафе"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainTableViewCell
        
        cell.nameLabel.text = places[indexPath.row].name
        cell.locationLabel.text = places[indexPath.row].location
        cell.typeLabel.text = places[indexPath.row].type
        cell.placeImageView.image = UIImage(named: places[indexPath.row].image)
        cell.placeImageView.layer.cornerRadius = cell.placeImageView.frame.size.height / 2
        cell.placeImageView.clipsToBounds = true
        return cell
     }
    
    //MARK: Navigation
    
    @IBAction func cancelAction(_ segue: UIStoryboardSegue){
        
    }
    
    
}

