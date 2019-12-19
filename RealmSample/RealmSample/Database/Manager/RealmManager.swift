//
//  RealmManager.swift
//  RealmSample
//
//  Created by Ganesh Manickam on 21/11/19.
//  Copyright © 2019 Ganesh Manickam. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {

    let realm = try? Realm()
    
    // MARK: GET
    // Get list of objects of same type
    func getObjects(type: Object.Type) -> Results<Object>? {
        return realm?.objects(type)
    }
    
    // Get particular object by primary key and type
    func getObject(type: Object.Type, primaryKey: Any) -> Object? {
        return realm?.object(ofType: type, forPrimaryKey: primaryKey)
    }
    
    // MARK: SAVE
    // Save single object into database
    func saveObject(object: Object) {
        try! realm?.write({
            realm?.add(object)
        })
    }
    
    // Save list of objects into database
    func saveListOfObjects(objects: [Object]) {
        try! realm?.write({
            realm?.add(objects)
        })
    }
    
    // MARK: UPDATE
    // Update particular object in database
    func updateObject(object: Object) {
        try! realm?.write({
            realm?.add(object, update: .all)
        })
    }
    
    // Update list of objects in database
    func updateListOfObjects(objects: [Object]) {
        try! realm?.write({
            realm?.add(objects, update: .all)
        })
    }
    
    
    // MARK: DELETE
    // Delete entire Database
    func deleteDatabase() {
        try! realm?.write({
            realm?.deleteAll()
        })
    }
    
    // Delete particular object
    func deleteObject(object: Object) {
        try! realm?.write({
            realm?.delete(object)
        })
    }
    
    // Delete entire table
    func deleteTableOfType(type: Object.Type) {
        try! realm?.write({
            realm?.delete((realm?.objects(type))!)
        })
    }
    
    // Delete list of objects from database
    func deleteListOfObjects(objects: [Object]) {
        try! realm?.write({
            realm?.delete(objects)
        })
    }
    
    // MARK: PRIMARY KEY
    // Function to generate primary key for type
    func incrementID(type: Object.Type, key: String) -> Int {
        return (realm!.objects(type).max(ofProperty: key) as Int? ?? 0) + 1
    }
}
