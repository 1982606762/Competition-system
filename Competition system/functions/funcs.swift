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

func getDocumentsDirectory() -> String {
    let paths = NSHomeDirectory().appending("/Documents")
    return paths
}

// MARK: - 字符串截取
extension String {
    /// String使用下标截取字符串
    /// string[index] 例如："abcdefg"[3] // c
    subscript (i:Int)->String{
        let startIndex = self.index(self.startIndex, offsetBy: i)
        let endIndex = self.index(startIndex, offsetBy: 1)
        return String(self[startIndex..<endIndex])
    }
    /// String使用下标截取字符串
    /// string[index..<index] 例如："abcdefg"[3..<4] // d
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            return String(self[startIndex..<endIndex])
        }
    }
    /// String使用下标截取字符串
    /// string[index,length] 例如："abcdefg"[3,2] // de
    subscript (index:Int , length:Int) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let endIndex = self.index(startIndex, offsetBy: length)
            return String(self[startIndex..<endIndex])
        }
    }
    // 截取 从头到i位置
    func substring(to:Int) -> String{
        return self[0..<to]
    }
    // 截取 从i到尾部
    func substring(from:Int) -> String{
        return self[from..<self.count]
    }
    
    
}


func updateTimeToCurrennTime(timeStamp: Double) -> String {
      //获取当前的时间戳
      let currentTime = Date().timeIntervalSince1970
      //时间戳为毫秒级要 ／ 1000， 秒就不用除1000，参数带没带000
      let timeSta:TimeInterval = TimeInterval(timeStamp)
      //时间差
      let reduceTime : TimeInterval = currentTime - timeSta
      //时间差小于60秒
      if reduceTime < 60 {
          return "刚刚"
      }
      //时间差大于一分钟小于60分钟内
      let mins = Int(reduceTime / 60)
      if mins < 60 {
          return "\(mins)分钟前"
      }
      let hours = Int(reduceTime / 3600)
      if hours < 24 {
          return "\(hours)小时前"
      }
      let days = Int(reduceTime / 3600 / 24)
      if days < 30 {
          return "\(days)天前"
      }
      //不满足上述条件---或者是未来日期-----直接返回日期
      let date = NSDate(timeIntervalSince1970: timeSta)
      let dfmatter = DateFormatter()
      //yyyy-MM-dd HH:mm:ss
      dfmatter.dateFormat="yyyy年MM月dd日 HH:mm:ss"
      return dfmatter.string(from: date as Date)
  }

