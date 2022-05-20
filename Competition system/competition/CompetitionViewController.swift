//
//  CompetitionViewController.swift
//  Competition system
//
//  Created by XuanLang Z on 2022/4/9.
//

import UIKit

class CompetitionViewController: BaseVC{
    
    @IBOutlet weak var serach: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var dataArr:[[ForumModel]]?
    var allData:[ForumModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "竞赛"
        tableView.register(UINib(nibName: "ForumTableViewCell", bundle: nil), forCellReuseIdentifier: "ForumTableViewCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.serach.delegate = self
        weak var weakSelf = self
        addRightTitle("发布") {
            let vc = ForumPublishViewController()
            vc.hidesBottomBarWhenPushed = true
            weakSelf!.navigationController?.pushViewController(vc, animated: true)
        }
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let array = RealmHelper.queryObject(objectClass: ForumModel(),filter:nil, "forum")
        self.allData = array
        self.updateUI(array,nil)
    }
    
    func updateUI(_ array:[ForumModel]?,_ searchStr:String?){
        var ingArray:[ForumModel] = []
        var finisharray:[ForumModel] = []
        if let array = array {
            for s:ForumModel in array {
                if s.auth == 1 {
                    if let searchStr = searchStr,searchStr.count > 0 {
                        if s.authorName.contains(searchStr) || s.title.contains(searchStr) || s.content.contains(searchStr){
                            ingArray.append(s)
                        }
                    }else{
                        ingArray.append(s)
                    }
                }else if s.auth == 2{
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


extension CompetitionViewController:UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.updateUI(self.allData,searchBar.text)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.updateUI(self.allData,searchBar.text)
        self.view.endEditing(true)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ForumDetailViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.product =  self.dataArr?[indexPath.section][indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func parseAction (_ sender:UIButton){
        print(sender.tag)
        let section = sender.tag / 10000
        let row = sender.tag % 10000
        if let model = self.dataArr?[section][row] {
            let contain = model.collectUserList.contains(Singleton.shared.userModel.id)
            RealmHelper.updateBlock({
                if contain {
                    let indexC = model.collectUserList.firstIndex(of: Singleton.shared.userModel.id)
                    if let indexC = indexC{
                        model.collectUserList.remove(at: indexC)
                    }
                }else{
                    model.collectUserList.append(Singleton.shared.userModel.id)
                }
            }, "forum", model)
            
            
            RealmHelper.updateBlock({
                if contain  {
                    let indexC = Singleton.shared.userModel.collectList.firstIndex(of: model.id)
                    if let indexC = indexC{
                        Singleton.shared.userModel.collectList.remove(at: indexC)
                    }
                }else{
                    Singleton.shared.userModel.collectList.append(model.id)
                }
            }, "user",  Singleton.shared.userModel)
            self.tableView.reloadData()
        }
    }
}
