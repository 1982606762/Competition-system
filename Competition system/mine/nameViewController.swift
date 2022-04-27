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
                self.alert("确定！")
            }
        }else if self.type == 1 {
            self.title = "修改手机号"
            self.namelable.placeholder = "请输入手机号"
            self.namelable.text = Singleton.shared.userModel.phone
            self.addRightTitle("确定") {
                self.alert("确定！")
            }
        }else {
            self.title = "修改邮箱"
            self.namelable.placeholder = "请输入邮箱"
            self.namelable.text = Singleton.shared.userModel.email
            self.addRightTitle("确定") {
                self.alert("确定！")
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
