//
//  Task.swift
//  taskapp
//
//  Created by tatsuya ohyama on 2018/07/28.
//  Copyright © 2018年 tatsuya.ohyama. All rights reserved.
//

import RealmSwift

class Task: Object {
    
    @objc dynamic var id = 0
    
    @objc dynamic var title = ""
    
    @objc dynamic var contents = ""
    
    @objc dynamic var category = ""
    
    @objc dynamic var date = Date()

    override static func primaryKey() -> String? {
        return "id"
    }
}
