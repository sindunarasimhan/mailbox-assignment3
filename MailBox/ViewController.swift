//
//  ViewController.swift
//  MailBox
//
//  Created by Narasimhan, Sindhuja on 10/30/16.
//  Copyright © 2016 Narasimhan, Sindhuja. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    var leftScreenOffset: CGFloat!
    var messageScreenOffset: CGFloat!
    var dragOut: CGPoint!
    var dragIn: CGPoint!
    var frame: CGRect!
    var refreshImage:UIImageView!
    
    @IBOutlet weak var laterIcon: UIImageView!
    @IBOutlet weak var deleteIcon: UIImageView!
    @IBOutlet weak var archiveIcon: UIImageView!
    @IBOutlet weak var listicon: UIImageView!
    
    @IBOutlet weak var mainMessageView: UIView!
    @IBOutlet weak var messageContainer: UIView!
    
    var messageDragOut: CGPoint!
    var messageDragIn: CGPoint!
    var scrollViewOriginalCenter: CGPoint!
    var messageOriginalCenter: CGPoint!

    
    @IBOutlet var messagePanRecognizer: UIPanGestureRecognizer!
    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    

    @IBOutlet var mainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteIcon.alpha = 0
        archiveIcon.alpha = 0
        laterIcon.alpha = 0
        listicon.alpha = 0
        
        scrollViewOriginalCenter = scrollView.center
        messageOriginalCenter = messageContainer.center
        frame = CGRect(x: 0, y: 0, width: 375, height:667)
        refreshImage = UIImageView(frame: frame)
        

        leftScreenOffset = 350
        dragOut = scrollView.center
        dragIn = CGPoint(x: scrollView.center.x + leftScreenOffset ,y: scrollView.center.y)
        scrollView.contentSize = imageView.frame.size
        
        
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(sender:)))
        scrollView.isUserInteractionEnabled = true
        scrollView.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.delegate = self;
        
        messageScreenOffset = 400

        messageDragOut = messageContainer.center
        messageDragIn = CGPoint(x: messageContainer.center.x + messageScreenOffset ,y: messageContainer.center.y)
        
        let messagePanRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanMessage(sender:)))
        messageContainer.isUserInteractionEnabled = true
        messageContainer.addGestureRecognizer(messagePanRecognizer)
        messagePanRecognizer.delegate = self;
        panGestureRecognizer.require(toFail:messagePanRecognizer);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    

    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    func didPan(sender: UIPanGestureRecognizer) {
        //let location = sender.location(in: view)
        let velocity = sender.velocity(in: view)
        let translation = sender.translation(in: view)


        if sender.state == UIGestureRecognizerState.began {
            scrollViewOriginalCenter = scrollView.center
        }
        
        else if sender.state == UIGestureRecognizerState.changed {
            scrollView.center = CGPoint(x: scrollViewOriginalCenter.x+translation.x,y: scrollViewOriginalCenter.y)
        } else if sender.state == UIGestureRecognizerState.ended {
            if velocity.x > 0 {
                UIView.animate(withDuration: 0.5) {
                    self.scrollView.center = self.dragIn
                }
            } else {
                UIView.animate(withDuration: 0.5) {
                    self.scrollView.center = self.dragOut
                }
            }
        }
    }
    
    
    
    func didPanMessage(sender: UIPanGestureRecognizer) {
        //let location = sender.location(in: view)
        let velocity = sender.velocity(in: view)
        let translation = sender.translation(in: view)
        
        if sender.state == UIGestureRecognizerState.began {
            messageOriginalCenter = messageContainer.center
        }
            
        else if sender.state == UIGestureRecognizerState.changed {
            UIView.animate(withDuration:0.4, animations: {

                if(translation.x>=60) && (translation.x<240)
                {
                    self.mainMessageView.backgroundColor = UIColor.green
                    UIView.animate(withDuration:0.4, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                                   animations: { () -> Void in
                                    self.archiveIcon.alpha = 1
                                    self.deleteIcon.alpha = 0

                        }, completion: nil)
                }
                else if(translation.x>=240) && (translation.x<375) {
                    self.mainMessageView.backgroundColor = UIColor.red
                    self.archiveIcon.alpha = 0

                    UIView.animate(withDuration:0.4, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                                   animations: { () -> Void in
                                    self.deleteIcon.alpha = 1

                        }, completion: nil)
                }
                else if (translation.x>=375) {
                    self.mainMessageView.removeFromSuperview()
                    self.scrollView.layoutIfNeeded()
                    
                }
                
                else if (translation.x <= -60 && translation.x > -240) {
                    self.mainMessageView.backgroundColor = self.UIColorFromHex(rgbValue: 0xF5A623,alpha: 1)
                    self.listicon.alpha = 0

                    UIView.animate(withDuration:0.4, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                                   animations: { () -> Void in
                                    self.laterIcon.alpha = 1
                                    
                        }, completion: nil)

                }
                
                else if (translation.x <= -260) {
                    self.mainMessageView.backgroundColor = self.UIColorFromHex(rgbValue: 0xFAB13A,alpha: 1)
                    self.laterIcon.alpha = 0
                    UIView.animate(withDuration:0.4, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                                   animations: { () -> Void in
                                    self.listicon.alpha = 1

                                    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap(sender:)))
                                    tapRecognizer.numberOfTapsRequired = 1
                                    self.refreshImage.image = UIImage(named: "reschedule")
                                    self.refreshImage.isUserInteractionEnabled = true
                                    self.scrollView.addSubview(self.refreshImage)
                                    self.scrollView.insertSubview(self.refreshImage, at:5)
                                    self.refreshImage.addGestureRecognizer(tapRecognizer)
                                    tapRecognizer.delegate = self
                                                    



                        }, completion: nil)
                    
                }

            })
            
            

            
            messageContainer.center = CGPoint(x: messageOriginalCenter.x+translation.x,y: messageOriginalCenter.y)
            
        } else if sender.state == UIGestureRecognizerState.ended {
            self.mainMessageView.backgroundColor = UIColor.gray
            self.deleteIcon.alpha = 0
            self.archiveIcon.alpha = 0
            self.laterIcon.alpha = 0
            self.listicon.alpha = 0



            if velocity.x > 0 {
                UIView.animate(withDuration: 0.5) {
                    self.messageContainer.center = self.messageDragIn
                }
            } else {
                UIView.animate(withDuration: 0.5) {
                    self.messageContainer.center = self.messageDragOut
                }
            }
        }
    }
    
    func didTap(sender: UITapGestureRecognizer) {
        UIView.animate(withDuration:0.4, delay: 0.7, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                       animations: { () -> Void in
                        //sender.view?.removeFromSuperview()
                        sender.view?.alpha = 0

        },completion: nil)

    }

}

