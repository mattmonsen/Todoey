//
//  Item.swift
//  Todoey
//
//  Created by Matt Monsen on 10/22/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Double = NSDate().timeIntervalSince1970
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
