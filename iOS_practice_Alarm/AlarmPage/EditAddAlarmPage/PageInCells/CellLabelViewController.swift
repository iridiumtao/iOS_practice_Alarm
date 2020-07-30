//
//  CellLabelViewController.swift
//  iOS_practice_Alarm
//
//  Created by 歐東 on 2020/7/28.
//  Copyright © 2020 歐東. All rights reserved.
//

import UIKit

class CellLabelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var labelText = ""
    
    var completionHandler:((String) -> Void)?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell( withIdentifier: "Cell", for: indexPath) as! CellLabelTextFieldTableViewCell
        cell.textField.text = labelText
        return cell
    }
    
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("CellLabel: viewWillDisappear")
        
        let index = IndexPath(row: 0, section: 0)
        let cell = self.tableView.cellForRow(at: index) as! CellLabelTextFieldTableViewCell
        labelText = cell.textField.text!
        print("labelText: "+labelText)

        completionHandler?(labelText)
        
        

    }
    
    
}
