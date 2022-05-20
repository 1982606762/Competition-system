//
//  PeopleDetailVC.swift
//  Competition system
//
//  Created by XuanLang Z on 2022/5/17.
//

import UIKit
import Realm
import BSImagePicker
import Photos

class PeopleDetailViewController: BaseVC {

    @IBOutlet weak var deleteBTN: UIButton!
    @IBOutlet weak var iconIV: UIImageView!
    @IBOutlet weak var btn: UIButton!
    var model:UserModel?
    @IBOutlet weak var emailLB: UITextField!
    @IBOutlet weak var phoneLb: UITextField!
    @IBOutlet weak var nameLB: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.iconIV.addCorner(byRoundingCorners: .allCorners, cornerRadii: 40)
        if let model = model {
            nameLB.text = model.name
            phoneLb.text = model.phone
            emailLB.text = model.email
            
            
            self.iconIV.image = UIImage(contentsOfFile:model.pic)
            
            let tap1 = UITapGestureRecognizer(target: self, action: #selector(picSelect))
            self.iconIV.addGestureRecognizer(tap1)
            self.iconIV.isUserInteractionEnabled = true
            
            if model.manage && model.id != Singleton.shared.userModel.id{
                nameLB.isUserInteractionEnabled = false
                phoneLb.isUserInteractionEnabled = false
                emailLB.isUserInteractionEnabled = false
                nameLB.placeholder = nil
                phoneLb.placeholder = nil
                emailLB.placeholder = nil
                btn.isHidden = true
                deleteBTN.isHidden = true
                self.iconIV.isUserInteractionEnabled = false
            }
            if model.id == Singleton.shared.userModel.id{
                deleteBTN.isHidden = true
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        if let model = model {
            RealmHelper.deleteObject(object: model, "user")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        guard let model = model else {
            return
        }
        if model.manage && model.id != Singleton.shared.userModel.id{
            return
        }
        guard let name = self.nameLB.text, !name.isEmpty else {
            self.alert("昵称不能为空")
            return
        }
        
        let array:[UserModel] = RealmHelper.queryObject(objectClass: UserModel(), filter: nil, "user")
        let users = array.filter { user in
            return  user.name  == name && user.id != model.id
        }
        if users.count > 0 {
            self.alert("昵称已被占用,请重新输入")
            return
        }
        
        RealmHelper.updateBlock({
            model.name = name
        }, "user", Singleton.shared.userModel)
        
        var changePhone:String?
        if !model.phone.isEmpty{
            guard let phone = self.phoneLb.text,!phone.isEmpty else{
                self.alert("手机号不能为空")
                return
            }
            let users1 = array.filter { user in
                return  user.phone  == phone && user.id != model.id
            }
            if users1.count > 0 {
                self.alert("手机号码已被占用,请重新输入")
                return
            }
            changePhone = phone
        }else{
            if let phone = self.phoneLb.text,!phone.isEmpty{
                let users1 = array.filter { user in
                    return  user.phone  == phone
                }
                if users1.count > 0 {
                    self.alert("手机号码已被占用,请重新输入")
                    return
                }
                changePhone = phone
            }
        }
        
        var changeEmail:String?
        if !model.email.isEmpty{
            guard let email = self.emailLB.text,!email.isEmpty else{
                self.alert("邮箱不能为空")
                return
            }
            let users1 = array.filter { user in
                return  user.email  == email && user.id != model.id
            }
            if users1.count > 0 {
                self.alert("邮箱已被占用,请重新输入")
                return
            }
            
            changeEmail = email
        }else{
            if let email = self.emailLB.text,!email.isEmpty{
                let users1 = array.filter { user in
                    return  user.email  == email
                }
                if users1.count > 0 {
                    self.alert("邮箱已被占用,请重新输入")
                    return
                }
                changeEmail = email
            }
        }

        RealmHelper.updateBlock({
            model.name = name
            if let changeEmail = changeEmail {
                model.email = changeEmail
            }
            if let changePhone = changePhone {
                model.phone = changePhone
            }
            
            if  let image = self.iconIV.image,let data = image.pngData() {
                let filename = getDocumentsDirectory().appending("/\(model.name)\(model.phone)\(model.email)userAvatar.png")
                let url = NSURL(fileURLWithPath: filename)
                try? data.write(to: url as URL)
                model.pic = filename
            }
            
            self.alert("修改成功",nil) { (success) in
                self.navigationController?.popViewController(animated: true)
            }
        }, "user", model)
        
        
    }
    
}

extension PeopleDetailViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
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
        self.iconIV.image = image
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
                    self.iconIV.image = image
                }
            }
        })
    }
}
