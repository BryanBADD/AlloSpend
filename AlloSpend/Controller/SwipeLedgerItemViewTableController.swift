//
//  MyController.swift
//  AlloSpend
//
//  Created by Bryan Butz on 7/30/18.
//  Copyright © 2018 Bryan Butz. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeLedgerItemViewTableController: UITableViewController, SwipeTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        
    }
    
    var isSwipeRightEnabled = true
    
    //TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ledgerItemCell", for: indexPath) as! LedgerItemCell
        cell.delegate = self
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        if orientation == .left { guard isSwipeRightEnabled else { return nil }
            
            let editAction = SwipeAction(style: .destructive, title: "Edit") {action, indexPath in
                
                //handle action by updating model with deletion
                self.editButtonPressed(at: indexPath)
                
            }
            
            //customize the action appearence
            editAction.backgroundColor = .blue
            editAction.image = UIImage(named: "edit-icon30")
            
            return [editAction]
            
        } else {
        
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") {action, indexPath in
            
            //handle action by updating model with deletion
            self.updateModel(at: indexPath)
            
        }
        
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .none
        options.transitionStyle = .border
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        
        //Update data model
        
    }
    
    func editButtonPressed(at indexPath: IndexPath) {
        
        //Edit data model
        
    }
    
}
