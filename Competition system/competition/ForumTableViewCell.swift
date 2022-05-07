//
//  ForumTableViewCell.swift
//  Competition system
//
//  Created by XuanLang Z on 2022/4/9.
//

import UIKit
class ForumTableViewCell: UITableViewCell {

    @IBOutlet weak var height1: NSLayoutConstraint!
    @IBOutlet weak var commentBTN: UIButton!
    @IBOutlet weak var parseBTN: UIButton!
    @IBOutlet weak var detailLB: UILabel!
    @IBOutlet weak var contenIV: UIImageView!
    @IBOutlet weak var dateLB: UILabel!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var heightCon: NSLayoutConstraint!
    var _product: ForumModel?
    var product: ForumModel? {
        get {
            return _product
        }
        set {
            _product = newValue
            if let model = _product {
                self.nameLB.text = model.authorName
                self.detailLB.text = model.title
                self.dateLB.text = updateTimeToCurrennTime(timeStamp: model.date)
                self.contenIV.image = UIImage(contentsOfFile:model.pic)
                self.commentBTN.setTitle(String(model.commentList.count), for: .normal)
                self.parseBTN.setImage(UIImage(named: (model.collectUserList.contains(Singleton.shared.userModel.id)) ? "收藏":"未收藏"), for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.commentBTN.isUserInteractionEnabled = false
        self.contenIV.addCorner(byRoundingCorners: .allCorners, cornerRadii: 5)
    }
}
