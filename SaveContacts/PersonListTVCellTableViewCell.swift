//
//  PersonListTVCellTableViewCell.swift
//  SaveContacts
//
//  Created by Active Mac05 on 25/11/16.
//  Copyright © 2016 techactive. All rights reserved.
//

import UIKit

class PersonListTVCellTableViewCell: UITableViewCell {

    @IBOutlet var personImage: UIImageView!
    @IBOutlet var personName: UILabel!
    @IBOutlet var personMobileNumber: UILabel!
    @IBOutlet var personEmailAddress: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
