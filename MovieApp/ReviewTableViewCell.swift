//
//  ReviewTableViewCell.swift
//  MovieApp
//
//  Created by Anastasia on 12/7/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var reviewDetailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
