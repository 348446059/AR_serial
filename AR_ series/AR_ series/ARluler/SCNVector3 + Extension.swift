//
//  SCNVector3 + Extension.swift
//  AR_ series
//
//  Created by libo on 2017/11/13.
//  Copyright © 2017年 libo. All rights reserved.
//

import ARKit
extension SCNVector3{
    //获取镜头的坐标
    static func positionTransform(_ transform:matrix_float4x4) ->SCNVector3{
        return SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
    }
    
    //算空间中两个点的距离
    func distance(form vector:SCNVector3) -> Float {
        let distanceX = self.x - vector.x
        let distanceY = self.y - vector.y
        let distanceZ = self.z - vector.z
        
        return sqrt((distanceX * distanceX) + (distanceY * distanceY) + (distanceZ * distanceZ))
    }
    
    //画线的方法
    func line(to vector:SCNVector3,color:UIColor) -> SCNNode {
        let indices:[UInt32] = [0,1] //指数
        
        //创建一个几何容器
        let source = SCNGeometrySource(vertices: [self,vector])
        
        //创建一个几何元素(一条线)
        let element = SCNGeometryElement(indices: indices, primitiveType:.line)
        
        //根据容器和元素创建一个几何体
        let geomtry = SCNGeometry(sources: [source], elements: [element])
        
        geomtry.firstMaterial?.diffuse.contents = color
        
        //根据几何体创建一个node节点
        return SCNNode(geometry: geomtry)
        
    }
}

extension SCNVector3: Equatable {
    public static func ==(lhs: SCNVector3, rhs: SCNVector3) -> Bool {
        return (lhs.x == rhs.x) && (lhs.y == rhs.y) && (lhs.z == rhs.z)
    }
}




















