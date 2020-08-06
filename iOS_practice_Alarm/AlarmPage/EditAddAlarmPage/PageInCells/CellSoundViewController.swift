//
//  CellNotifyViewController.swift
//  iOS_practice_Alarm
//
//  Created by 歐東 on 2020/7/28.
//  Copyright © 2020 歐東. All rights reserved.
//

import UIKit

class CellSoundViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    var shakeMode = ["震動模式"]
    var shop = ["鈴聲商店","下載所有購買的鈴聲"]
    var song = ["選擇歌曲"]
    var sound = ["雷達（預設值）","上升","山坡","公告","水晶","宇宙","波浪","信號","急板","指標","星座","海邊","閃爍","頂尖",
                 "頂峰","絲綢","開場","煎茶","照耀","遊戲時間","電路","漣漪","漸強","貓頭鷹","輻射","鐘聲","觀星","經典"]
    var none = ["無"]
    
    var selectedText = ""
    var completionHandler: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return shakeMode.count
        case 1:
            return shop.count
        case 2:
            return song.count
        case 3:
            return sound.count
        case 4:
            return none.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = shakeMode[indexPath.row]
        case 1:
            cell.textLabel?.text = shop[indexPath.row]
        case 2:
            cell.textLabel?.text = song[indexPath.row]
        case 3:
            cell.textLabel?.text = sound[indexPath.row]
        case 4:
            cell.textLabel?.text = none[indexPath.row]
        default:
            break
        }
        
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return ""
        case 1:
            return "商店"
        case 2:
            return "歌曲"
        case 3:
            return "鈴聲"
        case 4:
            return ""
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            selectedText = cell.textLabel!.text!
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        completionHandler?(selectedText)
    }
    

}
