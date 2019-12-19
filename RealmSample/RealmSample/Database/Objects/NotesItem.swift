//
//  NotesItem.swift
//  RealmSample
//
//  Created by Ganesh Manickam on 21/11/19.
//  Copyright © 2019 Ganesh Manickam. All rights reserved.
//

import Foundation
import RealmSwift

class NotesItem: Object {
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var subTitle = ""
    @objc dynamic var date = Date()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int, title: String, subTitle: String, date: Date) {
        self.init()
        self.id = id
        self.title = title
        self.subTitle = subTitle
        self.date = date
    }
}
