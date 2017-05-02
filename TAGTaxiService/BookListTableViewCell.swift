//
//  BookListTableViewCell.swift
//  TAGTaxiService
//
//  Created by Arun Lakhera on 3/8/17.
//  Copyright © 2017 Arun Lakhera. All rights reserved.
//

import UIKit

class BookListTableViewCell: UITableViewCell {

  //  @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var TravelDateLabel: UILabel!
//    @IBOutlet weak var fromToLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
      //  nameLabel.text = ""
        TravelDateLabel.text = ""
    //    fromToLabel.text = ""
        statusLabel.text = ""
        fromLabel.text = ""
        toLabel.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
