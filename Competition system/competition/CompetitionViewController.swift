//
//  CompetitionViewController.swift
//  Competition system
//
//  Created by XuanLang Z on 2022/4/9.
//

import UIKit

class CompetitionViewController: BaseVC,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    var dataArr:[[ForumModel]]?
    var dataArr1 = ["aaa","bbb","ccc"]
    var allData:[ForumModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "竞赛"
        weak var weakSelf = self
        addRightTitle("发布") {
            self.alert("发布pressed！")
        }
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let arr = self.dataArr?[section] ?? []
        if section == 0 {
            return arr.count > 0 ? "已认证" : "暂无认证竞赛,快去添加吧~"
        }
        return arr.count > 0 ? "未认证" : "暂无竞赛,快去添加吧~"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.ColorHex(rgbValue: 0xf2f2f2)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arr = self.dataArr?[section] ?? []
        return arr.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ForumTableViewCell")
        if cell == nil {
            cell = Bundle.main.loadNibNamed("ForumTableViewCell", owner: nil, options:nil)?.first as! ForumTableViewCell
        }
        (cell as! ForumTableViewCell).product = self.dataArr?[indexPath.section][indexPath.row]
        (cell as! ForumTableViewCell).parseBTN.tag = ( indexPath.section) * 10000 + indexPath.row
        (cell as! ForumTableViewCell).parseBTN.addTarget(self, action: #selector(parseAction(_:)), for: .touchUpInside)
        return cell ?? UITableViewCell()
    }
    
    @objc func parseAction (_ sender:UIButton){
        print(sender.tag)

    }
}

