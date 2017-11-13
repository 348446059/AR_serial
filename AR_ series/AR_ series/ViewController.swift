//
//  ViewController.swift
//  AR_ series
//
//  Created by libo on 2017/11/12.
//  Copyright © 2017年 libo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func demoOne(_ sender: Any) {
        
        let sunVC = SCenViewController()
        present(sunVC, animated: true, completion: nil)
        
    }
    
}

