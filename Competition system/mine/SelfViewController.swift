//
//  SelfViewController.swift
//  Competition system
//
//  Created by XuanLang Z on 2022/4/9.
//

import UIKit
import BSImagePicker
import Photos

class SelfViewController: UIViewController {
    var dataArr:[String] = ["头像","手机号","邮箱","学号","我的发布","我的收藏"]
    var imageIV:UIImageView?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "我的"
        // Do any additional setup after loading the view.
    }
    ///退出
    @IBAction func logoutAction(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "token")
        let screnDelegate: UIWindowSceneDelegate? = {
        var uiScreen: UIScene?
        UIApplication.shared.connectedScenes.forEach { (screen) in
            uiScreen = screen
     }
          return (uiScreen?.delegate as? UIWindowSceneDelegate)
          }()
      screnDelegate?.window!?.rootViewController = UINavigationController(rootViewController: LoginViewController())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
}
extension SelfViewController:UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.dataArr.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.row == 0{
                var cell = tableView.dequeueReusableCell(withIdentifier: "HeadCell")
                if cell == nil {
                    cell = Bundle.main.loadNibNamed("HeadCell", owner: nil, options:nil)?.first as! HeadCell
                }
                (cell as! HeadCell).name.text = Singleton.shared.userModel.name + (Singleton.shared.userModel.manage ? "(管理员)" : "")
                (cell as! HeadCell).img.image = UIImage(contentsOfFile:Singleton.shared.userModel.pic)
                let tap1 = UITapGestureRecognizer(target: self, action: #selector(avatarAction))
                (cell as! HeadCell).img.addGestureRecognizer(tap1)
                cell?.accessoryType = .disclosureIndicator
                self.imageIV = (cell as! HeadCell).img
                return cell ?? UITableViewCell()
            }else if indexPath.row  < 4{
                var cell = tableView.dequeueReusableCell(withIdentifier: "cell1")
                if cell == nil {
                    cell = UITableViewCell(style: .value1, reuseIdentifier: "cell1")
                }
                cell?.textLabel?.text = self.dataArr[indexPath.row]
                if indexPath.row == 1 {
                    cell?.detailTextLabel?.text = Singleton.shared.userModel.phone
                    cell?.accessoryType = .disclosureIndicator
                }else if indexPath.row == 2 {
                    cell?.detailTextLabel?.text = Singleton.shared.userModel.email
                    cell?.accessoryType = .disclosureIndicator
                }else{
                    cell?.detailTextLabel?.text = Singleton.shared.userModel.number
                    cell?.accessoryType = .none
                }
                return cell ?? UITableViewCell()
            }else{
                var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
                if cell == nil {
                    cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
                }
                cell?.textLabel?.text = self.dataArr[indexPath.row]
                cell?.accessoryType = .disclosureIndicator
                return cell ?? UITableViewCell()
            }
        }
        
        @objc func avatarAction(tap:UITapGestureRecognizer){
            self.alert("点击了头像")
        }
        
    }

