import SpriteKit
import AVFoundation
import GameplayKit
class Start_Scene: SKScene, SKPhysicsContactDelegate {
    let Apple = SKSpriteNode(imageNamed: "Apple")
    let Apple_Ghost = SKSpriteNode(imageNamed: "Apple_Ghost")
    let Finger = SKSpriteNode(imageNamed: "1.jpg")
    let WWDC_2013_Up = SKSpriteNode(imageNamed : "2013_Up_1")
    let WWDC_2013_Down = SKSpriteNode(imageNamed : "2013_Down_1")
    let WWDC_2013_Middle = SKSpriteNode(imageNamed : "Apple")
    let WWDC_2014_Leaf = SKSpriteNode(imageNamed : "2014_leaf")
    let WWDC_2014_Left = SKSpriteNode(imageNamed : "2014_left")
    let WWDC_2014_Barrier = SKSpriteNode(imageNamed: "2014_Barrier")
    let WWDC_2014_Right = SKSpriteNode(imageNamed: "2014_right")
    let WWDC_2014_Middle = SKSpriteNode(imageNamed: "2014_middle")
    let WWDC_2015_Main = SKSpriteNode(imageNamed: "2015_main")
    let WWDC_2015_Rect = SKSpriteNode(imageNamed: "2015_rectangle")
    let WWDC_2016_Left = SKSpriteNode(imageNamed: "2016_left")
    let WWDC_2016_Right = SKSpriteNode(imageNamed: "2016_right")
    let WWDC_2016_Apple = SKSpriteNode(imageNamed: "2016_Apple")
    let WWDC_2017_Park = SKSpriteNode(imageNamed: "Apple_Park")
    let Crack_right = SKSpriteNode(imageNamed: "Crack_5")
    let Crack_left = SKSpriteNode(imageNamed: "Crack_1")
    
    var netRotation: CGFloat = 1
    var Press_Time : Double = 0
    

    
    
    let cameraNode = SKCameraNode()
    var right = true
    let cameraMoveSpeed : CGPoint = CGPoint(x:0,y:90)
    var time : TimeInterval = 0
    var LastUpdate : TimeInterval = 0
    
    lazy var WWDC_State: GKStateMachine = GKStateMachine(states: [
        Fall_State(scene:self),
        WWDC_Start(scene: self),
        WWDC_13(scene: self),
        WWDC_14_1(scene: self),
        WWDC_14_2(scene: self),
        WWDC_15(scene:self),
        WWDC_16(scene:self),
        WWDC_17(scene:self)
        ])

