//
//  CompetitionViewController.swift
//  Competition system
//
//  Created by XuanLang Z on 2022/4/9.
//

import UIKit

class CompetitionViewController: BaseVC{
    
    @IBOutlet weak var tableView: UITableView!
    var dataArr:[[ForumModel]]?
    var allData:[ForumModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "竞赛"
        tableView.register(UINib(nibName: "ForumTableViewCell", bundle: nil), forCellReuseIdentifier: "ForumTableViewCell")
        self.tableView.dataSource = self
        weak var weakSelf = self
        addRightTitle("发布") {
            self.alert("发布pressed！")
        }
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("appear")
        let model = ForumModel()
        model.content = "content"
        model.auth = true
        model.title = "title"
        model.date = 1649904639.033158
        let model2 = ForumModel()
        model2.content = "content"
        model2.auth = false
        model2.title = "title"
        model2.date = 1649904639.033158
        let array = [model,model2]
        self.dataArr  = [[],array]

        self.allData = array
        self.updateUI(array,nil)
    }
    
    func updateUI(_ array:[ForumModel]?,_ searchStr:String?){
        var ingArray:[ForumModel] = []
        var finisharray:[ForumModel] = []
        if let array = array {
            for s:ForumModel in array {
                if s.auth {
                    if let searchStr = searchStr,searchStr.count > 0 {
                        if s.authorName.contains(searchStr) || s.title.contains(searchStr) || s.content.contains(searchStr){
                            ingArray.append(s)
                        }
                    }else{
                        ingArray.append(s)
                    }
                }else{
                    if let searchStr = searchStr,searchStr.count > 0 {
                        if s.authorName.contains(searchStr) || s.title.contains(searchStr) || s.content.contains(searchStr){
                            finisharray.append(s)
                        }
                    }else{
                        finisharray.append(s)
                    }
                }
            }
        }
        self.dataArr = [ingArray,finisharray]
        self.tableView.reloadData()
    }
}

extension CompetitionViewController:UITableViewDataSource,UITableViewDelegate{
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
        self.alert("收藏")

    }
}
