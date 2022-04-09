//
//  Tabbar.swift
//  Competition system
//
//  Created by XuanLang Z on 2022/4/8.
//

import Foundation
import UIKit

class Tabbar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        let chartVC = UINavigationController(rootViewController:CompetitionViewController())
        chartVC.title = "竞赛"
        chartVC.tabBarItem.image = UIImage(named: "talk")!.withRenderingMode(.alwaysOriginal)
        chartVC.tabBarItem.selectedImage = UIImage(named: "talk1")!.withRenderingMode(.alwaysOriginal)
        
        let mineVC = UINavigationController(rootViewController:SelfViewController())
        mineVC.title = "我的"
        mineVC.tabBarItem.image = UIImage(named: "my")!.withRenderingMode(.alwaysOriginal)
        mineVC.tabBarItem.selectedImage = UIImage(named: "my1")!.withRenderingMode(.alwaysOriginal)
        
        self.viewControllers = [chartVC,mineVC]
        // Do any additional setup after loading the view.
    }


}