    override public init(size: CGSize){
        super.init(size:size)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func backgroundNode() -> SKSpriteNode{
        let backgroundNode = SKSpriteNode()
        var backgroundNodeGroup : [SKSpriteNode] = []
        for i in 0...4 {
            backgroundNodeGroup.append(SKSpriteNode(imageNamed: "Background_\(i+2013)"))
            backgroundNodeGroup[i].anchorPoint = CGPoint.zero
            backgroundNodeGroup[i].position = CGPoint(x:0,y:CGFloat(-i-1)*backgroundNodeGroup[i].size.height)
            backgroundNode.addChild(backgroundNodeGroup[i])
        }
        backgroundNode.size = CGSize(width:backgroundNodeGroup[0].size.width, height: CGFloat(5)*backgroundNodeGroup[0].size.height)
        
        return backgroundNode
    }
    
    fileprivate func setupPhysics(){
        physicsWorld.contactDelegate = self
    }
    override func didMove(to view: SKView) {
        WWDC_Start_Setup()
        setupPhysics()
        apple_setup()
        camera = cameraNode
        cameraNode.position = CGPoint(x:size.width/2,y:size.height/2)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        addChild(cameraNode)
    }
    
    
    
    @objc func handleTap(sender : UITapGestureRecognizer){
        let viewlocation = sender.location(in: self.view)
        let touchlocation = convertPoint(fromView: viewlocation)
        if let tap_object = atPoint(touchlocation) as? SKSpriteNode{
            if tap_object.name == "Apple"{
                WWDC_State.enter(WWDC_Start.self)
                view?.removeGestureRecognizer(sender)
            }
        }
        
        
    }
    
    @objc func handleRotate(sender:RotationGestureRecognizer){
        if sender.state == UIGestureRecognizerState.began{
            if sender.ClockWise == 1{
                let rotation = SKAction.rotate(byAngle: 0.75*π+2*π, duration: 2.5)
                WWDC_2015_Main.run(rotation)
                WWDC_2015_Rect.run(rotation)
            }
            else {
                let rotation = SKAction.rotate(byAngle: -0.25*π-3*π, duration: 3)
                WWDC_2015_Main.run(rotation)
                WWDC_2015_Rect.run(rotation)
                
            }
        }
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer){
        if Apple.physicsBody?.isDynamic == false {
            var Up_texture: [SKTexture] = []
            var Down_texture: [SKTexture] = []
            var Apple_texture: [SKTexture] = []
            for i in 1...7 {
                Up_texture.append (SKTexture(imageNamed: "2013_Up_\(i)"))
                Down_texture.append (SKTexture(imageNamed: "2013_Down_\(i)"))
            }
            Apple_texture.append(SKTexture(imageNamed: "Apple"))
            for i in 1...4{
                Apple_texture.append(SKTexture(imageNamed: "Apple_Final_\(i)"))
            }
            let Up_Fan_Animation = SKAction.animate(with:Up_texture,
                                                    timePerFrame: 0.1)
            //let Up_Fan_Animation_Group = SKAction.sequence([Up_Fan_Animation,Up_Fan_Animation.reversed()])
            let Down_Fan_Animation = SKAction.animate(with:Down_texture,
                                                      timePerFrame:0.1)
            
            let Apple_Flip = SKAction.animate(with: Apple_texture, timePerFrame: 0.132)
            let Apple_Rotation = SKAction.rotate(byAngle: -Apple.zRotation, duration: 0.04)
            //let Down_Fan_Animation_Group = SKAction.sequence([Down_Fan_Animation, Down_Fan_Animation.reversed()])
            WWDC_2013_Up.run(Up_Fan_Animation,
                                   completion:{
                                    self.WWDC_2013_Up.run(Up_Fan_Animation.reversed())
                                    
                }
            )
            WWDC_2013_Down.run(Down_Fan_Animation,
                                     completion:{
                                        self.WWDC_2013_Down.run(Down_Fan_Animation.reversed())
            })
            Apple.run(Apple_Rotation,
                            completion:{
                                //let rotation = SKAction.rotate(byAngle: π, duration: 0.001)
                                //self.Apple.zRotation = π - self.Apple.zRotation
                                self.Apple.run(Apple_Flip,
                                                     completion:{
                                                        self.Apple.position.y = -234 - self.Apple.position.y
                                                        self.Apple.zRotation = -π
                                                        self.Apple.run(Apple_Flip.reversed(),
                                                                             completion:{
                                                                                self.Apple.physicsBody?.isDynamic = true
                                                                           self.WWDC_2013_Middle.removeFromParent()
                                                                           self.WWDC_State.enter(Fall_State.self)
                                                        })
                                                        
                                })
            })
            view?.removeGestureRecognizer(sender)
        }
        else{
            print ("Error")}
    }
    
    @objc func handleTap_Twice(sender: UITapGestureRecognizer){
        let viewlocation = sender.location(in: self.view)
        let touchlocation = convertPoint(fromView: viewlocation)
        if let tap_object = atPoint(touchlocation) as? SKSpriteNode{
            if tap_object.name == "Leaf"{
                let rotation = SKAction.rotate(byAngle: π/6, duration: 0.5)
                WWDC_2014_Leaf.run(rotation,
                                   completion:{
                                    self.WWDC_2014_Leaf.physicsBody?.affectedByGravity = true
                })
            }
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if LastUpdate > 0 {
            time = currentTime - LastUpdate
        } else {
            time = 0
        }
        LastUpdate = currentTime
        //if isPaused { return }
        WWDC_State.update(deltaTime: time)
        //moveCamera()
    }
    

    func WWDC_Start_Setup(){
        Finger.position = CGPoint(x:0,y:0)
        Finger.anchorPoint = CGPoint(x:0,y:0)
        Finger.name = "WWDC_Start"
        addChild(Finger)
        Apple_Ghost.position = CGPoint(x:286,y:220)
        Apple_Ghost.anchorPoint = CGPoint(x:0.5,y:0.5)
        Apple_Ghost.zPosition = 1
        Apple_Ghost.name = "Apple"
        addChild(Apple_Ghost)
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "Click on the Apple"
        label.fontSize = 20
        label.fontColor = SKColor.black
        label.position = CGPoint(x:200,y:280)
        label.zPosition = 3
        addChild(label)

    }
    func WWDC_2013_Setup(){
        let Background = SKSpriteNode(imageNamed: "Background_\(2013)")
        Background.anchorPoint = CGPoint.zero
        Background.position = CGPoint(x:0,y:CGFloat(-1)*Background.size.height)
        Background.name = "WWDC_2013"
        addChild(Background)
        
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "Swipe Up or Down"
        label.fontSize = 20
        label.fontColor = SKColor.black
        label.position = CGPoint(x:200,y:-20)
        label.zPosition = 3
        addChild(label)
        
        WWDC_2013_Up.position = CGPoint(x:0,y:-300)
        WWDC_2013_Up.anchorPoint = CGPoint(x:0,y:0)
        WWDC_2013_Up.zPosition = 1
        WWDC_2013_Up.name = "WWDC_2013"
        WWDC_2013_Down.position = CGPoint(x:0,y:-300)
        WWDC_2013_Down.anchorPoint = CGPoint(x:0,y:0)
        WWDC_2013_Down.zPosition = 1
        WWDC_2013_Down.name = "WWDC_2013"
        WWDC_2013_Middle.position = CGPoint(x:size.width/2,y:-128)
        WWDC_2013_Middle.anchorPoint = CGPoint(x:0,y:0)
        WWDC_2013_Middle.zPosition = -4
        WWDC_2013_Middle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width:235,height:20))
        WWDC_2013_Middle.physicsBody?.categoryBitMask = PhysicsCategory.Barrier1
        WWDC_2013_Middle.physicsBody?.isDynamic = true
        WWDC_2013_Middle.physicsBody?.affectedByGravity = false
        WWDC_2013_Middle.physicsBody?.allowsRotation = false
        WWDC_2013_Middle.physicsBody?.mass = 1000
        WWDC_2013_Middle.physicsBody?.friction = 0.1
        //WWDC_2013_Middle.name = "WWDC_2013"
        addChild(WWDC_2013_Up)
        addChild(WWDC_2013_Down)
        addChild(WWDC_2013_Middle)
    }
    
