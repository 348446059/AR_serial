//
//  SCenViewController.swift
//  AR_ series
//
//  Created by libo on 2017/11/12.
//  Copyright © 2017年 libo. All rights reserved.
//

import UIKit
import ARKit
import SceneKit


class SCenViewController: UIViewController {

    /* AR 前置作业*/
    lazy var arSCNView = ARSCNView(frame: view.bounds)
    lazy var arSession = ARSession()
    //创建追踪
    lazy var arSessionConfiguation = ARWorldTrackingConfiguration()
    
    /* 地球 月亮 太阳 */
    var sunNode = SCNNode(geometry: SCNSphere(radius: 3))
    var moonNode = SCNNode(geometry: SCNSphere(radius: 0.5))
    var earthNode = SCNNode(geometry: SCNSphere(radius: 1))
    
    //地月节点
    var earthGroupNode = SCNNode()
    //围绕太阳公转节点
    var sunHaloNode = SCNNode()
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(arSCNView)
        arSCNView.delegate = self
        initNode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //设置自适应灯光 画面比较柔和
        arSessionConfiguation.isLightEstimationEnabled = true
        arSCNView.session.run(arSessionConfiguation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SCenViewController{
    func initNode()  {
        arSCNView.session = arSession
        arSCNView.automaticallyUpdatesLighting = true
        
        //渲染上图  multiply: 镶嵌，把整张图拉伸，之后变淡
        sunNode.geometry?.firstMaterial?.multiply.contents = "art.scnassets/earth/sun.jpg"
        
        earthNode.geometry?.firstMaterial?.multiply.contents = "art.scnassets/earth/earth-diffuse-mini.jpg"
        //地球的夜光图
        earthNode.geometry?.firstMaterial?.emission.contents = "art.scnassets/earth/earth-emissive-mini.jpg"
        
        earthNode.geometry?.firstMaterial?.specular.contents = "art.scnassets/earth/earth-specular-mini.jpg"
        
        //月球 diffuse:扩散 平均扩散到整个物件表面 并且光滑透亮
        moonNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth/moon.jpg"
        sunNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth/sun.jpg"
        
        sunNode.geometry?.firstMaterial?.multiply.intensity = 0.5
        sunNode.geometry?.firstMaterial?.lightingModel = .constant
        
        //    wrapS 左->右
        //    wrapT 上->下
        sunNode.geometry?.firstMaterial?.multiply.wrapS = .repeat
        sunNode.geometry?.firstMaterial?.diffuse.wrapS = .repeat
        sunNode.geometry?.firstMaterial?.multiply.wrapT = .repeat
        sunNode.geometry?.firstMaterial?.diffuse.wrapT = .repeat
        sunNode.geometry?.firstMaterial?.locksAmbientWithDiffuse = true
       
        //太阳照到地球上的光泽 反光度 地球的反光度
        earthNode.geometry?.firstMaterial?.shininess = 0.1 //光泽
        earthNode.geometry?.firstMaterial?.specular.intensity = 0.5 //反射多少光出去
        moonNode.geometry?.firstMaterial?.specular.contents = UIColor.gray
        
        //设置位置
         sunNode.position = SCNVector3Make(0, 5, -20)
        earthNode.position = SCNVector3Make(3, 0, 0)
        moonNode.position = SCNVector3Make(3, 0, 0)
        
        
        earthGroupNode.addChildNode(earthNode)
        earthGroupNode.position = SCNVector3Make(10, 0, 0)
       
       arSCNView.scene.rootNode.addChildNode(sunNode)
       
       
        
        //太阳自转动画
        addAnimationToSun()
        roationNode()
        addLight()
    }
    
    func roationNode()  {

    earthNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 1))) //地球自转
        
        let moonRotationNode = SCNNode()
        moonRotationNode.addChildNode(moonNode)
        
        
        // 月球自传
        let toValue = NSValue.init(scnVector4: SCNVector4Make(0, 1, 0, .pi * 2))
        let animation = CABasicAnimation(keyPath: "rotation", fromValue: nil, toValue: toValue, duration: 1.5)
        moonNode.addAnimation(animation, forKey: "moon rotation")
      
        //月球绕地球地球公转
        let moonRotationAnimation = CABasicAnimation(keyPath: "rotation", fromValue: nil, toValue: NSValue.init(scnVector4: SCNVector4Make(0, 1, 0, .pi * 2)), duration: 5.0)
        
        moonRotationNode.addAnimation(moonRotationAnimation, forKey: "moon rotation around earth")
        
        earthGroupNode.addChildNode(moonRotationNode)
        
        //地球绕着太阳转
        let earthRotationNode = SCNNode()
        sunNode.addChildNode(earthRotationNode)
        earthRotationNode.addChildNode(earthGroupNode)
 
        
        
        
        let animation1 = CABasicAnimation(keyPath: "rotation", fromValue: nil, toValue:  NSValue.init(scnVector4: SCNVector4Make(0, 1, 0, .pi * 2)), duration: 10.0)
        earthRotationNode.addAnimation(animation1, forKey: "earth rotation around sun")
       
        //地球运行轨道
        let earthOrbit = SCNNode()
        
        earthOrbit.opacity = 0.4
        earthOrbit.geometry = SCNBox.init(width: 0.82, height: 0, length: 0.82, chamferRadius: 0)
        earthOrbit.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth/orbit.png"
        
        earthOrbit.geometry?.firstMaterial?.diffuse.mipFilter = .linear
        
        earthOrbit.rotation = SCNVector4Make(0, 1, 0, .pi / 2)
        earthOrbit.geometry?.firstMaterial?.lightingModel = .constant
       arSCNView.scene.rootNode.addChildNode(earthOrbit)
        
        
    }
    
    func addLight()  {
       let  lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.color = UIColor.red
        
        sunNode.addChildNode(lightNode)
        
        lightNode.light?.attenuationEndDistance = 20.0
        lightNode.light?.attenuationStartDistance = 1.0
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1.0
        
            lightNode.light?.color = UIColor.white
            sunHaloNode.opacity = 0.5
        
        SCNTransaction.commit()
        
        sunHaloNode = SCNNode()
        sunHaloNode.geometry = SCNPlane(width: 25, height: 25)
        sunHaloNode.rotation = SCNVector4Make(1, 0, 0, 0 * .pi / 180.0)
        sunHaloNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth/sun-halo.png"
        sunHaloNode.geometry?.firstMaterial?.lightingModel = .constant // no lighting
        sunHaloNode.geometry?.firstMaterial?.writesToDepthBuffer = false // do not write to depth
        sunHaloNode.opacity = 0.9
        sunNode.addChildNode(sunHaloNode)
    }
    
    
    
    
   
}

//MARK:转动动画
extension SCenViewController{
    //太阳自转
    func addAnimationToSun()  {
        let animation = CABasicAnimation(keyPath: "contentsTransform")
        animation.duration = 10.0
        
        let fromValue = NSValue.init(caTransform3D: CATransform3DConcat(CATransform3DMakeTranslation(0, 0, 0), CATransform3DMakeScale(3, 3, 3)))
        
        let toValue = NSValue.init(caTransform3D: CATransform3DConcat(CATransform3DMakeTranslation(1, 0, 0), CATransform3DMakeScale(5, 5, 5)))
        
        animation.fromValue = fromValue
        animation.toValue = toValue
        
        
        animation.repeatCount = .greatestFiniteMagnitude
        
        sunNode.geometry?.firstMaterial?.diffuse.addAnimation(animation, forKey: "sun-texture")
        
        
    }
}

extension SCenViewController: ARSCNViewDelegate{
    
}
























