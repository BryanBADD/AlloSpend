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
    var dateFormatter = DateFormatter()
    var runningBalance: Float = 0.00
    var ledgerItemToEdit: LedgerItem?
    
    
    
    var selectedPayDate : PayDate? {
        didSet{
            //TODO: Register your MessageCell.xib file here:
            tableView.register(UINib(nibName: "ledgerItemCell", bundle: nil), forCellReuseIdentifier: "ledgerItemCell")
            tableView.separatorStyle = .none
            loadItems()
        }
    }
    
    func loadItems() {
        
        ledgerItems = selectedPayDate?.items.sorted(byKeyPath: "isIncome", ascending: false)
        reloadTableData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        dateFormatter.dateFormat = "MMM d, yyyy"
        title = dateFormatter.string(from: (selectedPayDate?.dueDate)!)
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
        
        if let ledgerItem = ledgerItems?[indexPath.row] {
            
            if ledgerItem.isIncome == true {
                runningBalance = runningBalance + ledgerItem.amount
            } else {
                runningBalance = runningBalance - ledgerItem.amount
            }
            
            cell.ledgerItemTitleLabel?.text = ledgerItem.title
            let amount = String(format: "$ %.2f", ledgerItem.amount)
            cell.amountLabel?.text = amount
            cell.runningBalanceLabel.textColor = UIColor.black

            let balance = String(format: "$ %.2f", runningBalance)
            cell.runningBalanceLabel?.text = balance
            cell.accessoryType = (ledgerItem.isPaid) ? .checkmark : .none
            if cell.accessoryType == .checkmark {
                cell.contentView.layer.opacity = 0.3
            } else {
                cell.contentView.layer.opacity = 1.0
            }
            if ledgerItem.isIncome == true {
                cell.avatarImageView.image = UIImage(named: "Money")
                cell.backgroundColor = UIColor.green
            } else {
                cell.avatarImageView.image = UIImage(named: "checkbook")
                cell.backgroundColor = UIColor.red
            }

        } else {
            cell.ledgerItemTitleLabel?.text = "No Pay Dates Added Yet!"

        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //print(indexPath.row, ledgerItems?.count)
        if (ledgerItems?.count)! < indexPath.row + 1 {
            print("Count is less than index path")
        } else {
            print("Count is greater than or equal to index path")
            let ledgerItem = ledgerItems?[indexPath.row]
            if ledgerItem?.isIncome == true {
                runningBalance = runningBalance - (ledgerItem?.amount)!
            } else {
                runningBalance = runningBalance + (ledgerItem?.amount)!
            }
        }
        
        //        if let ledgerItem = ledgerItems?[indexPath.row] {
//
//        }
    }
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        print("The cell at IndexPath \(indexPath) will be visible")
//
//        }
//    }

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
      
        ledgerItemToEdit = nil
        performSegue(withIdentifier: "toAddLedgerItem", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! AddLedgerItemViewController
        destinationVC.selectedPayDate = selectedPayDate
        destinationVC.ledgerItemForEditing = ledgerItemToEdit
        
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
        
        reloadTableData()
        
    }
    
    override func editButtonPressed(at indexPath: IndexPath) {
        
        if let selectedLedgerItem = self.ledgerItems?[indexPath.row] {
            ledgerItemToEdit = selectedLedgerItem
            print(selectedLedgerItem)
            performSegue(withIdentifier: "toAddLedgerItem", sender: self)
        } else {
            print("Item for editing not set")
        }
    }
    
}