    func WWDC_2014_Setup(){
        let Background = SKSpriteNode(imageNamed: "Background_\(2014)")
        Background.anchorPoint = CGPoint.zero
        Background.position = CGPoint(x:0,y:CGFloat(-2)*Background.size.height)
        Background.name = "WWDC_2014"
        addChild(Background)
        WWDC_2014_Leaf.position = CGPoint(x:200,y:-450)
        WWDC_2014_Leaf.anchorPoint = CGPoint(x:0.5,y:0.5)
        WWDC_2014_Leaf.zPosition = 3
        WWDC_2014_Leaf.physicsBody = SKPhysicsBody(texture: WWDC_2014_Leaf.texture!,size:WWDC_2014_Leaf.size)
        WWDC_2014_Leaf.physicsBody?.categoryBitMask = PhysicsCategory.Leaf
        WWDC_2014_Leaf.physicsBody?.isDynamic = true
        WWDC_2014_Leaf.physicsBody?.affectedByGravity = false
        WWDC_2014_Leaf.physicsBody?.mass = 1000
        WWDC_2014_Leaf.physicsBody?.friction = 0
        WWDC_2014_Leaf.name = "Leaf"
        
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "Double Click on the Apple Leaf"
        label.fontSize = 15
        label.fontColor = SKColor.black
        label.position = CGPoint(x:200,y:-320)
        label.zPosition = 3
        addChild(label)
        
        WWDC_2014_Barrier.position = CGPoint(x:200,y:-450)
        WWDC_2014_Barrier.anchorPoint = CGPoint(x:0.5,y:0.5)
        WWDC_2014_Barrier.zPosition = -4
        WWDC_2014_Barrier.physicsBody = SKPhysicsBody(texture: WWDC_2014_Barrier.texture!,size:WWDC_2014_Barrier.size)
        WWDC_2014_Barrier.physicsBody?.categoryBitMask = PhysicsCategory.Barrier2
        WWDC_2014_Barrier.physicsBody?.collisionBitMask = PhysicsCategory.Leaf
        WWDC_2014_Barrier.physicsBody?.contactTestBitMask = PhysicsCategory.Leaf
        WWDC_2014_Barrier.physicsBody?.isDynamic = true
        WWDC_2014_Barrier.physicsBody?.affectedByGravity = false
        WWDC_2014_Barrier.physicsBody?.mass = 1000000
        Crack_right.anchorPoint = CGPoint(x:0,y:0)
        Crack_right.position = CGPoint(x:0,y:-600)
        Crack_right.zPosition = 1
        Crack_right.name = "WWDC_2014"
        Crack_left.position = CGPoint(x:0,y:-600)
        Crack_left.anchorPoint = CGPoint(x:0,y:0)
        Crack_left.zPosition = 1
        Crack_left.name = "WWDC_2014"
        addChild(Crack_left)
        addChild(Crack_right)
        
        WWDC_2014_Right.position = CGPoint(x:0,y:-600)
        WWDC_2014_Right.anchorPoint = CGPoint(x:0,y:0)
        WWDC_2014_Right.zPosition = 2
        WWDC_2014_Right.name = "WWDC_2014"
        WWDC_2014_Middle.position = CGPoint(x:0,y:-600)
        WWDC_2014_Middle.anchorPoint = CGPoint(x:0,y:0)
        WWDC_2014_Middle.zPosition = 1
        WWDC_2014_Middle.name = "WWDC_2014"
        WWDC_2014_Left.position = CGPoint(x:0,y:-600)
        WWDC_2014_Left.anchorPoint = CGPoint(x:0,y:0)
        WWDC_2014_Left.zPosition = 2
        WWDC_2014_Left.name = "WWDC_2014"
        
        addChild(WWDC_2014_Barrier)
        addChild(WWDC_2014_Leaf)
        addChild(WWDC_2014_Right)
        addChild(WWDC_2014_Left)
        addChild(WWDC_2014_Middle)
    }
    
