//
//  GameViewController.swift
//  colorchange
//
//  Created by Manish Ghimire on 3/28/18.
//  Copyright © 2018 Manish Ghimire. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
         if let view = self.view as! SKView? {
            let scene = MenuScene(size: view.bounds.size)
            //scaling to the full screen
            scene.scaleMode = .aspectFill
            
            //preset the scene
                view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }

    
}
