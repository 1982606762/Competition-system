//
//  login.swift
//  Competition system
//
//  Created by XuanLang Z on 2022/3/28.
//

import UIKit

class LoginViewController: UIViewController {

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
    
    @IBAction func valueAction(_ sender: UISegmentedControl) {
        self.type = sender.selectedSegmentIndex
    }
    
    @objc func myTapAction() {
        self.view.endEditing(true)
    }
    
    
    
    

}

