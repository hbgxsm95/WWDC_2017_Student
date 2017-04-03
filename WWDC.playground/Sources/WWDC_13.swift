import SpriteKit
import GameplayKit

class WWDC_13: GKState {
    
    unowned let scene: Start_Scene
    
    init(scene: SKScene) {
        self.scene = scene as! Start_Scene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        //self.scene.Apple.physicsBody?.isDynamic = false
        scene.enumerateChildNodes(withName: "SKSpriteNode") {
            (node, _) in
            if node.name == "WWDC_Start" {
                node.removeFromParent()
            }
        }
        //scene.Apple_Ghost.removeFromParent()
        
        scene.run(SKAction.wait(forDuration:0.8),
                  completion:{
                    self.scene.Apple.physicsBody?.isDynamic = false
                    //print ("\(self.scene.Apple.zRotation)")
                    let Swipe_Up = UISwipeGestureRecognizer(target: self.scene, action: #selector(self.scene.handleSwipe))
                    Swipe_Up.direction = UISwipeGestureRecognizerDirection.up
                    let Swipe_Down = UISwipeGestureRecognizer(target: self.scene, action: #selector(self.scene.handleSwipe))
                    Swipe_Down.direction = UISwipeGestureRecognizerDirection.down
                    self.scene.view?.addGestureRecognizer(Swipe_Up)
                    self.scene.view?.addGestureRecognizer(Swipe_Down)
        })
    }
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is Fall_State.Type
    }
    override func update(deltaTime seconds: TimeInterval) {
        
        if self.scene.cameraNode.position.y > -148.5{
            self.scene.moveCamera()
        }
        else {
            self.scene.cameraNode.position.y = -150
        }
    }
    override func willExit(to nextState: GKState) {
        scene.WWDC_2014_Setup()
    }
    
}
