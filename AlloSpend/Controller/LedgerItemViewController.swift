//
//  LedgerItemViewController.swift
//  AlloSpend
//
//  Created by Bryan Butz on 7/23/18.
//  Copyright © 2018 Bryan Butz. All rights reserved.
//

import UIKit
import RealmSwift

class LedgerItemViewController: SwipeLedgerItemViewTableController {
    
    var ledgerItems: Results<LedgerItem>?
    let realm = try! Realm()
    var runningBalance: Float = 0.00
    
    
    
    var selectedPayDate : PayDate? {
        didSet{
            //TODO: Register your MessageCell.xib file here:
            tableView.register(UINib(nibName: "ledgerItemCell", bundle: nil), forCellReuseIdentifier: "ledgerItemCell")
            loadItems()
        }
    }
    
    func loadItems() {
        
        ledgerItems = selectedPayDate?.items.sorted(byKeyPath: "isIncome", ascending: false)
        reloadTableData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedPayDate!.dueDate
        loadItems()
        
    }
    
    //MARK: - TableView Delegate Methods
    //Set number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ledgerItems?.count ?? 1
        
    }
    
    //Cell for row at index path
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! LedgerItemCell
        
        //cell.textLabel?.text = payDates?[indexPath.row].dueDate ?? "No Pay Dates Added."
        
        if let ledgerItem = ledgerItems?[indexPath.row] {
            
            //cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: category.color)!, returnFlat: true)
            if ledgerItem.isIncome == true {
                runningBalance = runningBalance + ledgerItem.amount
            } else {
                runningBalance = runningBalance - ledgerItem.amount
            }
            
            let amount = ledgerItem.amount, amountFormat = ".02"
            cell.ledgerItemTitleLabel?.text = ledgerItem.title
            cell.amountLabel?.text = "$\(amount)"

//            if runningBalance >= 0 {
            cell.runningBalanceLabel.textColor = UIColor.black
//            } else {
//                cell.runningBalanceLabel.textColor = UIColor.red
//            }

            cell.runningBalanceLabel?.text = "$\(runningBalance)"
            cell.accessoryType = (ledgerItem.isPaid) ? .checkmark : .none
            if ledgerItem.isIncome == true {
                cell.avatarImageView.image = UIImage(named: "Money")
                //cell.itemBackground.backgroundColor = UIColor.green
                cell.backgroundColor = UIColor.green
            } else {
                cell.avatarImageView.image = UIImage(named: "checkbook")
                //cell.itemBackground.backgroundColor = UIColor.red
                cell.backgroundColor = UIColor.red
            }
            //cell.backgroundColor = UIColor(hexString: category.color)
        } else {
            cell.ledgerItemTitleLabel?.text = "No Pay Dates Added Yet!"
            //cell.backgroundColor = UIColor(hexString: "430065")
        }
        
        return cell
        
    }
    
    //TODO: Did Select Row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let ledgerItem = ledgerItems?[indexPath.row] {
            do {
                try realm.write{
                    ledgerItem.isPaid = !ledgerItem.isPaid
                }
            } catch{
                print("Error saving data, \(error)")
            }
        }
        
        reloadTableData()
        
    }
    
    func reloadTableData() {
        
        runningBalance = 0.00
        tableView.reloadData()
        
    }
   
    //TODO: Add Ledger Item Button Pressed
    @IBAction func addLedgerItemsButtonPressed(_ sender: UIBarButtonItem) {
      
        performSegue(withIdentifier: "toAddLedgerItem", sender: self)
        
//        if let currentPayDate = self.selectedPayDate {
//            do {
//                try self.realm.write {
//                    let newItem = LedgerItem()
//                    newItem.title = "House of Raeford"
//                    newItem.dateCreated = Date()
//                    newItem.amount = 1606.21
//                    newItem.isIncome = true
//                    currentPayDate.items.append(newItem)
//                }
//            } catch {
//                print("Error saving new items, \(error)")
//            }
//        }
        
//        reloadTableData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! AddLedgerItemViewController
        destinationVC.selectedPayDate = selectedPayDate
                
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let ledgerItemForDeletion = self.ledgerItems?[indexPath.row] {
            do {
                try self.realm.write{
                    self.realm.delete(ledgerItemForDeletion)
                }
            } catch{
                print("Error deleting category, \(error)")
            }
            
        }
        
    }
}

extension Int {
    func format(f: String) -> String {
        return String(format: "%\(f)d", self)
    }
}

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
