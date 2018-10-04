//
//  ViewController.swift
//  floorAR
//
//  Created by Deekshith Maram on 10/3/18.
//  Copyright © 2018 Deekshith Maram. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController,ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        let scene = SCNScene()
        sceneView.scene = scene
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func createFloorNode(anchor:ARPlaneAnchor) -> SCNNode{
        let floorNode = SCNNode(geometry: SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z)))
        floorNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
       //floorNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        floorNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "logo-2")
       // floorNode.geometry?.firstMaterial?.specular.contents = UIColor.blue
        floorNode.geometry?.firstMaterial?.isDoubleSided = true
      //  floorNode.eulerAngles = SCNVector3(Double.pi/2,0,0)
         
        return floorNode
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        configuration.planeDetection = .horizontal
    }

    override func viewWillDisappear(_ animated: Bool) {
        sceneView.session.pause()
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let floorAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        let planeNode = createFloorNode(anchor: floorAnchor)
        node.addChildNode(planeNode)
    }
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let floorAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        
        node.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        
        let planeNode = createFloorNode(anchor: floorAnchor)
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
       guard  let _ = anchor as? ARPlaneAnchor else{
            return
        }
        
        node.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
    }
    


}

