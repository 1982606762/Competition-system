//
//  registerViewController.swift
//  Competition system
//
//  Created by XuanLang Z on 2022/3/28.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var adkey: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var reUserPassword: UITextField!
    @IBOutlet weak var btn: UIButton!
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
        
        self.btn.layer.masksToBounds = true
        self.btn.layer.cornerRadius = 8;
    
        let ta = UITapGestureRecognizer.init(target: self, action: #selector(self.myTapAction))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(ta)
        // Do any additional setup after loading the view.
    }
    
    @objc func myTapAction(){
        self.view.endEditing(true)
    }
    
    @IBAction func titileSelectAction(_ sender: UISegmentedControl) {
        self.type = sender.selectedSegmentIndex
    }

    @IBAction func registerAction(_ sender: Any) {
        self.myTapAction()
        if self.userName.text!.isEmpty {
            self.alert( self.type == 1 ? "邮箱不能为空" : "手机号不能为空")
            return
        }
        if self.userPassword.text!.isEmpty {
            self.alert("密码不能为空")
            return
        }
        if self.reUserPassword.text!.isEmpty {
            self.alert("再次确认密码不能为空")
            return
        }
        if self.reUserPassword.text != self.userPassword.text {
            self.alert("两次输入的密码不一致")
            return
        }
        
    }
}

