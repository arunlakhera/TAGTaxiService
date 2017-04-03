//
//  VehicleListTableViewCell.swift
//  TAGTaxiService
//
//  Created by Arun Lakhera on 4/3/17.
//  Copyright © 2017 Arun Lakhera. All rights reserved.
//

import UIKit

class VehicleListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var modelNameLabel: UILabel!
    @IBOutlet weak var carNumberLabel: UILabel!
    @IBOutlet weak var modelYearLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        companyNameLabel.text = ""
        modelNameLabel.text = ""
        carNumberLabel.text = ""
        modelYearLabel.text = ""
    }
    
}