    func WWDC_2015_Setup(){
        let Background = SKSpriteNode(imageNamed: "Background_\(2015)")
        Background.anchorPoint = CGPoint.zero
        Background.position = CGPoint(x:0,y:CGFloat(-3)*Background.size.height)
        Background.name = "WWDC_2015"
        addChild(Background)
        
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "Hold on the mouse and draw a clock-wise or counterclock-wise arc"
        label.fontSize = 10
        label.fontColor = SKColor.black
        label.position = CGPoint(x:200,y:-620)
        label.zPosition = 3
        addChild(label)
        
        WWDC_2015_Main.position = CGPoint(x:200,y:-750)
        WWDC_2015_Main.anchorPoint = CGPoint(x:0.5,y:0.5)
        WWDC_2015_Main.zPosition = 1
        WWDC_2015_Main.name = "WWDC_2015"
        WWDC_2015_Rect.position = CGPoint(x:200,y:-750)
        WWDC_2015_Rect.anchorPoint = CGPoint(x:0.5,y:0.5)
        WWDC_2015_Rect.zPosition = 0
        WWDC_2015_Rect.physicsBody = SKPhysicsBody(texture: WWDC_2015_Rect.texture!,size:WWDC_2015_Rect.size)
        WWDC_2015_Rect.physicsBody?.categoryBitMask = PhysicsCategory.Barrier3
        WWDC_2015_Rect.physicsBody?.isDynamic = false
        WWDC_2015_Rect.physicsBody?.affectedByGravity = false
        WWDC_2015_Rect.zRotation = -0.75*π
        WWDC_2015_Rect.name = "WWDC_2015"
        //WWDC_2015_Rect.zRotation = 0
        addChild(WWDC_2015_Main)
        addChild(WWDC_2015_Rect)
    }
    
