//
//  RegisterViewController.swift
//  Competition system
//
//  Created by XuanLang Z on 2022/4/7.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var retypePassword: UITextField!
    @IBOutlet weak var secretKey: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    
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

        self.nextBtn.layer.masksToBounds = true
        self.nextBtn.layer.cornerRadius = 8
        
        
        let ta = UITapGestureRecognizer.init(target: self, action: #selector(self.myTapAction))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(ta)
        // Do any additional setup after loading the view.
    }

    @objc func myTapAction(){
        self.view.endEditing(true)
    }
    
    @IBAction func value(_ sender: UISegmentedControl) {
        self.type = sender.selectedSegmentIndex
    }
    
    
    @IBAction func next(_ sender: Any) {
        self.myTapAction()
        if self.userName.text!.isEmpty {
            self.alert( self.type == 1 ? "邮箱不能为空" : "手机号不能为空")
            return
        }
        if self.userPassword.text!.isEmpty {
            self.alert("密码不能为空")
            return
        }
        if self.retypePassword.text!.isEmpty {
            self.alert("再次确认密码不能为空")
            return
        }
        if self.retypePassword.text != self.userPassword.text {
            self.alert("两次输入的密码不一致")
            return
        }
        
        let userModel:UserModel = UserModel()
        
        self.alert("xiayibu")
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
