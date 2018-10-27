//
//  Settings.swift
//  colorchange
//
//  Created by Manish Ghimire on 3/28/18.
//  Copyright © 2018 Manish Ghimire. All rights reserved.
//

import SpriteKit

enum PhysicsCatogeries {
    static let none: UInt32 = 0
    static let ballCategory: UInt32 = 0x1 //1
    static let switchCategory: UInt32 = 0x1 << 1 //10
    
}

enum ZPositons {
    static let level: CGFloat = 0
    static let ball: CGFloat = 1
    static let colorchange: CGFloat = 2
}
