//
//  UIKitExtension.swift
//  Competition system
//
//  Created by XuanLang Z on 2022/4/4.
//

import Foundation
import UIKit

extension UITextView:UITextViewDelegate{
    private struct RuntimeKey {
        static let hw_placeholderLabelKey = UnsafeRawPointer.init(bitPattern: "hw_placeholderLabelKey".hashValue)
        /// ...其他Key声明
    }
 
    /// 占位文字
    @IBInspectable public var placeholder: String {
        get {
            return self.placeholderLabel.text ?? ""
        }
        set {
            self.placeholderLabel.text = newValue
        }
    }
 
    /// 占位文字颜色
    @IBInspectable public var placeholderColor: UIColor {
        get {
            return self.placeholderLabel.textColor
        }
        set {
            self.placeholderLabel.textColor = newValue
        }
    }
 
    private var placeholderLabel: UILabel {
        get {
            var label = objc_getAssociatedObject(self, UITextView.RuntimeKey.hw_placeholderLabelKey!) as? UILabel
            if label == nil {
                if (self.font == nil) {
                    self.font = UIFont.systemFont(ofSize: 14)
                }
                label = UILabel.init(frame: self.bounds)
                label?.numberOfLines = 0
                label?.font = self.font
                label?.textColor = UIColor.lightGray
                self.addSubview(label!)
                self.delegate = self
                self.setValue(label!, forKey: "_placeholderLabel")
                objc_setAssociatedObject(self, UITextView.RuntimeKey.hw_placeholderLabelKey!, label!, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                self.sendSubviewToBack(label!)
            }
            return label!
        }
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.hw_placeholderLabelKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        self.placeholderLabel.isHidden = !textView.text.isEmpty
    }
}


extension UILabel{
    func addLinkText(text:NSString){
        self.attributedText = subStr(string: text);
    }
    
    
    func subStr(string:NSString)->NSMutableAttributedString{
        var attributedText:NSMutableAttributedString = NSMutableAttributedString()
        let regulaStr = "((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"
        do{
            let regex = try NSRegularExpression.init(pattern: regulaStr, options: .caseInsensitive)
            let arrayOfAllMatches = regex.matches(in: string as String, options: NSRegularExpression.MatchingOptions.init(rawValue: 0) , range: NSRange(location: 0, length: string.length))
            var arr:[String] = []
            var rangeArr:[NSValue] = []
            for match in arrayOfAllMatches {
                let substringForMatch = string.substring(with: match.range)
                arr.append(substringForMatch)
            }
            let subStr = string
            for str in arr {
                rangeArr.append(rangesOfString(searchString: str, str: subStr))
            }
            attributedText = NSMutableAttributedString(string: subStr as String, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
            for value in rangeArr{
                let index =  rangeArr.firstIndex(of: value)
                let range = value.rangeValue;
                attributedText.addAttribute(NSAttributedString.Key.link , value: NSURL(string: arr[index!]), range: range)
                attributedText.addAttribute(NSAttributedString.Key.foregroundColor , value: UIColor.blue, range: range)

            }
        }catch{
            
        }
        return attributedText
    }
    func rangesOfString(searchString:String,str:NSString)->NSValue{
        var searchRange = NSRange(location: 0, length: str.length)
        let range:NSRange = str.range(of: searchString, options: .caseInsensitive, range: searchRange)
        if range.location != NSNotFound{
            searchRange =  NSMakeRange(NSMaxRange(range), str.length - NSMaxRange(range))
        }
        return NSValue(range: range)
    }
}
