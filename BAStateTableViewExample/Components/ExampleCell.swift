//
//  ExampleCell.swift
//  BASkeletonViewExample
//
//  Created by Bagus Andinata on 05/08/20.
//  Copyright © 2020 Bagus Andinata. All rights reserved.
//

import UIKit

class ExampleCell: UITableViewCell {

    @IBOutlet weak var labelExample: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
