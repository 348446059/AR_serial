//
//  DoorViewController.swift
//  AR_ series
//
//  Created by libo on 2017/11/15.
//  Copyright © 2017年 libo. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
class DoorViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        //明确表示需要追踪个水平面。设置后，scene被检测到时就会调用 ARSCNViewDelegate代理方法
       
        configuration.planeDetection = .horizontal
        configuration.worldAlignment = .gravityAndHeading
        // Run the view's session
        sceneView.session.run(configuration)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
 
    
 override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //       是否第一次点击(第一次接触)
        if let touch = touches.first {
            //            在2D屏幕上点击的位置
            let touchLocation = touch.location(in: sceneView)
            //     在2D屏幕是上点击的位置转换成3D的位置
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            // existingPlaneUsingExtent: 表示只在检测到的屏幕上起作用
            //     点击结果是否是他的第一次
            if let hitResult = results.first {
                
                
                let boxScene = SCNScene(named: "art.scnassets/portal.scn")!
                
                if let boxNode = boxScene.rootNode.childNode(withName: "portal", recursively: true) {
                    
                    
                    boxNode.position = SCNVector3(x: hitResult.worldTransform.columns.3.x, y: hitResult.worldTransform.columns.3.y - 0.05, z: hitResult.worldTransform.columns.3.z)
                    
                    sceneView.scene.rootNode.addChildNode(boxNode)
                }
            }
        }
    }


}


extension DoorViewController: ARSCNViewDelegate{
    
    
    //    检测平面
    //    当ARSession检测到了平面调用此方法
   func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        //        锚点⚓️ ＶＳ 节点
        if anchor is ARPlaneAnchor {
            //           锚点可以是任意形态的 如果我们检测的是平面，那么这个锚点就是平面
            let planeAnchor = anchor as! ARPlaneAnchor
            
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            //            extent: 检测平面的宽和高
            //            锚点的大小 ＝ 检测到的水平面大小
            let planeNode = SCNNode() //创建一个节点
            //            设置节点的位置，即锚点的中心位置
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
            //X 轴旋转90度
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage.init(named: "art.scnassets/grid.png")
            plane.materials = [gridMaterial]
            planeNode.geometry = plane // 因為我不知道 會偵測到怎麼樣的水平面
            node.addChildNode(planeNode)
     }
    }
}
