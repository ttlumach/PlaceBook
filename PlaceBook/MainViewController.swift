//
//  ViewController.swift
//  PlaceBook
//
//  Created by MacBook on 11/2/19.
//  Copyright © 2019 Anton. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let restaraunts = ["Придністров'я","Рай-Гора","Хатинка","Баскервіль","Street Coffe"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaraunts.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainTableViewCell
        
        cell.nameLabel.text = restaraunts[indexPath.row]
        cell.placeImageView.image = UIImage(named: restaraunts[indexPath.row])
        cell.placeImageView.layer.cornerRadius = cell.placeImageView.frame.size.height / 2
        cell.placeImageView.clipsToBounds = true
        return cell
     }
    
    //MARK: Table view delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}

