import Foundation
import SpriteKit

public class Pipe : SKSpriteNode{
    public var tail : CGPoint
    public var head : CGPoint
    public var tag : Int = 0
    public var Rotation_Condition : Int
    public var ConnectedPipe : [Int] = []
    public var Curved : Bool
    public init (Type: Bool, Position: CGPoint){
        tail = CGPoint.zero
        head = CGPoint.zero
        Rotation_Condition = 0
        if Type == true{
            self.Curved = Type
            let texture = SKTexture (imageNamed : "Curved")
            super.init(texture : texture, color:UIColor.clear,size: texture.size())
            self.name = "Pipe"
            self.position = Position
            
            self.anchorPoint = CGPoint(x:0.5, y:0.5)
            switch arc4random()%4 {
            case 0:
                self.zRotation = 0
                Rotation_Condition = 0
                tail = self.position + CGPoint (x:0,y:texture.size().height/2)
                head = self.position + CGPoint (x:-texture.size().width/2,y:0)
            case 1:
                self.zRotation = π/2
                Rotation_Condition = 1
                tail = self.position + CGPoint (x:-texture.size().height/2,y:0)
                head = self.position + CGPoint (x:0,y:-texture.size().width/2)
            case 2:
                Rotation_Condition = 2
                self.zRotation = π
                tail = self.position + CGPoint(x:texture.size().height/2,y:0)
                head = self.position + CGPoint(x:0,y:-texture.size().width/2)
            default:
                self.zRotation = π*3/2
                Rotation_Condition = 3
                tail = self.position + CGPoint(x:texture.size().height/2,y:0)
                head = self.position + CGPoint(x:0,y:texture.size().height/2)
            }
        }
        else {
            self.Curved = Type
            let texture = SKTexture(imageNamed:"Straight")
            super.init(texture : texture, color:UIColor.clear,size: texture.size())
            self.position = Position
            self.anchorPoint = CGPoint(x:0.5, y:0.5)
            
            switch arc4random()%2{
            case 1:
                self.zRotation = 0
                Rotation_Condition = 0
                tail = self.position + CGPoint(x:-texture.size().height/2,y:0)
                head = self.position + CGPoint(x:texture.size().height/2,y:0)
            default:
                self.zRotation = π/2
                Rotation_Condition = 1
                tail = self.position + CGPoint(x:0,y:texture.size().height/2)
                head = self.position + CGPoint(x:0,y:-texture.size().height/2)
            }
            if Position == CGPoint(x:200,y:150)+CGPoint(x:-36,y:-72) {
                self.zRotation = 0
                Rotation_Condition = 0
                tail = self.position + CGPoint(x:-texture.size().height/2,y:0)
                head = self.position + CGPoint(x:texture.size().height/2,y:0)
            }
            if Position == CGPoint(x:200,y:150)+CGPoint(x:5*36,y:-72){
                self.zRotation = 0
                Rotation_Condition = 0
                tail = self.position + CGPoint(x:-texture.size().height/2,y:0)
                head = self.position + CGPoint(x:texture.size().height/2,y:0)
            }
            
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