    func WWDC_2016_Setup(){
        let Background = SKSpriteNode(imageNamed: "Background_\(2016)")
        Background.anchorPoint = CGPoint.zero
        Background.position = CGPoint(x:0,y:CGFloat(-4)*Background.size.height)
        Background.name = "WWDC_2016"
        addChild(Background)
        
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "Long Press the Apple for 3 secs"
        label.fontSize = 20
        label.fontColor = SKColor.white
        label.position = CGPoint(x:200,y:-920)
        label.zPosition = 3
        addChild(label)
        
        WWDC_2016_Left.position = CGPoint(x:200,y:-1050)
        WWDC_2016_Left.anchorPoint = CGPoint(x:0.5,y:0.5)
        WWDC_2016_Left.zPosition = 1
        WWDC_2016_Left.physicsBody = SKPhysicsBody(texture: WWDC_2016_Left.texture!,size:WWDC_2015_Rect.size)
        WWDC_2016_Left.physicsBody?.categoryBitMask = PhysicsCategory.Barrier4
        WWDC_2016_Left.physicsBody?.isDynamic = false
        WWDC_2016_Left.physicsBody?.affectedByGravity = false
        WWDC_2016_Left.name = "WWDC_2016"
        
        WWDC_2016_Right.position = CGPoint(x:200,y:-1050)
        WWDC_2016_Right.anchorPoint = CGPoint(x:0.5,y:0.5)
        WWDC_2016_Right.zPosition = 1
        WWDC_2016_Right.physicsBody = SKPhysicsBody(texture: WWDC_2016_Right.texture!,size:WWDC_2015_Rect.size)
        WWDC_2016_Right.physicsBody?.categoryBitMask = PhysicsCategory.Barrier4
        WWDC_2016_Right.physicsBody?.isDynamic = false
        WWDC_2016_Right.physicsBody?.affectedByGravity = false
        WWDC_2016_Right.name = "WWDC_2016"
        
        WWDC_2016_Apple.position = CGPoint(x:200,y:-1024)
        WWDC_2016_Apple.anchorPoint = CGPoint(x:0.5,y:0.5)
        WWDC_2016_Apple.zPosition = 1
        WWDC_2016_Apple.physicsBody = SKPhysicsBody(texture: WWDC_2016_Apple.texture!,size:WWDC_2016_Apple.size)
        WWDC_2016_Apple.physicsBody?.isDynamic = false
        WWDC_2016_Apple.physicsBody?.categoryBitMask = PhysicsCategory.Main_Role
        WWDC_2016_Apple.physicsBody?.contactTestBitMask = PhysicsCategory.Barrier4
        WWDC_2016_Apple.physicsBody?.collisionBitMask = PhysicsCategory.None
        WWDC_2016_Apple.name = "Apple"
        addChild(WWDC_2016_Left)
        addChild(WWDC_2016_Right)
        addChild(WWDC_2016_Apple)
    }
    
