import SpriteKit
import GameplayKit

class WWDC_15: GKState {
    
    unowned let scene: Start_Scene
    
    init(scene: SKScene) {
        self.scene = scene as! Start_Scene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        scene.enumerateChildNodes(withName: "SKSpriteNode") {
            (node, _) in
            if node.name == "WWDC_2014" || node.name == "Leaf"{
                node.removeFromParent()
            }
        }
        let rotation = SKAction.rotate(byAngle: 0.25*π, duration: 0.2)
        scene.WWDC_2015_Rect.run(rotation)
        let rotation_Gest = RotationGestureRecognizer(target: self.scene, action: #selector(self.scene.handleRotate))
        self.scene.view?.addGestureRecognizer(rotation_Gest)
        scene.Apple.physicsBody?.restitution = 0.8
        scene.Apple.physicsBody?.friction = 10.0
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is Fall_State.Type
    }
    override func update(deltaTime seconds: TimeInterval) {
        
        if self.scene.cameraNode.position.y > -748.5{
            self.scene.moveCamera()
        }
        else {
            self.scene.cameraNode.position.y = -750
        }
        if self.scene.Apple.position.y <= -830{
            
            scene.WWDC_State.enter(Fall_State.self)
        }
        else {
            //print ("\(self.scene.Apple.position.y)")
        }
    }
    override func willExit(to nextState: GKState) {
        scene.WWDC_2016_Setup()
    }
    
    
    
}
