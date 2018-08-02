//
//  AddLedgerItemViewController.swift
//  AlloSpend
//
//  Created by Bryan Butz on 8/1/18.
//  Copyright © 2018 Bryan Butz. All rights reserved.
//

import UIKit
import RealmSwift

class AddLedgerItemViewController: UIViewController {
    
    let realm = try! Realm()
    
    var selectedPayDate: PayDate?
    
    @IBOutlet weak var ledgerItemTitleTextField: UITextField!
    @IBOutlet weak var ledgerItemAmountTextField: UITextField!
    @IBOutlet weak var ledgerItemIsIncomeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    @IBAction func saveLedgerItemButton(_ sender: Any) {
        
        if let currentPayDate = self.selectedPayDate {
            do {
                try self.realm.write {
                    let newLedgerItem = LedgerItem()
                    if let newItemTitle = ledgerItemTitleTextField.text {
                        newLedgerItem.title = newItemTitle
                    }
                    
                    if let newItemAmount = ledgerItemAmountTextField.text {
                        newLedgerItem.amount = Float(newItemAmount)!
                    }
                    
                    if ledgerItemIsIncomeSwitch.isOn {
                        newLedgerItem.isIncome = true
                    } else {
                        newLedgerItem.isIncome = false
                    }
                    currentPayDate.items.append(newLedgerItem)
                }
            } catch {
                print("Error saving new items, \(error)")
            }
        }
    
        self.navigationController?.popViewController(animated: true)
        
    }

}
