//
//  PlaceModel.swift
//  PlaceBook
//
//  Created by MacBook on 11/3/19.
//  Copyright © 2019 Anton. All rights reserved.
//

import UIKit

struct Place {
    var name: String
    var location: String?
    var type: String?
    var description: String?
    var image: UIImage?
    
    var placeImage: String{
        return name
    }

}


