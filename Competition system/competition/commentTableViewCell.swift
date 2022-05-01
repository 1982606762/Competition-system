//
//  commentTableViewCell.swift
//  Competition system
//
//  Created by XuanLang Z on 2022/4/16.
//

import UIKit

class commentTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    var _model: CommentModel?
    var model: CommentModel? {
        get {
            return _model
        }
        set {
            _model = newValue
            self.img.image = UIImage(contentsOfFile: _model!.authorAvatar)
            self.name.text = _model?.authorName ?? ""
            self.title.text = _model?.title ?? ""
            self.date.text =  updateTimeToCurrennTime(timeStamp: _model!.date)
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.img.layer.cornerRadius = 20
        self.img.clipsToBounds = true
        self.img.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
