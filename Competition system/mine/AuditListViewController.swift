//
//  AuditListViewController.swift
//  Competition system
//
//  Created by XuanLang Z on 2022/5/17.
//

import UIKit

class AuditListViewController: BaseVC {
    var dataSource:[ForumModel] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "待审核竞赛"
        self.tableView.register(UINib(nibName: "NewsViewCell", bundle: .main), forCellReuseIdentifier: "NewsViewCell")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let array = RealmHelper.queryObject(objectClass: ForumModel(),filter:nil, "forum")
        self.dataSource = array.filter({ mo in
            return mo.auth == 0
        })
        self.tableView.reloadData()
    }
}


extension AuditListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NewsViewCell = tableView.dequeueReusableCell(withIdentifier: "NewsViewCell", for: indexPath) as! NewsViewCell
        let model = self.dataSource[indexPath.row]
        cell.nameLB.text = model.title
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ForumDetailViewController()
        vc.product = self.dataSource[indexPath.row]
        vc.audit = true
        self.navigationController?.pushViewController(vc, animated:true)
    }
}
