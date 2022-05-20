//
//  NewsModel.swift
//  Competition system
//
//  Created by XuanLang Z on 2022/5/17.
//

import Foundation
import RealmSwift
class NewsModel:Object{
    //消息内容
    @Persisted var comment:String?
    //消息ID
    @Persisted var modelId:String?
    //竞赛作者ID
    @Persisted var authorId:String?
    //评论作者ID
    @Persisted var commentAuthorId:String?
}
