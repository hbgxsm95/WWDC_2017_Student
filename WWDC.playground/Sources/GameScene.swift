//
//  GameOverScene.swift
//  SpriteKitSimpleGame
//
//  Created by Main Account on 9/30/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit

class GameScene: SKScene {
    var Pipe_Group : [Pipe] = []
    let Apple = SKSpriteNode(imageNamed:"Apple_Cartoon_Sleep_1")
    var route : [Int] = []
    let Initial_x : Int = 200
    let Initial_y : Int = 150
    let label_1 = SKLabelNode(fontNamed: "Chalkduster")
    let label_2 = SKLabelNode(fontNamed: "Chalkduster")
    let label_3 = SKLabelNode(fontNamed: "Chalkduster")
    public override init(size: CGSize) {
        super.init(size: size)
        
    }
    
    // 6
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed:"Game_Background")
        background.anchorPoint = CGPoint.zero
        background.position = CGPoint(x:0,y:0)
        background.zPosition = -1
        addChild(background)
        
        label_1.text = "Click on the yellow pipe to complete the route"
        label_1.fontSize = 15
        label_1.fontColor = SKColor.white
        label_1.position = CGPoint(x:200,y:285)
        label_1.zPosition = 3
        addChild(label_1)
        
        label_2.text = "From Left to Right"
        label_2.fontSize = 15
        label_2.fontColor = SKColor.white
        label_2.position = CGPoint(x:200,y:270)
        label_2.zPosition = 3
        addChild(label_2)
        
        label_3.text = "Then click on the Apple"
        label_3.fontSize = 15
        label_3.fontColor = SKColor.white
        label_3.position = CGPoint(x:200,y:255)
        label_3.zPosition = 3
        addChild(label_3)
        Apple_Setup()
        Pipe_Setup()
    }
    
    func Apple_Setup(){
        Apple.anchorPoint = CGPoint(x:0.5,y:0.5)
        Apple.position = CGPoint(x:65,y:79)
        Apple.zPosition = 1
        Apple.name = "Apple"
        addChild(Apple)
        var sleep_texture: [SKTexture] = []
        for i in 1...3 {
            sleep_texture.append (SKTexture(imageNamed: "Apple_Cartoon_Sleep_"+"\(i)"))
        }
        for i in 1...3 {
            sleep_texture.append (SKTexture(imageNamed: "Apple_Cartoon_Sleep_"+"\(4-i)"))
        }
        let Point_Animation = SKAction.animate(with:sleep_texture,
                                               timePerFrame: 0.2)
        Apple.run(SKAction.repeatForever(Point_Animation))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            return
        }
        let viewlocation = touch.location(in: self.view)
        let touchlocation = convertPoint(fromView: viewlocation)
        var judge : Bool = true
        if let tap_object = atPoint(touchlocation) as? Pipe{
            
            if tap_object.tag == 15 || tap_object.tag == 16{
                judge = false
                print ("Error. Cannot rotate the first or last")
            }
            if judge == true{
                isUserInteractionEnabled = false
                let rotation = SKAction.rotate(byAngle: π/2, duration: 1)
                tap_object.run(rotation)
                if tap_object.Curved == true{
                    tap_object.Rotation_Condition = (tap_object.Rotation_Condition+1)%4
                    switch tap_object.Rotation_Condition{
                    case 0:
                        tap_object.tail = tap_object.position + CGPoint (x:0,y:18)
                        tap_object.head = tap_object.position + CGPoint (x:-18,y:0)
                    case 1:
                        
                        tap_object.tail = tap_object.position + CGPoint (x:-18,y:0)
                        tap_object.head = tap_object.position + CGPoint (x:0,y:-18)
                    case 2:
                        tap_object.tail = tap_object.position + CGPoint(x:18,y:0)
                        tap_object.head = tap_object.position + CGPoint(x:0,y:-18)
                    default:
                        tap_object.tail = tap_object.position + CGPoint(x:18,y:0)
                        tap_object.head = tap_object.position + CGPoint(x:0,y:18)
                        
                        
                    }
                    
                }
                else{
                    tap_object.Rotation_Condition = (tap_object.Rotation_Condition+1)%2
                    switch tap_object.Rotation_Condition{
                    case 0:
                        tap_object.tail = tap_object.position + CGPoint(x:-18,y:0)
                        tap_object.head = tap_object.position + CGPoint(x:18,y:0)
                    default:
                        tap_object.tail = tap_object.position + CGPoint(x:0,y:18)
                        tap_object.head = tap_object.position + CGPoint(x:0,y:-18)
                        
                        
                    }
                    
                }
                for i in tap_object.ConnectedPipe{
                    Pipe_Group[i].ConnectedPipe.remove(at:Pipe_Group[i].ConnectedPipe.index(of: tap_object.tag)!)
                }
                tap_object.ConnectedPipe.removeAll()
                for object in Pipe_Group{
                    if object.tag != tap_object.tag{
                        if (object.tail == tap_object.tail) || (object.head == tap_object.tail) || (object.tail == tap_object.head) || (object.head == tap_object.head){
                            tap_object.ConnectedPipe.append(object.tag)
                            object.ConnectedPipe.append(tap_object.tag)
                        }
                    }
                }
                isUserInteractionEnabled = true
            }
            
        }
        
        if let tap_object = atPoint(touchlocation) as? SKSpriteNode{
            var last : Int = -2
            var now : Int = 15
            var next: Int = 1
            if tap_object.name == "Apple"{
                route.removeAll()
                while true{
                    if Pipe_Group[now].ConnectedPipe.count > 1 || now == 15 {
                        for connect_tag in Pipe_Group[now].ConnectedPipe{
                            if connect_tag != last{
                                next = connect_tag
                                route.append(now)
                                break
                            }
                        }

                        last = now
                        now = next
                    }
                    else {
                        route.append(now)
                        break
                    }
                }
                if now == 16{
                    Apple.removeAllActions()
                    var movement : [SKAction] = []
                    var fly_moon : SKAction = SKAction.move(to: CGPoint(x:350,y:254), duration: 1)
                    for i in 0..<route.count{
                        movement.append(SKAction.move(to: Pipe_Group[route[i]].position+CGPoint(x:0,y:10), duration: 0.5))
                    }
                    Apple.run(SKAction.sequence(movement),
                              completion:{
                                self.label_1.removeFromParent()
                                self.label_2.removeFromParent()
                                self.label_3.removeFromParent()
                                self.Apple.run(fly_moon)
                                self.Pipe_Group[16].run(fly_moon)
                                let label_final = SKLabelNode(fontNamed: "Chalkduster")
                                label_final.text = "Apple Flew to the Moon!"
                                label_final.fontSize = 15
                                label_final.fontColor = SKColor.white
                                label_final.position = CGPoint(x:200,y:280)
                                label_final.zPosition = 3
                                self.addChild(label_final)
                                
                    })
                }
                else{
                    print ("failed")
                }
            }
        }
    }
    
    
    func Pipe_Setup(){
        for i in 0..<3{
            for j in 0..<5{
                let Position_Ref = Pipe_Center(x: i,y: j)
                if i == 1{
                    if j == 0 || j == 4 {
                        let pipe = Pipe(Type : true,Position: CGPoint(x:Initial_x,y:Initial_y)+Position_Ref)
                        pipe.tag = 5*i + j
                        Pipe_Group.append(pipe)
                        addChild(pipe)
                        continue
                    }
                    else {
                        let pipe = Pipe(Type : false,Position: CGPoint(x:Initial_x,y:Initial_y)+Position_Ref)
                        pipe.tag = 5*i + j
                        Pipe_Group.append(pipe)
                        addChild(pipe)
                        continue
                    }
                }
                if i == 2{
                    if j == 0 || j == 4{
                        let pipe = Pipe(Type : true,Position: CGPoint(x:Initial_x,y:Initial_y)+Position_Ref)
                        pipe.tag = 5*i + j
                        Pipe_Group.append(pipe)
                        addChild(pipe)
                        continue
                    }
                }
                if arc4random()%2 == 1 {
                    let pipe = Pipe(Type : true,Position: CGPoint(x:Initial_x,y:Initial_y)+Position_Ref)
                    pipe.tag = 5*i + j
                    Pipe_Group.append(pipe)
                    addChild(pipe)
                    
                }
                else {
                    let pipe = Pipe(Type : false,Position: CGPoint(x:Initial_x,y:Initial_y)+Position_Ref)
                    pipe.tag = 5*i + j
                    Pipe_Group.append(pipe)
                    addChild(pipe)
                }
            }
        }
        let pipe_first = Pipe(Type : false,Position: CGPoint(x:Initial_x,y:Initial_y)+CGPoint(x:-36,y:-72))
        pipe_first.tag = 15
        Pipe_Group.append(pipe_first)
        addChild(pipe_first)
        let pipe_last = Pipe(Type : false,Position: CGPoint(x:Initial_x,y:Initial_y)+CGPoint(x:5*36,y:-72))
        pipe_last.tag = 16
        Pipe_Group.append(pipe_last)
        addChild(pipe_last)
        for i in 0..<3{
            for j in 0..<5{
                if j != 4{
                    if (Pipe_Group[5*i+j].tail == Pipe_Group[5*i+j+1].tail) || (Pipe_Group[5*i+j].head == Pipe_Group[5*i+j+1].tail) || (Pipe_Group[5*i+j].tail == Pipe_Group[5*i+j+1].head) || (Pipe_Group[5*i+j].head == Pipe_Group[5*i+j+1].head){
                        Pipe_Group[5*i+j].ConnectedPipe.append(5*i+j+1)
                        Pipe_Group[5*i+j+1].ConnectedPipe.append(5*i+j)
                    }
                }
                if i != 2{
                    if (Pipe_Group[5*i+j].tail == Pipe_Group[5*i+j+5].tail) || (Pipe_Group[5*i+j].head == Pipe_Group[5*i+j+5].tail) || (Pipe_Group[5*i+j].tail == Pipe_Group[5*i+j+5].head) || (Pipe_Group[5*i+j].head == Pipe_Group[5*i+j+5].head){
                        Pipe_Group[5*i+j].ConnectedPipe.append(5*i+j+5)
                        Pipe_Group[5*i+j+5].ConnectedPipe.append(5*i+j)
                    }
                }
            }
        }
        if (Pipe_Group[15].tail == Pipe_Group[5*2+0].tail) || (Pipe_Group[15].head == Pipe_Group[5*2+0].tail) || (Pipe_Group[15].tail == Pipe_Group[5*2+0].head) || (Pipe_Group[15].head == Pipe_Group[5*2+0].head){
            Pipe_Group[15].ConnectedPipe.append(5*2+0)
            Pipe_Group[5*2+0].ConnectedPipe.append(15)
            print ("Got it!")
        }
        if (Pipe_Group[16].tail == Pipe_Group[5*2+4].tail) || (Pipe_Group[16].head == Pipe_Group[5*2+4].tail) || (Pipe_Group[16].tail == Pipe_Group[5*2+4].head) || (Pipe_Group[16].head == Pipe_Group[5*2+4].head){
            Pipe_Group[16].ConnectedPipe.append(5*2+4)
            Pipe_Group[5*2+4].ConnectedPipe.append(16)
        }
    }
    
    func Pipe_Center(x: Int,y:Int)->CGPoint{
        assert(0<=x && x<3 && 0<=y && y<5)
        return CGPoint(x:CGFloat(y)*36,y:-CGFloat(x)*36)
    }
    
    
    


}
