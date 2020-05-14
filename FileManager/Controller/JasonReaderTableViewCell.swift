//
//  JasonReaderTableViewCell.swift
//  FileManager
//
//  Created by Shawn Li on 5/12/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//

import UIKit

class JsonReaderTableViewCell: UITableViewCell {

    @IBOutlet weak var tittleLabel: UIView!
    @IBOutlet weak var authorLabel: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
