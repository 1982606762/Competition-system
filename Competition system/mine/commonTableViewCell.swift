//
//  commonTableViewCell.swift
//  Competition system
//
//  Created by XuanLang Z on 2022/4/26.
//

import UIKit

class commonTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var publishTime: UILabel!
    var _product: ForumModel?
    var product: ForumModel? {
        get {
            return _product
        }
        set {
            _product = newValue
            if let model = _product {
                self.author.text = model.authorName
                self.titleLB.text = model.title
                self.publishTime.text = updateTimeToCurrennTime(timeStamp: model.date)
                self.img.image = UIImage(contentsOfFile:model.pic)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.img.addCorner(byRoundingCorners: .allCorners, cornerRadii: 5)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
