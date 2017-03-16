//
//  AdminBookListTableViewCell.swift
//  TAGTaxiService
//
//  Created by Arun Lakhera on 3/16/17.
//  Copyright © 2017 Arun Lakhera. All rights reserved.
//

import UIKit

class AdminBookListTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fromToLabel: UILabel!
    @IBOutlet weak var travelDateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        nameLabel.text = ""
        fromToLabel.text = ""
        travelDateLabel.text = ""
        statusLabel.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
