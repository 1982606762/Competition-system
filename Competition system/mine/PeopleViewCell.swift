//
//  PeopleViewCell.swift
//  Competition system
//
//  Created by XuanLang Z on 2022/5/17.
//

import UIKit

class PeopleViewCell: UITableViewCell {

    @IBOutlet weak var detailL: UILabel!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var iconIV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
