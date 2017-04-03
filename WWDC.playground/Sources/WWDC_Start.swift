import SpriteKit
import GameplayKit

class WWDC_Start: GKState {
    
    unowned let scene: Start_Scene
    
    init(scene: SKScene) {
        self.scene = scene as! Start_Scene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        var point_texture: [SKTexture] = []
        for i in 1...28 {
            point_texture.append (SKTexture(imageNamed: "\(i).jpg"))
        }
        let Point_Animation = SKAction.animate(with:point_texture,
                                           timePerFrame: 0.1)
        scene.Apple.zPosition = 3
        let FadeIn = SKAction.fadeAlpha(to: 0.01, duration: 2)
        let Fadeout = SKAction.fadeAlpha(to:1, duration: 2)
        scene.Finger.run(Point_Animation,
                  completion:{
                    self.scene.Apple.run(Fadeout,
                                         completion:{
                                            self.scene.childNode(withName: "Apple")!.physicsBody?.isDynamic = true
                                            self.scene.childNode(withName: "Apple")!.physicsBody!.applyForce(
                                                CGVector(dx:-7,dy:0))
                                            self.scene.WWDC_State.enter(Fall_State)
                    })
                    self.scene.Apple_Ghost.run(FadeIn,
                                               completion:{
                                                self.scene.Apple_Ghost.removeFromParent()
                        
                                                
                    })
            })
                    
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        //self.scene.moveCamera()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is Fall_State.Type
    }
    override func willExit(to nextState: GKState) {
        scene.WWDC_2013_Setup()
    }
    
}
