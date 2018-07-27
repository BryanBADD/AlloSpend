//
//  ViewController.swift
//  AlloSpend
//
//  Created by Bryan Butz on 7/18/18.
//  Copyright © 2018 Bryan Butz. All rights reserved.
//

import UIKit
import RealmSwift

class PayDateViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var payDates: Results<PayDate>?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadPayDates()
        
    }

    //TODO: Handle Add PayDate Button Pressed
    @IBAction func addPayDateButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add A New Pay Date", message: "", preferredStyle: .alert)
        var textField = UITextField()
        let action = UIAlertAction(title: "Add Pay Date", style: .default) {(action) in
            
            let newPayDate = PayDate()
            newPayDate.dueDate = textField.text!
            //newCategory.color = UIColor.randomFlat.hexValue()
            
            self.save(payDate: newPayDate)
            
        }
        
        alert.addTextField { (alertTextField) in

            alertTextField.placeholder = "Create New Pay Date"
            textField = alertTextField

        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - TableView Data Source Methods
    
    //Set number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return payDates?.count ?? 1
        
    }

    //Cell for row at index path
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
//        cell.textLabel?.text = payDates?[indexPath.row].dueDate ?? "No Pay Dates Added."
        
        if let payDate = payDates?[indexPath.row] {
            //cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: category.color)!, returnFlat: true)
            cell.textLabel?.text = payDate.dueDate
            //cell.backgroundColor = UIColor(hexString: category.color)
        } else {
            cell.textLabel?.text = "No Pay Dates Added Yet!"
            //cell.backgroundColor = UIColor(hexString: "430065")
        }
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
        //TODO: Did Select Row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Code on next line animates the row selection
        //tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "goToLedgerItems", sender: self)
        
    }
    
    //Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! LedgerItemViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedPayDate = payDates?[indexPath.row]
            
        }
        
    }

    //MARK: - Data Manipulation Methods
        //TODO: Add Paydate
    
    //Save Paydate
    func save(payDate: PayDate) {
        
        do {
            try realm.write {
                realm.add(payDate)}
        } catch {
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
    }
    
    //Load PayDates
    func loadPayDates() {
        
        payDates = realm.objects(PayDate.self).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        
    }
  
    //Delete Paydate from swipe    
    override func updateModel(at indexPath: IndexPath) {
        if let payDateForDeletion = self.payDates?[indexPath.row] {
            do {
                try self.realm.write{
                    self.realm.delete(payDateForDeletion)
                }
            } catch{
                print("Error deleting category, \(error)")
            }
            
        }
        
    }
    

}

