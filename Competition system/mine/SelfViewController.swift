//
//  SelfViewController.swift
//  Competition system
//
//  Created by XuanLang Z on 2022/4/9.
//

import UIKit
import BSImagePicker
import Photos

class SelfViewController: BaseVC {
    var dataArr:[String] = []
    var imageIV:UIImageView?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Singleton.shared.userModel.manage{
            self.dataArr = ["头像","手机号","邮箱","学号","我的发布","我的收藏","待审核竞赛","人员管理"]
        }else{
            self.dataArr = ["头像","手机号","邮箱","学号","我的发布","我的收藏"]
        }
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.title = "我的"
        self.addRightTitle("消息列表") {
            let vc = NewsViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
                    cell?.selectionStyle = .none
                }
                return cell ?? UITableViewCell()
            }else{
                var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
                if cell == nil {
                    cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
                }
                cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                cell?.textLabel?.text = self.dataArr[indexPath.row]
                cell?.accessoryType = .disclosureIndicator
                return cell ?? UITableViewCell()
            }
        }
        
        @objc func avatarAction(tap:UITapGestureRecognizer){
            picSelect()
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if indexPath.row == 0{
                let vc = nameViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if indexPath.row == 1{
                let vc = nameViewController()
                vc.type = 1
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if indexPath.row == 2{
                let vc = nameViewController()
                vc.type = 2
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if indexPath.row == 4{
                let vc = myPublishViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if indexPath.row == 5{
                let vc = myFavourViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if indexPath.row == 6{
                let vc = AuditListViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if indexPath.row == 7{
                let vc = ManagePeopleViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    
        @objc func picSelect() {
            self.alertSheet("请选择", "取消", { (str) in
                if str == "拍照"{
                    self.openCamera()
                }else{
                    self.picAction()
                }
            }, ["拍照","我的相册"])
        }
        func openCamera(){
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let picker = UIImagePickerController()
                //设置代理
                picker.delegate = self
                picker.sourceType = .camera
                picker.allowsEditing = true
                self.present(picker, animated: true, completion: nil)
            }
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            print(info)
            let image = info[.originalImage] as! UIImage
            self.imageIV!.image = image
            self.upload()
            picker.dismiss(animated: true, completion: nil)
        }
        
        func picAction(){
            let imagePicker = ImagePickerController()
            imagePicker.settings.selection.max = 1
            imagePicker.settings.theme.selectionStyle = .numbered
            imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
            imagePicker.settings.selection.unselectOnReachingMax = true
            presentImagePicker(imagePicker, select: { (asset) in
                // User selected an asset. Do something with it. Perhaps begin processing/upload?
            }, deselect: { (asset) in
                // User deselected an asset. Cancel whatever you did when asset was selected.
            }, cancel: { (assets) in
                // User canceled selection.
            }, finish: { (assets) in
                // User finished selection assets.
                if assets.count > 0{
                    PHImageManager.default().requestImage(for: assets[0], targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: nil) { (image, info) in
                        // Do something with image
                        self.imageIV!.image = image
                        self.upload()
                    }
                }
            })
        }
        
        func upload(){
            
            if  let image = self.imageIV!.image,let data = image.pngData() {
                let userModel = Singleton.shared.userModel
                let filename = getDocumentsDirectory().appending("/\(userModel.name)\(userModel.phone)\(userModel.email)userAvatar.png")
                let url = NSURL(fileURLWithPath: filename)
                try? data.write(to: url as URL)
                RealmHelper.updateBlock({
                    userModel.pic = filename
                }, "user",userModel)
            }
        }
    }

