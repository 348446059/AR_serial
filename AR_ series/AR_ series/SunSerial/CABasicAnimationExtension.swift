//
//  CABasicAnimationExtension.swift
//  AR_ series
//
//  Created by libo on 2017/11/12.
//  Copyright © 2017年 libo. All rights reserved.
//

import UIKit
extension CABasicAnimation{
    convenience init(keyPath:String,fromValue:NSValue?,toValue:NSValue,duration:TimeInterval) {
        self.init()
        self.keyPath = keyPath
        self.toValue = toValue
        self.duration = duration
        self.repeatCount = .greatestFiniteMagnitude
        guard let fromValue = fromValue else {
            return;
        }
        self.fromValue = fromValue
        
    }
}
