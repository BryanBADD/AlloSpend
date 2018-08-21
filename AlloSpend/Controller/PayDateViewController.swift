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
    let dateFormatter = DateFormatter()
    var payDates: Results<PayDate>?
    @IBOutlet weak var addPayDateButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.separatorStyle = .none
        loadPayDates()
        
    }

    //TODO: Handle Add PayDate Button Pressed
    @IBAction func addPayDateButtonPressed(_ sender: UIBarButtonItem) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let DestVC = storyboard.instantiateViewController(withIdentifier: "addPayDateView") as! AddPayDateViewController //UINavigationController
        self.present(DestVC, animated: true, completion: nil)
        

    }
    
    //MARK: - TableView Data Source Methods
    
    //Set number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return payDates?.count ?? 1
        
    }

    
    //Cell for row at index path
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let payDate = payDates?[indexPath.row] {
            //cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: category.color)!, returnFlat: true)
            dateFormatter.dateFormat = "MMM d, yyyy"
            let convertedDate = dateFormatter.string(from: payDate.dueDate!)
            cell.textLabel?.text = convertedDate
        } else {
            cell.textLabel?.text = "No Pay Dates Added Yet!"
        }
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
        //TODO: Did Select Row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
        
        payDates = realm.objects(PayDate.self).sorted(byKeyPath: "dueDate", ascending: false)
        tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadPayDates()
        
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

