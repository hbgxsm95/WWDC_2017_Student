import SpriteKit
import GameplayKit

class Fall_State: GKState {
    
    unowned let scene: Start_Scene
    
    init(scene: SKScene) {
        self.scene = scene as! Start_Scene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        for recognizer in (self.scene.view?.gestureRecognizers)!{
            self.scene.view?.removeGestureRecognizer(recognizer)
            
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        //return stateClass is WWDC_14.Type
        return true
    }
    override func update(deltaTime seconds: TimeInterval) {
            self.scene.moveCamera()
        //print ("\(self.scene.Apple.zRotation)")
    }
    
}
