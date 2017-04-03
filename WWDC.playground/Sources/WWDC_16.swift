import SpriteKit
import GameplayKit

class WWDC_16: GKState {
    
    unowned let scene: Start_Scene
    
    init(scene: SKScene) {
        self.scene = scene as! Start_Scene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        scene.enumerateChildNodes(withName: "SKSpriteNode") {
            (node, _) in
            if node.name == "WWDC_2015"{
                node.removeFromParent()
            }
        }
        scene.Apple.physicsBody?.restitution = 0.2
        let wait = SKAction.wait(forDuration: 2)
        let FadeIn = SKAction.fadeAlpha(to:0, duration: 0.5)
        let Fly = SKAction.move(to: CGPoint(x:200,y:-1025) , duration:0.4 )
        scene.Apple.run(wait,
                        completion:{
                            self.scene.Apple.physicsBody?.isDynamic = false
                            print ("\(self.scene.Apple.zRotation)")
                            let rotation = SKAction.rotate(byAngle: -self.scene.Apple.zRotation, duration: 0.2)
                            self.scene.Apple.run(rotation)
                            self.scene.Apple.run(Fly)
                            self.scene.Apple.run(FadeIn,
                                                 completion:{
                                                    self.scene.Apple.removeFromParent()
                            })
                            
                            
            })
                
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is Fall_State.Type
    }
    override func update(deltaTime seconds: TimeInterval) {
        
        if self.scene.cameraNode.position.y > -1048.5{
            self.scene.moveCamera()
        }
        else {
            self.scene.cameraNode.position.y = -1050
        }
    }
    override func willExit(to nextState: GKState) {
        scene.WWDC_2017_Setup()
    }
    
    
    
}
