//
//  BindViewController.swift
//  Competition system
//
//  Created by XuanLang Z on 2022/3/28.
//
import UIKit
import BSImagePicker
import Photos

class BindViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var btn: UIButton!
    
    var haveImage = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btn.layer.masksToBounds = true
        self.btn.layer.cornerRadius = 8;
    
        let ta = UITapGestureRecognizer.init(target: self, action: #selector(self.myTapAction))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(ta)
        
        let ta1 = UITapGestureRecognizer.init(target: self, action: #selector(self.iconAction))
        icon.isUserInteractionEnabled = true
        icon.addGestureRecognizer(ta1)
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
        self.haveImage = true
        self.icon.image = image
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
                self.haveImage = true
                PHImageManager.default().requestImage(for: assets[0], targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: nil) { (image, info) in
                    // Do something with image
                    self.icon.image = image
                }
            }
        })
    }



}
