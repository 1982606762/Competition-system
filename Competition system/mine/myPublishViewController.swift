//
//  myPublishViewController.swift
//  Competition system
//
//  Created by XuanLang Z on 2022/4/26.
//

import UIKit

class myPublishViewController: BaseVC {

    @IBOutlet weak var publishTable: UITableView!
    var dataArr:[ForumModel]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我发布的"
        publishTable.dataSource = self
        publishTable.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let array = RealmHelper.queryObject(objectClass: ForumModel(),filter:nil, "forum")
        self.dataArr = array.filter({ model in
            return Singleton.shared.userModel.publishList.contains(model.id)
        })
        self.publishTable.reloadData()
    }
}

extension myPublishViewController:UITableViewDataSource,UITableViewDelegate{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "commonTableViewCell")
        if cell == nil {
            cell = Bundle.main.loadNibNamed("commonTableViewCell", owner: nil, options:nil)?.first as! commonTableViewCell
        }
        (cell as! commonTableViewCell).product = self.dataArr?[indexPath.row]
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ForumDetailViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.product =  self.dataArr?[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }


}
