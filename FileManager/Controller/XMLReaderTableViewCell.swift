//
//  XMLReaderTableViewCell.swift
//  FileManager
//
//  Created by Shawn Li on 5/12/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//

import UIKit

class XMLReaderTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
