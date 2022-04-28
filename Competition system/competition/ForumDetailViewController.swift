//
//  ForumDetailViewController.swift
//  Competition system
//
//  Created by XuanLang Z on 2022/4/16.
//

import UIKit

class ForumDetailViewController: BaseVC {

    
    @IBOutlet weak var parse: UIImageView!
    @IBOutlet weak var comment: UITextField!
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHead: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var contentLB: UILabel!
    @IBOutlet weak var deleteBTN: UIButton!
    var array:[CommentModel]?
    var product: ForumModel?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "竞赛详情"
        
        if (self.product?.authorId == Singleton.shared.userModel.id) || (Singleton.shared.userModel.manage) {
            self.addRightTitle("编辑") {
                let vc = ForumPublishViewController()
                vc.edit = true
                vc.forumModel = self.product
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        self.deleteBTN.isHidden = !Singleton.shared.userModel.manage
        self.commentTableView.isScrollEnabled = false
        self.commentTableView.register(UINib(nibName: "CommonTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CommonTableViewCell")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(parseAction))
        self.parse.isUserInteractionEnabled = true
        self.parse.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }

    @IBAction func deleteForum(_ sender: Any) {
        if let model = self.product {
            RealmHelper.updateBlock({
                model.isDelete = true
            }, "forum", model)
            RealmHelper.deleteObject(object: model, "forum")
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let model = self.product {
            self.userName.text = model.authorName
            if  model.authorAvatar.isEmpty == true {
                self.userHead.image = UIImage(named: "icon")
            }else{
                self.userHead.image = UIImage(contentsOfFile: model.authorAvatar)
            }
            self.titleLB.text = model.title
            self.contentLB.text = model.content
            self.date.text = updateTimeToCurrennTime(timeStamp: model.date)
            self.img.image = UIImage(named: "icon")
            self.parse.image = UIImage(named: (model.collectUserList.contains(Singleton.shared.userModel.id)) ? "收藏" : "未收藏")
            
        }
    }
        
    @objc func parseAction(){
        if let model = self.product {
            var contain = model.collectUserList.contains(Singleton.shared.userModel.id)
            RealmHelper.updateBlock({
                if contain {
                    let indexC = model.collectUserList.firstIndex(of: Singleton.shared.userModel.id)
                    if let indexC = indexC{
                        model.collectUserList.remove(at: indexC)
                    }
                }else{
                    model.collectUserList.append(Singleton.shared.userModel.id)
                }
            }, "forum", model)
            
            
            RealmHelper.updateBlock({
                if contain  {
                    let indexC = Singleton.shared.userModel.collectList.firstIndex(of: model.id)
                    if let indexC = indexC{
                        Singleton.shared.userModel.collectList.remove(at: indexC)
                    }
                }else{
                    Singleton.shared.userModel.collectList.append(model.id)
                }
            }, "user",  Singleton.shared.userModel)
            
            contain = !contain
            self.parse.image = UIImage(named: contain ? "收藏" : "未收藏")
        }
    }
    
    
}
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


