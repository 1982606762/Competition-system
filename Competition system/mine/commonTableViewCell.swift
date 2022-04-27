//
//  commonTableViewCell.swift
//  Competition system
//
//  Created by XuanLang Z on 2022/4/26.
//

import UIKit

class commonTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIView!
    @IBOutlet weak var titleName: UITextView!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var publishTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
