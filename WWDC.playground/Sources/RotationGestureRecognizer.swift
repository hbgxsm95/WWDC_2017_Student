import UIKit
import UIKit.UIGestureRecognizerSubclass
import AVFoundation

class RotationGestureRecognizer: UIGestureRecognizer {
    private var Angle : [CGFloat] = []
    private var Last :CGFloat = 0
    public var ClockWise : Int = 0
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        for touch in touches {
            let start_point = touch.location(in:self.view)
            let endPoint = touch.previousLocation(in: self.view)
            let offset = start_point - endPoint
            //print ("start\(start_point)")
            //print ("end\(endPoint)")
            let direction = offset.normalized()
            //print ("\(direction.angle)")
            if direction.angle != 0 {
                if Last * direction.angle >= CGFloat(0){
                    Angle.append(direction.angle)
                    Last = direction.angle
                    //print ("debug1")
                }
                else{
                    //print ("debug2")
                    break
                }
                
            }
            else {
                //print ("debug3")
            }
            
        }
        if Angle.count >= 4{
            if Angle.first! - Angle.last! > CGFloat(0){
                ClockWise = 1
            }
            else{
                ClockWise = -1
            }
            self.state = UIGestureRecognizerState.began
        }
        //print ("\(Angle.count)")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        self.reset()
        Angle.removeAll()
        Last = 0
        ClockWise = 0
        self.state = UIGestureRecognizerState.ended
        //print ("Finish \(ClockWise)")

    }
}
