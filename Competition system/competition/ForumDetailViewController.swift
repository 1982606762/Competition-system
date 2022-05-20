//
//  ForumDetailViewController.swift
//  Competition system
//
//  Created by XuanLang Z on 2022/4/16.
//

import UIKit
import AttributedString
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
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentH: NSLayoutConstraint!
    @IBOutlet weak var authView: UIView!
    var array:[CommentModel]?
    var product: ForumModel?
    var audit = false
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "竞赛详情"
        self.comment.delegate = self
        self.commentTableView.dataSource = self
        if (self.product?.authorId == Singleton.shared.userModel.id) || (Singleton.shared.userModel.manage) && (!audit) {
            self.addRightTitle("编辑") {
                let vc = ForumPublishViewController()
                vc.edit = true
                vc.forumModel = self.product
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        self.deleteBTN.isHidden = !Singleton.shared.userModel.manage
        self.commentTableView.isScrollEnabled = true
        self.commentTableView.register(UINib(nibName: "commentTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "commentTableViewCell")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(parseAction))
        self.parse.isUserInteractionEnabled = true
        self.parse.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.view.addGestureRecognizer(tap1)
        
        self.authView.layer.opacity = audit ? 1 : 0
//        self.commentView.layer.opacity = audit ? 0 : 1
        self.commentTableView.layer.opacity = audit ? 0 : 1
        self.deleteBTN.layer.opacity = audit ? 0 : 1
        // Do any additional setup after loading the view.
    }

    @IBAction func deletAction(_ sender: Any) {
        if let model = self.product {
            RealmHelper.deleteObject(object: model, "forum")
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    @IBAction func rejectAction(_ sender: Any) {
        if let model = self.product {
            RealmHelper.updateBlock({
                model.auth = 2
            }, "forum", model)
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func passAction(_ sender: Any) {
        if let model = self.product {
            RealmHelper.updateBlock({
                model.auth = 1
            }, "forum", model)
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    @objc func tapAction(){
        self.view.endEditing(true)
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
//            self.contentLB.addLinkText(text: model.content as NSString)
//
            
            func clicked(_ result: ASAttributedString.Action.Result) {
                switch result.content {
                case .string(let value):
                    var str = value.string
                    if !str.contains("http"){
                        str = "https://" + str
                    }
                    guard let url = URL(string: str)else{
                        return
                    }
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                case .attachment(let value):
                    print("点击了附件: \n\(value) \nrange: \(result.range)")
                }
            }
            
            var string: ASAttributedString = .init(string: model.content)
            string.add(attributes: [.foreground(.blue),.action(clicked)], checkings: [.link])
            
            self.contentLB.attributed.text = string

            self.date.text = updateTimeToCurrennTime(timeStamp: model.date)
            self.img.image = UIImage(contentsOfFile: model.pic)
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
    
extension ForumDetailViewController:UITableViewDataSource,UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text!.isEmpty  {
            return false
        }
        addCommon()
        return true
    }
    
    func addCommon(){
        if self.comment.text?.isEmpty == false {
            let model = CommentModel()
            model.authorName = Singleton.shared.userModel.name
            model.authorAvatar = Singleton.shared.userModel.pic
            model.title = self.comment.text!
            model.date = Date().timeIntervalSince1970
            RealmHelper.updateBlock({
                self.product?.commentList.append(model)
            }, "forum", self.product!)
            self.comment.text = ""
            self.view.endEditing(true)
            updateUI()
            if model.authorName != self.product?.authorName{
                let newsModel = NewsModel()
                newsModel.comment = model.authorName + "评论了你" + "\t" + updateTimeToCurrennTime(timeStamp: model.date)
                newsModel.modelId = self.product?.id
                newsModel.authorId = self.product?.authorId
                newsModel.commentAuthorId = Singleton.shared.userModel.id
                RealmHelper.addObject(object:newsModel, "news")
            }
            
        }
    }
    
    func updateUI(){
        self.commentTableView.layoutIfNeeded()
        self.commentTableView.reloadData()
        self.commentTableView.layoutIfNeeded()
        print(self.commentTableView.contentSize.height)
        self.height.constant = self.commentTableView.contentSize.height + 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.product!.commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentTableViewCell", for: indexPath)
        (cell as! commentTableViewCell).model = self.product!.commentList[indexPath.row]
        (cell as! commentTableViewCell).deleteBtn.tag = indexPath.row
        (cell as! commentTableViewCell).deleteBtn.isHidden = !Singleton.shared.userModel.manage
        (cell as! commentTableViewCell).deleteBtn.addTarget(self, action: #selector(deleteAction(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.product!.commentList.count > 0 ? "评论列表" : "暂无评论"
    }
    
    @objc func deleteAction (_ sender:UIButton){
        RealmHelper.updateBlock({
            self.product!.commentList.remove(at: sender.tag)
            self.updateUI()
        }, "forum", product)
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


