//
//  funcs.swift
//  Competition system
//
//  Created by XuanLang Z on 2022/3/31.
//

import Foundation
import UIKit
import AVFoundation

let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height

let boardLeftMargin : CGFloat = 50
let margin : CGFloat = 7
var cellRowCount : Int = 5

extension UIView{
    
    func addCorner(byRoundingCorners corners: UIRectCorner , cornerRadii: CGFloat){
       let beisize:UIBezierPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.size.height), byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadii, height: cornerRadii))
       let shape:CAShapeLayer = CAShapeLayer()
       shape.path = beisize.cgPath;
       shape.frame = self.bounds
       self.layer.mask  = shape
   }
    
    func currentViewController() -> (UIViewController?) {
        let screnDelegate: UIWindowSceneDelegate? = {
        var uiScreen: UIScene?
        UIApplication.shared.connectedScenes.forEach { (screen) in
            uiScreen = screen
     }
          return (uiScreen?.delegate as? UIWindowSceneDelegate)
          }()
        var window =  screnDelegate?.window!
        
       if window?.windowLevel != UIWindow.Level.normal{
         let windows = UIApplication.shared.windows
         for  windowTemp in windows{
           if windowTemp.windowLevel == UIWindow.Level.normal{
              window = windowTemp
              break
            }
          }
        }
       let vc = window?.rootViewController
       return currentViewController(vc)
    }


    func currentViewController(_ vc :UIViewController?) -> UIViewController? {
       if vc == nil {
          return nil
       }
       if let presentVC = vc?.presentedViewController {
          return currentViewController(presentVC)
       }
       else if let tabVC = vc as? UITabBarController {
          if let selectVC = tabVC.selectedViewController {
              return currentViewController(selectVC)
           }
           return nil
        }
        else if let naiVC = vc as? UINavigationController {
           return currentViewController(naiVC.visibleViewController)
        }
        else {
           return vc
        }
     }

}


extension UIColor {
    class func rgbColor(red: Int, green: Int, blue: Int) -> UIColor {
        return UIColor(displayP3Red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1)
    }
}

extension UIDevice {
public func isiPhoneXMore() -> Bool {
    var isMore:Bool = false
    if #available(iOS 11.0, *) {
        let indexTemp:CGFloat = 0.0
        isMore = (UIApplication.shared.windows.first?.safeAreaInsets.bottom)! > indexTemp
    }
    return isMore
}
}


extension UIColor{
    static func ColorHex(rgbValue: Int) -> (UIColor) {
        return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0,
                       blue: ((CGFloat)(rgbValue & 0xFF)) / 255.0,alpha: 1.0)
    }
}

typealias SendValueClosure = (_ confirm: Bool)->Void
typealias ClickValueClosure = (_ confirm: String)->Void
extension UIViewController{
    func alert(_ title:String,_ cancel:String?,_ clourse:@escaping SendValueClosure){
        let alert = UIAlertController.init(title: "", message: title, preferredStyle: .alert)
        if cancel != nil {
            alert.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (make) in
                
            }))
        }
        alert.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (make) in
            clourse(true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func alert(_ title:String,_ cancel:String?){
        let alert = UIAlertController.init(title: "", message: title, preferredStyle: .alert)
        if cancel != nil {
            alert.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (make) in
                
            }))
        }
        alert.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (make) in

        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func alert(_ title:String){
        let alert = UIAlertController.init(title: "", message: title, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (make) in

        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func alertSheet(_ title:String,_ cancel:String?,_ clourse:@escaping ClickValueClosure,_ list:[String]){
        let alert = UIAlertController.init(title: "", message: title, preferredStyle: .actionSheet)
        for str in list {
            alert.addAction(UIAlertAction(title: str, style: .default, handler: { (make
        ) in
            clourse(str)
        }))
        }
        if cancel != nil {
            alert.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (make) in
            }))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
}
