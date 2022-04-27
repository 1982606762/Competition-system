//
//  nameViewController.swift
//  Competition system
//
//  Created by XuanLang Z on 2022/4/26.
//

import UIKit
    
class nameViewController: BaseVC {

    @IBOutlet weak var namelable: UITextField!
    var type = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        weak var weakself = self
        if self.type == 0 {
            self.title = "修改昵称"
            self.namelable.placeholder = "请输入昵称"
            self.namelable.text = Singleton.shared.userModel.name
            self.addRightTitle("确定") {
                guard let name = weakself!.namelable.text, !name.isEmpty else {
                    weakself!.alert("昵称不能为空")
                    return
                }
                
                let array:[UserModel] = RealmHelper.queryObject(objectClass: UserModel(), filter: nil, "user")
                let users = array.filter { user in
                    return  user.name  == name && user.id != Singleton.shared.userModel.id
                }
                if users.count > 0 {
                    weakself!.alert("昵称已被占用,请重新输入")
                    return
                }
                
                RealmHelper.updateBlock({
                    Singleton.shared.userModel.name = name
                    weakself!.navigationController?.popViewController(animated: true)
                }, "user", Singleton.shared.userModel)
            }
        }else if self.type == 1 {
            self.title = "修改手机号"
            self.namelable.placeholder = "请输入手机号"
            self.namelable.text = Singleton.shared.userModel.phone
            self.addRightTitle("确定") {
                guard let name = weakself!.namelable.text, !name.isEmpty else {
                    weakself!.alert("手机号不能为空")
                    return
                }
                
                let array:[UserModel] = RealmHelper.queryObject(objectClass: UserModel(), filter: nil, "user")
                let users = array.filter { user in
                    return  user.phone  == name && user.id != Singleton.shared.userModel.id
                }
                if users.count > 0 {
                    weakself!.alert("手机号码已被占用,请重新输入")
                    return
                }
                
                RealmHelper.updateBlock({
                    Singleton.shared.userModel.phone = name
                    weakself!.navigationController?.popViewController(animated: true)
                }, "user", Singleton.shared.userModel)
            }
        }else {
            self.title = "修改邮箱"
            self.namelable.placeholder = "请输入邮箱"
            self.namelable.text = Singleton.shared.userModel.email
            self.addRightTitle("确定") {
                guard let name = self.namelable.text, !name.isEmpty else {
                    weakself!.alert("邮箱不能为空")
                    return
                }
                let array:[UserModel] = RealmHelper.queryObject(objectClass: UserModel(), filter: nil, "user")
                let users = array.filter { user in
                    return  user.email  == name && user.id != Singleton.shared.userModel.id
                }
                if users.count > 0 {
                    weakself!.alert("邮箱已被占用,请重新输入")
                    return
                }
                
                RealmHelper.updateBlock({
                    Singleton.shared.userModel.email = name
                    weakself!.navigationController?.popViewController(animated: true)
                }, "user", Singleton.shared.userModel)
            }
        }
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
