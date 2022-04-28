//
//  ForumPublishViewController.swift
//  Competition system
//
//  Created by XuanLang Z on 2022/4/25.
//

import UIKit
import BSImagePicker
import Photos

class ForumPublishViewController: BaseVC,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var titleName: UITextField!
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var img: UIImageView!
    var haveImg = false
    var edit = false
    var forumModel:ForumModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.view.addGestureRecognizer(tap1)
        
        self.img.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(picSelect))
        self.img.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
                
        if edit, let forumModel = forumModel{
            self.titleName.text = forumModel.title
            self.content.text = forumModel.content
            self.img.image = UIImage.init(contentsOfFile: forumModel.pic)
            self.title = "编辑竞赛"
        }else{
            self.title = "发布竞赛"
        }
        
        addRightTitle("确定") {
            self.confirmAction()
        }
        // Do any additional setup after loading the view.
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        let image = info[.originalImage] as! UIImage
        self.haveImg = true
        self.img.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    @objc func tapAction(){
        self.view.endEditing(true)
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
                    self.img.image = image
                }
            }
        })
    }
    func clear(){
        self.titleName.text = ""
        self.content.text = ""
        self.haveImg = false
        self.img.image = UIImage(named: "add")
    }
    
     func confirmAction() {
         self.view.endEditing(true)
         weak var weakself = self
         if self.titleName.text?.count == 0 {
             self.alert("标题不能为空")
             return
         }
        if self.content.text?.count == 0 {
            self.alert("内容不能为空")
            return
        }
        if self.edit ,let forumModel = forumModel{
             RealmHelper.updateBlock({
                 forumModel.title = weakself!.titleName.text!
                 forumModel.content = weakself!.content.text!
                 if let image = self.img.image,let data = image.pngData() {
                     let filename = getDocumentsDirectory().appending("/forum_\(forumModel.id).png")
                     let url = NSURL(fileURLWithPath: filename)
                     try? data.write(to: url as URL)
                     forumModel.pic = filename
                 }
             }, "forum", forumModel)
             
             alert("修改成功", nil) { confirm in
                 weakself!.navigationController?.popViewController(animated: true)
             }

         }else{
             let product:ForumModel = ForumModel()
             product.title = self.titleName.text!
             product.content = self.content.text!
             product.authorName = Singleton.shared.userModel.name
             product.authorAvatar = Singleton.shared.userModel.pic
             product.authorId = Singleton.shared.userModel.id
             product.id = UUID().uuidString
             product.date = Date().timeIntervalSince1970
             product.auth = Singleton.shared.userModel.manage
             var image:UIImage?
             if !self.haveImg {
                image = UIImage(named: "icon")
             }else{
                image = self.img.image
             }
             
             if let image = image,let data = image.pngData() {
                 let filename = getDocumentsDirectory().appending("/forum_\(product.id).png")
                 let url = NSURL(fileURLWithPath: filename)
                 try? data.write(to: url as URL)
                 product.pic = filename
             }
             RealmHelper.addObject(object: product,"forum")
             
             
             RealmHelper.updateBlock({
                 Singleton.shared.userModel.publishList.append(product.id)
             }, "user", Singleton.shared.userModel)
             weak var weakself = self
              alert("发布成功", nil) {
                  confirm in
                  weakself!.navigationController?.popViewController(animated: true)
              }
             self.clear()
         }
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
