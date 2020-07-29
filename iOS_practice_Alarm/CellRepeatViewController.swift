//
//  CellRepeatViewController.swift
//  iOS_practice_Alarm
//
//  Created by 歐東 on 2020/7/28.
//  Copyright © 2020 歐東. All rights reserved.
//

import UIKit

class CellRepeatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let daysOfWeek: [String] = ["星期一","星期二","星期三","星期四","星期五","星期六","星期日"]

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        

    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell( withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = daysOfWeek[indexPath.row]
        return cell
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        
    }
    

}
