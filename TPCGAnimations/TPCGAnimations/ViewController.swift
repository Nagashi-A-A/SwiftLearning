//
//  ViewController.swift
//  Project15
//
//  Created by Anton Yaroshchuk on 28.06.2021.
//

import UIKit

class ViewController: UIViewController {
    var imageView: UIImageView!
    var currentAnimation = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let testRect = view.layer.bounds
        
        imageView = UIImageView(image: UIImage(named: "penguin"))
        imageView.center = CGPoint(x: testRect.width/2, y: testRect.height/2)
        
        view.addSubview(imageView)
        // Do any additional setup after loading the view.
    }

    @IBAction func tapped(_ sender: UIButton) {
        sender.isHidden = true
        
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            switch self.currentAnimation {
            case 0:
                self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
                
            case 1:
                self.imageView.transform = .identity
                
            case 2:
                self.imageView.transform = CGAffineTransform(translationX: -200, y: -200)
                
            case 3:
                self.imageView.transform = .identity
                
            case 4:
                self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
                
            case 5:
                self.imageView.transform = .identity
                
            case 6:
                self.imageView.alpha = 0.01
                self.view.layer.backgroundColor = CGColor(gray: 0, alpha: 1)
                
            case 7:
                self.imageView.alpha = 1
                self.view.layer.backgroundColor = CGColor(gray: 1, alpha: 1)
                
            default:
                break
             
            }
        }) { finished in
            sender.isHidden = false
        }

        
        
        currentAnimation += 1
        
        if currentAnimation > 7 {
            currentAnimation = 0
        }
    }
    
}

