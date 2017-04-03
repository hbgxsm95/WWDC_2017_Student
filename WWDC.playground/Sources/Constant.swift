import SpriteKit
struct PhysicsCategory {
    static let None: UInt32 = 0
    static let Apple: UInt32 = 0b1
    static let Main_Role : UInt32 = 0b10
    static let Leaf:  UInt32 = 0b100
    static let Barrier1 : UInt32 = 0b1000
    static let Barrier2 : UInt32 = 0b10000
    static let Barrier3: UInt32 = 0b100000
    static let Barrier4: UInt32 = 0b1000000
}

