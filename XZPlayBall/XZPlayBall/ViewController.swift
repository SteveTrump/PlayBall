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
    
    @IBOutlet weak var tipLabel: UILabel!
    
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
        
        paddleVelocityX = 0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func dragPaddle(_ sender: UIPanGestureRecognizer) {
    
        let state:UIGestureRecognizerState = sender.state
        
        switch state {
        case .changed:
            
                let location = sender.location(in: self.view)
                self.paddleImageView.center = CGPoint(x: location.x, y: self.paddleImageView.center.y)
                //挡板速度
                self.paddleVelocityX = sender.velocity(in: sender.view).x
            
            break
        case .ended:
            
            paddleVelocityX = 0
            break
        default:
            break
        }
    }
    //点击屏幕开始
    @IBAction func tapScreen(_ sender: UITapGestureRecognizer) {
        self.tipLabel.isHidden = true
        //小球和挡板回到初始位置
        self.ballImageView.center = ballOriginCenter!
        self.paddleImageView.center = paddleOriginCenter!
        
        //砖块再次显示
        for imageView in self.gameImageView.subviews {
            imageView.isHidden = false
        }
        self.tapGesture.isEnabled = true
        self.gameTimer = CADisplayLink(target: self, selector: #selector(step))
        self.gameTimer?.add(to: RunLoop.main, forMode: .defaultRunLoopMode)
    }

    
    //背景音效实现
    func loadBgMusic(fileName filename:String) -> AVAudioPlayer? {
        
        let url = Bundle.main.url(forResource: filename, withExtension: nil)
        
        let player = try! AVAudioPlayer(contentsOf: url!)
        player.prepareToPlay()
        
        return player
    }
    //其他音效的视线
    func loadOtherMusicWithFileName(fileName filename:String) -> AVAudioPlayer? {
        
        let url = Bundle.main.url(forResource: filename, withExtension: nil)
        let player = try! AVAudioPlayer(contentsOf: url!)
        player.prepareToPlay()
        
        return player
    }
    
    
    func step()  {
        //小球每次刷新会向上移动5个像素
        self.ballImageView.center = CGPoint(x: self.ballImageView.center.x+(ballVelocity?.x)!, y:self.ballImageView.center.y+(ballVelocity?.y)!)
        //小球与游戏视图碰撞检测
        self.intersectWithGameImageView()
        //小球与挡板碰撞检测
        self.intersectWithPaddle()
        //小球与砖块碰撞检测
        self.intersectWithBlocks()
        
    }
    
    
    // MARK - : 碰撞检测
    
    func intersectWithGameImageView() {
        
        //与游戏视图上方碰撞
        //在swift3.0中，oc语言的CGRectGetMinY 变成了 swift的 minY,通过一下方法调用
        if self.ballImageView.frame.minY<=0 {
            //oc中的ABS()求绝对值函数 变成swift中的abs()
            ballVelocity?.y = abs((ballVelocity?.y)!)
        }
        //左方
        if self.ballImageView.frame.minX<=0 {
            ballVelocity?.x = (-1)*(ballVelocity?.x)!
        }
        //右方
        if self.ballImageView.frame.minX >= self.gameImageView.bounds.size.width {
            ballVelocity?.x = (-1)*ballVelocity!.x
        }
        //下方
        if self.ballImageView.frame.minY >= self.view.bounds.size.height {
            
            self.tapGesture.isEnabled = true
            self.gameTimer?.invalidate()
            self.tipLabel.isHidden = false
            self.tipLabel.font = UIFont.systemFont(ofSize: 20.0)
            self.tipLabel.text = "你输了，点击屏幕开始新游戏"
        }
    
    }
    
    
    //小球与挡板视图碰撞检测
    func intersectWithPaddle() {
        if self.ballImageView.frame.intersects(self.paddleImageView.frame) {
            ballVelocity?.x = paddleVelocityX!/120
            ballVelocity?.y = ballVelocity!.y*(-1)
        }
        
    }
    //小球与砖块碰撞检测
    func intersectWithBlocks()  {
        
        self.imageViewYintersects(imgViews: self.purpleImageView)
        self.imageViewYintersects(imgViews: self.greenImageView)
        self.imageViewYintersects(imgViews: self.redImageView)
        self.imageViewYintersects(imgViews: self.roseImageView)
        self.imageViewYintersects(imgViews: self.orangeImageView)
        self.imageViewYintersects(imgViews: self.paleblueImageView)
        
        var win = true
        
        for imageView in self.gameImageView.subviews {
            if imageView.isHidden == false {
                win = false
            }
        }
        if win {
            
            self.tapGesture.isEnabled = true
            self.gameTimer?.invalidate()
            self.tipLabel.isHidden = false
            self.tipLabel.text  = "你赢了！"
        }
        
     
    }
    
    //小球与砖块的碰撞
    func imageViewYintersects(imgViews imageViews:[UIImageView]!)  {
        for imageView in imageViews {
            if imageView.frame.intersects(self.ballImageView.frame)&&imageView.isHidden==false {
                imageView.isHidden = true
                ballVelocity?.y = (-1)*ballVelocity!.y
            }
        }
    }
    
    
    
    
}

