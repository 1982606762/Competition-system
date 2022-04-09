//
//  Singleton.swift
//  Competition system
//
//  Created by XuanLang Z on 2022/4/9.
//

import UIKit

class Singleton {
    
    static let shared = Singleton()
    var userModel:UserModel = UserModel()
    private init() {
        
    }
    
}