    func WWDC_2017_Setup(){
        let Background = SKSpriteNode(imageNamed: "Background_\(2017)")
        Background.anchorPoint = CGPoint.zero
        Background.position = CGPoint(x:0,y:CGFloat(-5)*Background.size.height)
        Background.name = "WWDC_2017"
        addChild(Background)
        WWDC_2017_Park.position = CGPoint(x:200,y:-1350)
        WWDC_2017_Park.anchorPoint = CGPoint(x:0.5,y:0.5)
        WWDC_2017_Park.zPosition = 2
        WWDC_2017_Park.physicsBody = SKPhysicsBody(texture: WWDC_2017_Park.texture!,size:WWDC_2017_Park.size)
        WWDC_2017_Park.physicsBody?.isDynamic = false
        WWDC_2017_Park.physicsBody?.categoryBitMask = PhysicsCategory.Barrier4
        WWDC_2017_Park.name = "WWDC_2017"
        addChild(WWDC_2017_Park)
    }
    
    func apple_setup(){
        
        Apple.position = CGPoint(x:286,y:220)
        Apple.anchorPoint = CGPoint(x:0.5,y:0.5)
        Apple.zPosition = -1
        Apple.alpha = 0.01
        Apple.physicsBody = SKPhysicsBody(circleOfRadius: Apple.size.height/4)
        Apple.physicsBody?.categoryBitMask = PhysicsCategory.Apple
        Apple.physicsBody?.collisionBitMask = PhysicsCategory.Barrier1|PhysicsCategory.Leaf|PhysicsCategory.Barrier2|PhysicsCategory.Barrier3|PhysicsCategory.Barrier4
        Apple.physicsBody?.contactTestBitMask = PhysicsCategory.Barrier1|PhysicsCategory.Leaf|PhysicsCategory.Barrier2|PhysicsCategory.Barrier3|PhysicsCategory.Barrier4
        Apple.physicsBody?.isDynamic = false
        Apple.name = "Apple"
        addChild(Apple)
        
    }
    
    
    func didEnd(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if (firstBody.categoryBitMask & PhysicsCategory.Main_Role != 0){
            if (secondBody.categoryBitMask & PhysicsCategory.Barrier4 != 0){
                let Apple_Cartoon = SKSpriteNode(imageNamed: "Apple_Cartoon_Fall")
                Apple_Cartoon.position = WWDC_2016_Apple.position + CGPoint(x:0,y:0)
                Apple_Cartoon.anchorPoint = WWDC_2016_Apple.anchorPoint
                Apple_Cartoon.zPosition = 3
                Apple_Cartoon.name = "WWDC_2017"
                addChild(Apple_Cartoon)
                WWDC_2016_Apple.removeFromParent()
                let movement = SKAction.moveBy(x: 0, y: -30, duration: 2)
                let wait = SKAction.wait(forDuration: 1)
                Apple_Cartoon.run(movement,
                                  completion:{
                                    Apple_Cartoon.run(SKAction.sequence([SKAction.animate(with: [SKTexture(imageNamed:"Apple_Cartoon")], timePerFrame: 0.001),wait]),
                                                      completion:{
                                                        let reveal = SKTransition.flipHorizontal(withDuration: 1)
                                                        let gameOverScene = GameScene(size: self.size)
                                                        self.view?.presentScene(gameOverScene, transition: reveal)
                                    })
                    })
                
            }
        }

    }
    func didBegin(_ contact: SKPhysicsContact) {
        
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        switch WWDC_State.currentState{
        case is Fall_State:
            if (firstBody.categoryBitMask & PhysicsCategory.Apple != 0) {
                if (secondBody.categoryBitMask & PhysicsCategory.Barrier1 != 0){
                    self.WWDC_State.enter(WWDC_13.self)
                    print ("WWDC_13_State")
                }
                else if secondBody.categoryBitMask & PhysicsCategory.Barrier2 != 0{
                    self.WWDC_State.enter(WWDC_14_1.self)
                    print ("WWDC_14_State")
                    
                }
                else if secondBody.categoryBitMask & PhysicsCategory.Barrier3 != 0{
                    self.WWDC_State.enter(WWDC_15.self)
                    print ("WWDC_15_State")
                }
                else if secondBody.categoryBitMask & PhysicsCategory.Barrier4 != 0{
                    self.WWDC_State.enter(WWDC_16.self)
                    print ("WWDC_16_State")
                }
            }
            if (firstBody.categoryBitMask & PhysicsCategory.Main_Role != 0){
                if (secondBody.categoryBitMask & PhysicsCategory.Barrier4 != 0){
                    self.WWDC_State.enter(WWDC_17.self)
                    print ("WWDC_17_State")
                }
            }
        case is WWDC_14_1:
            if (firstBody.categoryBitMask & PhysicsCategory.Leaf != 0)&&(secondBody.categoryBitMask & PhysicsCategory.Barrier2 != 0) {
                self.WWDC_State.enter(WWDC_14_2.self)
            }
            if (firstBody.categoryBitMask & PhysicsCategory.Apple != 0)&&(secondBody.categoryBitMask & PhysicsCategory.Leaf != 0){
                if WWDC_2014_Leaf.physicsBody?.affectedByGravity == true{
                    WWDC_State.enter(WWDC_14_2.self)
                }
            }
        default:
            break
        }
    }


    
    func moveCamera(){
        let CameraMoveDis = cameraMoveSpeed * CGFloat(time)
        cameraNode.position = cameraNode.position - CameraMoveDis
    }
    
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            return
        }
        switch WWDC_State.currentState {
        case is WWDC_16:
            let viewlocation = touch.location(in: self.view)
            let touchlocation = convertPoint(fromView: viewlocation)
            //print ("\(viewlocation)")
            //print ("\(touchlocation)")
            if let tap_object = atPoint(touchlocation) as? SKSpriteNode{
                if tap_object.name == "Apple"{
                    print ("Got")
                    Press_Time = CACurrentMediaTime()
                    let rotation = SKAction.rotate(byAngle: π/2, duration: 2)
                    let movement = SKAction.moveBy(x: 11, y: 0, duration: 0.7)
                    WWDC_2016_Left.run(rotation,
                                       completion:{
                                        self.WWDC_2016_Left.run(movement,
                                                                completion:{
                                                                    self.WWDC_2016_Apple.physicsBody?.isDynamic = true
                                                                    
                                                                    self.WWDC_State.enter(Fall_State.self)
                                        })
                                        
                    })
                    WWDC_2016_Right.run(rotation.reversed(),
                                        completion:{
                                            self.WWDC_2016_Right.run(movement.reversed())
                    })
                }
            }
            
            
        case is WWDC_17:
            physicsWorld.gravity = CGVector(dx:0,dy:-0.1)
            WWDC_2016_Apple.physicsBody?.isDynamic = true
        default:
            break
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch WWDC_State.currentState{
        case is WWDC_16:
            var Press = CACurrentMediaTime() - Press_Time
            if (Press - 2 < 0.001 ){
                isUserInteractionEnabled = false
                WWDC_2016_Left.removeAllActions()
                WWDC_2016_Right.removeAllActions()
                let rotation = SKAction.rotate(byAngle: -CGFloat(Press)*π/4,duration:Press)
                WWDC_2016_Left.run(rotation,
                                   completion:{
                                    self.WWDC_2016_Left.zRotation = 0
                                    self.isUserInteractionEnabled = true
                })
                WWDC_2016_Right.run(rotation.reversed(),
                                    completion:{
                                    self.WWDC_2016_Right.zRotation = 0
                })
                
            }
        default:
            break
        
        }
    }
    

    
}
