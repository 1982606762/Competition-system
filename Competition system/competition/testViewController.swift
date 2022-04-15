//
//  testViewController.swift
//  Competition system
//
//  Created by XuanLang Z on 2022/4/10.
//

import UIKit

class testViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    var forums:[testModel] = [
        testModel(name: "qwe", content: "asd"),
        testModel(name: "name2", content: "ahahaha"),
        testModel(name: "name3", content: "阿巴阿巴")
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.register(UINib(nibName: "testTableViewCell", bundle: nil), forCellReuseIdentifier: "newIdentifier")
        self.tableview.dataSource = self
        // Do any additional setup after loading the view.
    }


}
extension testViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newIdentifier", for: indexPath)
            as!testTableViewCell
        cell.content.text = String(indexPath.row)
        cell.name.text = String(indexPath.section)
        

        return cell
    }
    
    
}
