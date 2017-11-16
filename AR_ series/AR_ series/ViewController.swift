//
//  ViewController.swift
//  AR_ series
//
//  Created by libo on 2017/11/12.
//  Copyright © 2017年 libo. All rights reserved.
//

import UIKit
let cellIdentifier = "cellIdentifier"

class ViewController: UIViewController {

    var data = ["太阳系","测距(尺子)","任意门"]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    
}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.textLabel?.text = data[indexPath.row]
        
        cell.imageView?.image = UIImage(named: "art.scnassets/grid.png")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let sunVC = SCenViewController()
            present(sunVC, animated: true, completion: nil)
            
        }else if(indexPath.row == 1){
            let rulerVC = RulerViewController()
            present(rulerVC, animated: true, completion: nil)
            
        }else if(indexPath.row == 2){
            let roomVC = DoorViewController()
            present(roomVC, animated: true, completion: nil)

        
            
        }
    }
    
    
}

