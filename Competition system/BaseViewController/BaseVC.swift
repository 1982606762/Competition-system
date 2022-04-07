//
//  BaseVC.swift
//  Competition system
//
//  Created by XuanLang Z on 2022/4/4.
//

import UIKit
typealias RightBClosure = ()->Void
class BaseVC: UIViewController, UIGestureRecognizerDelegate {

    var rightBTN:UIButton?
    var closures:RightBClosure?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.ColorHex(rgbValue: 0xF9F9F9)
        if let array = self.navigationController?.viewControllers, array.count > 1 {
            let image1:UIImage? = UIImage.init(named: "icon-back")
            let button1:UIButton = UIButton.init(type: .custom)
            button1.setImage(image1, for: .normal)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: button1)
            button1.addTarget(self, action:  #selector(backAction), for: .touchUpInside)
            self.navigationController?.interactivePopGestureRecognizer!.delegate = self
        }
    }
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return (self.navigationController?.children.count ?? 0 ) > 1
    }
    
    func addRightTitle(_ name:String, _ clourse:@escaping RightBClosure){
        self.closures  = clourse
        let btn = UIButton(type: .custom)
        btn .setTitle(name, for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.addTarget(self, action: #selector(rightConfirmAction), for: .touchUpInside)
        self.rightBTN = btn
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btn)
    }
    
    @objc func backAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightConfirmAction(){
        guard let sor = self.closures else{
            return
        }
        sor()
    }
    
}

