import SpriteKit
import GameplayKit

class WWDC_17: GKState {
    
    unowned let scene: Start_Scene
    
    init(scene: SKScene) {
        self.scene = scene as! Start_Scene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        scene.enumerateChildNodes(withName: "SKSpriteNode") {
            (node, _) in
            if node.name == "WWDC_2016"{
                node.removeFromParent()
            }
        }
        scene.enumerateChildNodes(withName: "SKLabelNode") {
            (node, _) in
                node.removeFromParent()
        }
        //scene.WWDC_2016_Apple.physicsBody?.isDynamic = false
        //scene.WWDC_2016_Apple.physicsBody?.isDynamic = true
        //scene.physicsBody = SKPhysicsBody(edgeLoopFrom: scene.frame)
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true
    }
    override func update(deltaTime seconds: TimeInterval) {
        
        if self.scene.cameraNode.position.y > -1348.5{
            self.scene.moveCamera()
        }
        else {
            self.scene.cameraNode.position.y = -1350
        }
    }
    
    
    
}
