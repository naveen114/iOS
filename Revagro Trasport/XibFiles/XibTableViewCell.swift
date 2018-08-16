//
//  XibTableViewCell.swift
//  Revagro Trasport
//
//  Created by ATPL on 07/08/18.
//  Copyright © 2018 ATPL. All rights reserved.
//

import UIKit

class XibTableViewCell: UITableViewCell {
    
   
    @IBOutlet weak var nameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
