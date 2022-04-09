//
//  user.swift
//  Competition system
//
//  Created by XuanLang Z on 2022/4/7.
//
//
import Foundation
class UserModel {
    ///昵称
    @objc dynamic var name = ""
    ///密码
    @objc dynamic var password = ""
    ///照片
    @objc dynamic var pic = ""
    ///学号
    @objc dynamic var number = ""
    ///邮箱
    @objc dynamic var email = ""
    ///手机
    @objc dynamic var phone = ""
    ///userID
    @objc dynamic var id = ""
    ///是否为管理员
    @objc dynamic var manage = false
    /// 收藏的id
    var collectList = Array<String>()
    /// 发布的id
    var publishList = Array<String>()
}
