//
//  ViewController.swift
//  EmojiXmas
//
//  Created by LBrito on 12/3/18.
//  Copyright © 2018 L.Brito. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "mainscn.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    //Get position of touch and generate a vector3 to be pass to createEmoji
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        let result = sceneView.hitTest(touch.location(in: sceneView), types: [ARHitTestResult.ResultType.featurePoint])
        guard let hitResult = result.last else {return}
        let hitTransform = hitResult.worldTransform
        let hitVector = SCNVector3Make(hitTransform[3][0], hitTransform[3][1], hitTransform[3][2])
        creatEmoji(position: hitVector)

    }
    func creatEmoji(position: SCNVector3) {
        let boxShape = SCNPlane(width: 0.1, height: 0.1)
        //the emoji images that used are named between 0.. 14
        let boxImage = "\(Int.random(in: 0 ... 14)).png"
        boxShape.firstMaterial?.diffuse.contents = UIImage(named: boxImage)
        let boxNode = SCNNode(geometry: boxShape)
        boxNode.position = position
        sceneView.scene.rootNode.addChildNode(boxNode)
    }
}
