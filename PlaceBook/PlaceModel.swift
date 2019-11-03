//
//  PlaceModel.swift
//  PlaceBook
//
//  Created by MacBook on 11/3/19.
//  Copyright © 2019 Anton. All rights reserved.
//

import Foundation

struct Place{
    var name: String
    var location: String
    var type: String
    var image: String{
        return name
    }
    var description: String?
}


