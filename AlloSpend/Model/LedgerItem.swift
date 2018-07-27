//
//  LedgerItem.swift
//  AlloSpend
//
//  Created by Bryan Butz on 7/19/18.
//  Copyright © 2018 Bryan Butz. All rights reserved.
//

import Foundation
import RealmSwift

class LedgerItem: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var isPaid: Bool = false
    @objc dynamic var dateCreated: Date?
    @objc dynamic var isIncome: Bool = false
    @objc dynamic var amount: Float = 0.00
    @objc dynamic var isRepeating: Bool = false
    //@objc dynamic var repeatFrequency: Int = 0
    var parentCategory = LinkingObjects(fromType: PayDate.self, property: "items")

}
