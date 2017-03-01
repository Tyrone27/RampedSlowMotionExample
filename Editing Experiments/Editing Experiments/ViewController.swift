//
//  ViewController.swift
//  Editing Experiments
//
//  Created by Pineapple on 27/01/17.
//  Copyright © 2017 Pineapple. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    
    var assetConfig  = AssetConfig()
    var player :  AVPlayer?
    // var playerItem : AVPlayerItem?
    
    
   
    @IBAction func saveVid(_ sender: UIButton) {
        
        assetConfig.createFileFromAsset(assetConfig.asset!)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playAsset()
    }
    
    func playAsset(){
        
        
        assetConfig.configureAssets()
        let snapshot : AVComposition =   assetConfig.asset  as! AVComposition
        let playerItem =                AVPlayerItem(asset : snapshot)
        player =                    AVPlayer(playerItem: playerItem)
        let playerLayer =               AVPlayerLayer(player: player)
        playerLayer.frame =             CGRect(x : 0, y : 0, width : self.view.frame.width , height : self.view.frame.height)
        
        self.view.layer.addSublayer(playerLayer)
        player?.play()
        
    }
    
    
    
}

