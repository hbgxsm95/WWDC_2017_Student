import UIKit
import SpriteKit

public class GameViewController: UIViewController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        let scene =
            Start_Scene(size:CGSize(width: 400, height: 300))
        let skView = SKView(frame : CGRect(x:0,y:0,width:400,height:300))
        skView.showsFPS = true
        //skView.showsPhysics = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        //scene.scaleMode = .aspectFill
        scene.physicsWorld.gravity = CGVector(dx:0,dy:-1)
        //scene.physicsBody = SKPhysicsBody(edgeLoopFrom: scene.frame)
        skView.presentScene(scene)
        view.addSubview(skView)
    }
    override public var prefersStatusBarHidden : Bool  {
        return true
    }
    
    public init(){
        super.init(nibName:nil,bundle:nil)
        preferredContentSize = CGSize(width:400,height:300)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
