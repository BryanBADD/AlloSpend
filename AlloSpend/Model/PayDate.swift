//
//  PayDate.swift
//  AlloSpend
//
//  Created by Bryan Butz on 7/19/18.
//  Copyright © 2018 Bryan Butz. All rights reserved.
//

import Foundation
import RealmSwift

class PayDate: Object {
    
    //@objc dynamic var dueDate: String = ""
    @objc dynamic var dueDate: Date?
    @objc dynamic var areAllPaid: Bool = false
    @objc dynamic var dateCreated: Date?
    let items = List<LedgerItem>()

}
