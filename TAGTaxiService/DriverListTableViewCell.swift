//
//  DriverListTableViewCell.swift
//  TAGTaxiService
//
//  Created by Arun Lakhera on 3/28/17.
//  Copyright © 2017 Arun Lakhera. All rights reserved.
//

import UIKit

class DriverListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var driverImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var DLValidTill: UILabel!
    @IBOutlet weak var renewLicenseImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        nameLabel.text = ""
        phoneNumberLabel.text = ""
        DLValidTill.text = ""
        renewLicenseImage.isHidden = true
        driverImage.image = UIImage(named: "PhotoAvatar.png")
        
        nameLabel.textColor = UIColor.white
        phoneNumberLabel.textColor = UIColor.white
        DLValidTill.textColor = UIColor.white
        renewLicenseImage.alpha = 1
        DLValidTill.alpha = 1
      
    }

}
