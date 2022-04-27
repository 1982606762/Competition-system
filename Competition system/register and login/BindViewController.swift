//
//  BindViewController.swift
//  Competition system
//
//  Created by XuanLang Z on 2022/4/7.
//

import UIKit
import BSImagePicker
import Photos

class BindViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var ID: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    var userModel:UserModel?
    var haveImg = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("-----------",userModel)
        self.registerBtn.layer.masksToBounds = true
        self.registerBtn.layer.cornerRadius = 8;
    
        let ta = UITapGestureRecognizer.init(target: self, action: #selector(self.myTapAction))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(ta)
        
        let ta1 = UITapGestureRecognizer.init(target: self, action: #selector(self.iconAction))
        picture.isUserInteractionEnabled = true
        picture.addGestureRecognizer(ta1)
        // Do any additional setup after loading the view.
    }
    @objc func myTapAction(){
        self.view.endEditing(true)
    }
    
    @objc func iconAction(){
       picAction()
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
        self.haveImg = true
        self.picture.image = image
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
                self.haveImg = true
                PHImageManager.default().requestImage(for: assets[0], targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: nil) { (image, info) in
                    // Do something with image
                    self.picture.image = image
                }
            }
        })
    }
    @IBAction func bind(_ sender: Any) {
        if self.ID.text!.isEmpty{
            self.alert("学号不能为空")
        }
        if self.name.text!.isEmpty{
            self.alert("昵称不能为空")
        }else if let userModel = userModel {
            let name = self.name.text
            let number = self.ID.text
            userModel.name = name!
            userModel.number = number!
        
            if self.haveImg, let image = self.picture.image,let data = image.pngData() {
                let filename = getDocumentsDirectory().appending("/\(userModel.name)\(userModel.phone)\(userModel.email)userAvatar.png")
                let url = NSURL(fileURLWithPath: filename)
                try? data.write(to: url as URL)
                userModel.pic = filename
            }
            RealmHelper.addObject(object: userModel, "user")

            self.alert(userModel.manage ? "注册管理员成功" : "注册成功",nil) { (success) in
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
}
