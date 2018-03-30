import SpriteKit
import GameplayKit

class WWDC_14_2: GKState {
    
    unowned let scene: Start_Scene
    var judge = false
    
    init(scene: SKScene) {
        self.scene = scene as! Start_Scene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        scene.WWDC_2014_Leaf.physicsBody?.isDynamic = false
        scene.WWDC_2014_Leaf.run(SKAction.moveBy(x: 0, y: 40, duration: 1))
        print ("success")
        scene.Crack_left.zPosition = 3
        var Crack_texture: [SKTexture] = []
        for i in 2...5{
            Crack_texture.append(SKTexture(imageNamed: "Crack_\(i)"))
        }
        scene.Crack_left.run(SKAction.animate(with:Crack_texture,
                                        timePerFrame: 0.1),
                       completion:{
                        //self.addChild(self.Crack_right)
                        self.scene.Crack_right.zPosition = 3
                        self.scene.Crack_left.run(SKAction.moveBy(x: -20, y: 0, duration: 0.5))
                        self.scene.WWDC_2014_Left.run(SKAction.moveBy(x: -20, y: 0, duration: 0.5))
                        self.scene.WWDC_2014_Right.run(SKAction.moveBy(x: 20, y: 0, duration: 0.5))
                        self.scene.Crack_right.run(SKAction.moveBy(x: 20, y: 0, duration: 0.5),
                                             completion:{
                                                self.scene.WWDC_2014_Barrier.physicsBody?.friction=0
                                                self.scene.Apple.physicsBody?.applyForce(CGVector(dx:5,dy:0))
                                                print ("Pushed!")
                                                self.judge = true
                                                
                        })
        })
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is Fall_State.Type
    }
    override func update(deltaTime seconds: TimeInterval) {
        if scene.Apple.position.x < 90{
            print ("Far2")
            self.scene.Apple.physicsBody?.applyForce(CGVector(dx:10,dy:0))
        }
        else if ((abs(scene.Apple.position.x - 200) < 1) && judge){
            self.scene.Apple.physicsBody?.isDynamic = false
            self.scene.WWDC_2014_Barrier.removeFromParent()
            self.scene.Apple.physicsBody?.isDynamic = true
            self.scene.WWDC_State.enter(Fall_State.self)
            judge = false
        }
    }
    
    override func willExit(to nextState: GKState) {
        scene.WWDC_2015_Setup()
    }
    
}
