//
//  ARSCNView+Extension.swift
//  AR_ series
//
//  Created by libo on 2017/11/13.
//  Copyright © 2017年 libo. All rights reserved.
//

import ARKit

extension ARSCNView {
     //获取三位坐标
    func worldVector(for position: CGPoint) -> SCNVector3? {
        let results = self.hitTest(position, types: [.featurePoint])
        
        guard let result = results.first else {
            return nil
        }
        
        return SCNVector3.positionTransform(result.worldTransform)
        
    }
}
