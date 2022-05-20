//
//  ManagePeopleViewController.swift
//  Competition system
//
//  Created by XuanLang Z on 2022/5/17.
//

import UIKit

class ManagePeopleViewController: BaseVC {
    var dataSource:[UserModel] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "人员管理"
        self.tableView.register(UINib(nibName: "PeopleViewCell", bundle: .main), forCellReuseIdentifier: "PeopleViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.dataSource = RealmHelper.queryObject(objectClass: UserModel(), filter: nil, "user")
        self.tableView.reloadData()
    }
}

extension ManagePeopleViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PeopleViewCell = tableView.dequeueReusableCell(withIdentifier: "PeopleViewCell", for: indexPath) as! PeopleViewCell
        let model = self.dataSource[indexPath.row]
        cell.nameLB.text = model.name + (model.manage ? "(管理员)" : "")
        cell.detailL.text = (model.manage ? "(管理员)" : "非管理员")
        cell.iconIV.image = UIImage(contentsOfFile:model.pic)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataSource[indexPath.row]
        let vc = PeopleDetailViewController()
        vc.model = self.dataSource[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

