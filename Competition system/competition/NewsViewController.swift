//
//  NewsViewController.swift
//  Competition system
//
//  Created by XuanLang Z on 2022/5/15.
//

import UIKit

class NewsViewController: BaseVC {
    var dataSource:[NewsModel] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "消息列表"
        self.tableView.register(UINib(nibName: "NewsViewCell", bundle: .main), forCellReuseIdentifier: "NewsViewCell")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.dataSource =  RealmHelper.queryObject(objectClass: NewsModel(),filter:nil, "news")
        self.dataSource = self.dataSource.filter { modal in
            return modal.authorId == Singleton.shared.userModel.id
        }
        self.tableView.reloadData()
    }

}

extension NewsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NewsViewCell = tableView.dequeueReusableCell(withIdentifier: "NewsViewCell", for: indexPath) as! NewsViewCell
        let model = self.dataSource[indexPath.row]
        cell.nameLB.text = model.comment
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataSource[indexPath.row]
        let array = RealmHelper.queryObject(objectClass: ForumModel(), filter: nil, "forum")
        let filArray = array.filter { mo in
            return mo.id == model.modelId!
        }
        if !filArray.isEmpty{
            let vc = ForumDetailViewController()
            vc.product = filArray.first
            self.navigationController?.pushViewController(vc, animated:true)
        }
    }
}
