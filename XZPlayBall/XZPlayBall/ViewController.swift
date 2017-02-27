//
//  ViewController.swift
//  XZPlayBall
//
//  Created by xiyang on 2017/2/27.
//  Copyright © 2017年 xiyang. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var gameImageView: UIView!

    @IBOutlet weak var ballImageView: UIImageView!
    
    @IBOutlet weak var paddleImageView: UIImageView!
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    @IBOutlet var greenImageView: [UIImageView]!
    
    @IBOutlet var purpleImageView: [UIImageView]!
    
    @IBOutlet var roseImageView: [UIImageView]!
    
    @IBOutlet var paleblueImageView: [UIImageView]!
    
    @IBOutlet var orangeImageView: [UIImageView]!
    
    @IBOutlet var redImageView: [UIImageView]!
    
    //背景音乐
    var playerBgMusic:AVAudioPlayer?
    //播放其他音效
    var playerOtherMusic:AVAudioPlayer?
    //小球初始位置
    var ballOriginCenter:CGPoint?
    //挡板初始位置
    var paddleOriginCenter:CGPoint?
    //时间刷屏
    
    var gameTimer:CADisplayLink?
    //小球移动速度
    var ballVelocity:CGPoint?
    //挡板移动速度
    var paddleVelocityX:CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        playerBgMusic = self.loadBgMusic(fileName: "background3.mp3")
        playerBgMusic?.numberOfLoops = -1
        playerBgMusic?.volume = 0.5
        playerBgMusic?.play()
        
        ballOriginCenter = self.ballImageView.center
        paddleOriginCenter = self.paddleImageView.center
        
        ballVelocity = CGPoint(x: 0, y: -5)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func dragPaddle(_ sender: UIPanGestureRecognizer) {
        
        
    }

    //背景音效实现
    func loadBgMusic(fileName filename:String) -> AVAudioPlayer? {
        
        let url = Bundle.main.url(forResource: filename, withExtension: nil)
        
        let player = try! AVAudioPlayer(contentsOf: url!)
        player.prepareToPlay()
        
        return player
    }
    
    
    
    func step()  {
        self.ballImageView.center = CGPoint(x: self.ballImageView.center.x+(ballVelocity?.x)!, y:self.ballImageView.center.y+(ballVelocity?.y)!)
        
        
        
    }
    
    
    //MARK - : 碰撞检测
    
    func intersectWithGameImageView() {
        
        
        
//        if minY(self.ballImageView.frame)<=0 {
//            
//        }
    }
    
}

