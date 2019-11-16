//
//  PlaceModel.swift
//  PlaceBook
//
//  Created by MacBook on 11/3/19.
//  Copyright © 2019 Anton. All rights reserved.
//

import RealmSwift

class Place: Object {
    @objc dynamic var name = ""
    @objc dynamic var location: String?
    @objc dynamic var type: String?
    @objc dynamic var imageData: Data?
    @objc dynamic var placeDescription: String?
    @objc dynamic var date = Date()
    
    convenience init(name: String, location: String?, type: String?, imageData: Data?, placeDescription: String?) {
        self.init()
        self.name = name
        self.location = location
        self.type = type
        self.imageData = imageData
        self.placeDescription = placeDescription
    }
}


