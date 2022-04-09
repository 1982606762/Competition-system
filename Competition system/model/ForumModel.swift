//
//  ForumModel.swift
//  Competition system
//
//  Created by XuanLang Z on 2022/4/9.
//

import Foundation
import RealmSwift
class ForumModel:Object{
    ///标题
    @objc dynamic var title = ""
    ///内容
    @objc dynamic var content = ""
    ///日期
    @objc dynamic var date:Double = 0.0
    ///图片
    @objc dynamic var pic = ""
    ///唯一id
    @objc dynamic var id = ""
    ///收藏者id集合
    var collectUserList = Array<String>()
    ///是否认证
    @objc dynamic var auth = false
    ///被管理员删除
    @objc dynamic var isDelete = false
    ///作者id
    @objc dynamic var authorId = ""
    ///作者名字
    @objc dynamic var authorName = ""
    ///作者头像
    @objc dynamic var authorAvatar = ""
    ///评论列表
    var commentList = List<CommentModel>()
    
}

class CommentModel: Object {
    ///作者名字
    @objc dynamic var authorName = ""
    ///作者头像
    @objc dynamic var authorAvatar = ""
    ///日期
    @objc dynamic var date:Double = 0.0
    ///内容
    @objc dynamic var title = ""
    let owners = LinkingObjects(fromType: ForumModel.self, property: "commentList")
}
