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
        self.type = sender.selectedSegmentIndex
        print(self)
    }
    
    @objc func myTapAction(){
        self.view.endEditing(true)
    }
    
    @IBAction func login(_ sender: Any) {
    }
    
    @IBAction func register(_ sender: Any) {
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
