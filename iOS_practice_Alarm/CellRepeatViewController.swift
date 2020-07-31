//
//  CellRepeatViewController.swift
//  iOS_practice_Alarm
//
//  Created by 歐東 on 2020/7/28.
//  Copyright © 2020 歐東. All rights reserved.
//

import UIKit

class CellRepeatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let daysOfWeek: Dictionary<Int, String> = [1 : "星期日",
                                               2 : "星期一",
                                               3 : "星期二",
                                               4 : "星期三",
                                               5 : "星期四",
                                               6 : "星期五",
                                               7 : "星期六"]
    var selectedDaysOfWeek = Dictionary<Int, String>()
    
    var completionHandler:((Dictionary<Int, String>) -> Void)?
    private var selectedArray: NSMutableArray = []



    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        print(selectedDaysOfWeek)
        
        for selectedDay in selectedDaysOfWeek {
            selectedArray.add(selectedDay.key - 1)
        }
        print(selectedArray)

    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell( withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = daysOfWeek[indexPath.row + 1]
        
        
        // source: https://www.jianshu.com/p/3c45d744141b
        if selectedArray.count != 0 {
            if selectedArray.contains(indexPath.row) {
                cell.accessoryType = UITableViewCell.AccessoryType.checkmark
            } else {
                cell.accessoryType = UITableViewCell.AccessoryType.none
            }
        } else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedArray.count != 0 {
            if selectedArray.contains(indexPath.row) {
                selectedArray.removeObject(at: selectedArray.index(of: indexPath.row))
            } else {
                selectedArray.add(indexPath.row)
            }
        } else {
            selectedArray.add(indexPath.row)
        }
        
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        // 把 selectedDaysOfWeek 清空後，重新把選取的逐一塞入
        selectedDaysOfWeek.removeAll()
        for selected in selectedArray {
            let day = (selected as! Int) + 1
            selectedDaysOfWeek.updateValue(daysOfWeek[day]!, forKey: day)
        }
        
        completionHandler?(selectedDaysOfWeek)
    }
    

}
