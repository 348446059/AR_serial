//
//  RulerViewController.swift
//  AR_ series
//
//  Created by libo on 2017/11/13.
//  Copyright © 2017年 libo. All rights reserved.
//

import UIKit
import SceneKit
import ARKit



class RulerViewController: UIViewController {
    @IBOutlet  var sceneView: ARSCNView!
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var targetImageView: UIImageView!
   
    var session = ARSession()
    var configuration = ARWorldTrackingConfiguration()
    var isMeasuring = false
    
    var vectorZero = SCNVector3()
    var vectorStart = SCNVector3()
    var vectorEnd = SCNVector3()
    var lines = [Line]()
    var currentLine:Line?
    var unit = LengthUnit.cenitMeter
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.session = session
        infoLabel.text = "环境初始化中..."
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        session.run(configuration, options: [.resetTracking,.removeExistingAnchors])
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func resetAction(_ sender: Any) {
        for line in lines {
            line.remove()
        }
        lines.removeAll()
    }
    
    @IBAction func unitClick(_ sender: Any) {
    }
    
}

extension RulerViewController{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isMeasuring {
           reset()
            isMeasuring = true
            targetImageView.image = #imageLiteral(resourceName: "GreenTarget")
        }else{
            isMeasuring = false
            
            if let line = currentLine{
                lines.append(line)
                currentLine = nil
                targetImageView.image = #imageLiteral(resourceName: "WhiteTarget")
            }
        }
    }
    
    func reset()  {
        vectorStart = SCNVector3()
        vectorEnd = SCNVector3()
    }
    
    //开始测量
    func scanWorld()  {
        //拿取现在画面中的中心点位置
        guard let worldPosition = sceneView.worldVector(for: view.center) else {
            return
        }
        //如果画面上没有一条线
        if lines.isEmpty {
            if vectorStart == vectorZero{
                vectorStart = worldPosition
                currentLine = Line(sceneView: sceneView, startVector: vectorStart, unit: unit)
            }
            
            //设置结束节点
            vectorEnd = worldPosition
            currentLine?.update(to: vectorEnd)
            infoLabel.text = currentLine?.distance(to: vectorEnd) ?? "..."
        }
    }
}

extension RulerViewController:ARSCNViewDelegate{
    
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        DispatchQueue.main.async {
            self.scanWorld()
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        infoLabel.text = "错误"
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
         infoLabel.text = "中断～"
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        infoLabel.text = "结束"
    }
}





