//
//  LoginViewController.swift
//  Competition system
//
//  Created by XuanLang Z on 2022/4/7.
//

import UIKit

class LoginViewController: BaseVC {
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    var _type:Int?
    var type:Int?{
        set{
            _type = newValue
            if _type == 0{
                self.userName.placeholder = "请输入手机号"
            }else if _type == 1{
                self.userName.placeholder = "请输入邮箱"
            }
        }get{
            return _type
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.type = 0
        self.loginBtn.layer.masksToBounds = true
        self.loginBtn.layer.cornerRadius = 8;
    
        let ta = UITapGestureRecognizer.init(target: self, action: #selector(self.myTapAction))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(ta)
        // Do any additional setup after loading the view.
    }

    
    
    @IBAction func value(_ sender: UISegmentedControl) {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        self.type = sender.selectedSegmentIndex
        self.userPassword.text = ""
        self.userName.text = ""
    }
    
    @objc func myTapAction(){
        self.view.endEditing(true)
    }
    
    @IBAction func login(_ sender: Any) {
        let array:[UserModel] = RealmHelper.queryObject(objectClass: UserModel(), filter: nil, "user")
        
        if array.count == 0 {
            self.alert("用户尚未注册,请先注册")
            return
        }else{
            let users = array.filter { user in
                return  self.type == 1 ? (user.email  == self.userName.text) : (user.phone  == self.userName.text)
            }
            
            if users.count == 0{
                self.alert("用户尚未注册,请先注册")
                return
            }else{
                let u = users[0]
                if u.password != self.userPassword.text!{
                    self.alert("密码错误")
                    return
                }
            }
            Singleton.shared.userModel = users.first!
            UserDefaults.standard.setValue(Singleton.shared.userModel.id, forKey: "token")
        }
        
        
        let screnDelegate: UIWindowSceneDelegate? = {
        var uiScreen: UIScene?
        UIApplication.shared.connectedScenes.forEach { (screen) in
            uiScreen = screen
          }
          return (uiScreen?.delegate as? UIWindowSceneDelegate)
          }()
        screnDelegate?.window!?.rootViewController = Tabbar()
        self.alert("登录成功")
    }
    
    @IBAction func register(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        self.navigationController?.pushViewController(RegisterViewController(), animated: true)
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
