//
//  HeadCell.swift
//  Competition system
//
//  Created by XuanLang Z on 2022/4/9.
//

import UIKit

class HeadCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.img.isUserInteractionEnabled = true
        self.img.addCorner(byRoundingCorners: .allCorners, cornerRadii: 30)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
