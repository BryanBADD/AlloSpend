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
    @IBOutlet weak var ledgerItemTitleTextField: UITextField!
    @IBOutlet weak var ledgerItemAmountTextField: UITextField!
    @IBOutlet weak var ledgerItemIsIncomeSwitch: UISwitch!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var itemTitle = ""
    var amount = ""
    var isIncome = false
    var updateItem = false
    
    var selectedPayDate: PayDate?
    var ledgerItemForEditing: LedgerItem? {
        didSet{
            if ledgerItemForEditing != nil {
            print("The item for editing is: \(String(describing: ledgerItemForEditing))")
            itemTitle = ledgerItemForEditing!.title
            amount = String(format: "%.2f", (ledgerItemForEditing!.amount))
            isIncome = (ledgerItemForEditing?.isIncome)!
            updateItem = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ledgerItemTitleTextField.text = itemTitle
        ledgerItemAmountTextField.text = amount
        ledgerItemIsIncomeSwitch.isOn = isIncome
        if updateItem == true {
            print("Update Item")
            updateButton.isEnabled = true
            saveButton.isEnabled = false
            saveButton.isHidden = true
        } else {
            print("Add Item")
            updateButton.isEnabled = false
            updateButton.isHidden = true
            saveButton.isEnabled = true
        }
        
    }
    
    @IBAction func updateButtonPressed(_ sender: Any) {
        
        let realm = try! Realm()
            try! realm.write {
                ledgerItemForEditing?.title = ledgerItemTitleTextField.text!
                ledgerItemForEditing?.amount = Float(ledgerItemAmountTextField.text!)!
                ledgerItemForEditing?.isIncome = ledgerItemIsIncomeSwitch.isOn
            }
        
    }
    
    @IBAction func saveLedgerItemButton(_ sender: Any) {
        
        if ledgerItemForEditing == nil {
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
        } else {
            
        }
    
        self.navigationController?.popViewController(animated: true)
        
    }
    
}
