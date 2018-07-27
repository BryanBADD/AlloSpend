//
//  LedgerItemViewController.swift
//  AlloSpend
//
//  Created by Bryan Butz on 7/23/18.
//  Copyright © 2018 Bryan Butz. All rights reserved.
//

import UIKit
import RealmSwift

class LedgerItemViewController: SwipeTableViewController {
    
    var ledgerItems: Results<LedgerItem>?
    let realm = try! Realm()
    
    var selectedPayDate : PayDate? {
        didSet{
            loadItems()
        }
    }
    
    func loadItems() {
        
        ledgerItems = selectedPayDate?.items.sorted(byKeyPath: "amouont", ascending: false)
        tableView.reloadData()
        
    }
    
   
    //TODO: Add Ledger Item Button Pressed
    @IBAction func addLedgerItemsButtonPressed(_ sender: UIBarButtonItem) {
        
        
        
    }
}
