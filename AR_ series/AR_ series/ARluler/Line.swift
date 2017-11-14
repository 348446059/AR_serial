//
//  Line.swift
//  AR_ series
//
//  Created by libo on 2017/11/13.
//  Copyright © 2017年 libo. All rights reserved.
//

import ARKit
enum LengthUnit {
    case meter, cenitMeter, inch
    
    var factor: Float{
        switch self {
        case .meter:
            return 1.0
        case .cenitMeter:
            return 100.0
        case .inch:
              return 39.3700787
            
        }
    }
    
    var name: String{
        switch self {
        case .meter:
            return "m"
        case .cenitMeter:
            return "cm"
        case .inch:
            return "inch"
        }
    }
}



class Line {
    
    var color = UIColor.orange
    var startNode: SCNNode
    var endNode:SCNNode
    var textNode:SCNNode
    var text:SCNText
    var lineNode:SCNNode?
    
    let sceneView :ARSCNView
    let startVector:SCNVector3
    let unit: LengthUnit
    
    init(sceneView:ARSCNView,startVector:SCNVector3,unit:LengthUnit) {
        self.sceneView = sceneView
        self.startVector = startVector
        self.unit = unit
        
        let dot = SCNSphere(radius: 0.5)
        dot.firstMaterial?.diffuse.contents = color
        //不会产生阴影
        dot.firstMaterial?.lightingModel = .constant
        dot.firstMaterial?.isDoubleSided = false
       
        //创建一个圆的两面光亮，正反兩面都拋光的球
        startNode = SCNNode(geometry: dot)
        startNode.scale = SCNVector3(1/500.0,1/500.0,1/500.0)
        
        
        startNode.position = startVector
        sceneView.scene.rootNode.addChildNode(startNode)
        
        endNode = SCNNode(geometry: dot)
        endNode.scale = SCNVector3(1/500.0,1/500.0,1/500.0)
        
        text = SCNText(string: "", extrusionDepth: 0.1)
        text.font = .systemFont(ofSize: 5)
        text.firstMaterial?.diffuse.contents = color
        text.firstMaterial?.lightingModel = .constant
        text.firstMaterial?.isDoubleSided = true
        text.alignmentMode = kCAAlignmentCenter
        text.truncationMode = kCATruncationMiddle
        
        //包装文字的节点
        let textWrapperNode = SCNNode(geometry: text)
        textWrapperNode.eulerAngles = SCNVector3Make(0, .pi, 0)
        textWrapperNode.scale = SCNVector3(1/500.0,1/500.0,1/500.0)
        
        textNode = SCNNode()
        textNode.addChildNode(textWrapperNode)
        
        //我们无法预计文字会出现在哪？所以我们可以给他设计约束，这样的约束把文字绑定在线的中间位置 SCNLookConstraint是一种约束，让它绑定着我们的目标 永远向着使用者
        
        let constraint = SCNLookAtConstraint(target: sceneView.pointOfView)
        
        textNode.constraints = [constraint]
        
        sceneView.scene.rootNode.addChildNode(textNode)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func update(to vector:SCNVector3)  {
        //把所有的线先给移除
        lineNode?.removeFromParentNode()
        
        lineNode = startVector.line(to: vector, color: color)
       
        sceneView.scene.rootNode.addChildNode(lineNode!)
        
        //更新文字
        text.string = distance(to: vector)
        
        //设置文字位置，(放在线的中间)
        textNode.position = SCNVector3((startVector.x + vector.x) / 2.0, (startVector.y + vector.y) / 2.0, (startVector.z + vector.z) / 2.0)
        
        //结束点的位置
        endNode.position = vector
        
        if endNode.parent == nil {
            sceneView.scene.rootNode.addChildNode(endNode)
        }
    }
    
    
    
    
    
    func distance(to vector:SCNVector3) -> String {
        return String(format: "%0.2f %@", startVector.distance(form: vector)*unit.factor,unit.name)
    }
    
    
    func remove()  {
        startNode.removeFromParentNode()
        endNode.removeFromParentNode()
        textNode.removeFromParentNode()
        lineNode?.removeFromParentNode()
    }
}



















