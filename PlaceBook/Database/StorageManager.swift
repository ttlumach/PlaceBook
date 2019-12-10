//
//  StorageManager.swift
//  PlaceBook
//
//  Created by MacBook on 11/14/19.
//  Copyright © 2019 Anton. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    static func saveObject(place: Place) {
        try! realm.write {
            realm.add(place)
        }
    }
    
    static func deleteObject(place: Place){
        try! realm.write {
            realm.delete(place)
        }
    }
    
}


