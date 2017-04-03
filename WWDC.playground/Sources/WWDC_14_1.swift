import SpriteKit
import GameplayKit

class WWDC_14_1: GKState {
    
    unowned let scene: Start_Scene
    
    init(scene: SKScene) {
        self.scene = scene as! Start_Scene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        scene.enumerateChildNodes(withName: "SKSpriteNode") {
            (node, _) in
            if node.name == "WWDC_2013"{
                node.removeFromParent()
            }
        }
        let Tap_Twice = UITapGestureRecognizer(target: self.scene, action: #selector(self.scene.handleTap_Twice))
        Tap_Twice.numberOfTapsRequired = 2
        self.scene.view?.addGestureRecognizer(Tap_Twice)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is WWDC_14_2.Type
    }
    override func update(deltaTime seconds: TimeInterval) {
        
        if self.scene.cameraNode.position.y > -448.5{
            self.scene.moveCamera()
        }
        else {
            self.scene.cameraNode.position.y = -450
        }
        if scene.Apple.position.x < 90{
           
            self.scene.Apple.physicsBody?.applyForce(CGVector(dx:5,dy:0.5))
        }
        else {
            //print ("\(scene.Apple.position.x)")
            if scene.Apple.position.x > 310{
            self.scene.Apple.physicsBody?.applyForce(CGVector(dx:-5,dy:0.5))}
        }
    }
    
}
