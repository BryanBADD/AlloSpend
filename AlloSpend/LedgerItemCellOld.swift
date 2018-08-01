//
//  LedgerItemCell.swift
//  AlloSpend
//
//  Created by Bryan Butz on 7/29/18.
//  Copyright © 2018 Bryan Butz. All rights reserved.
//

import UIKit
import SwipeCellKit

class LedgerItemCellOld: SwipeTableViewCell {

    @IBOutlet weak var ledgerItemTitleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var runningBalanceLabel: UILabel!
    @IBOutlet weak var itemBackground: LedgerItemCell!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}
