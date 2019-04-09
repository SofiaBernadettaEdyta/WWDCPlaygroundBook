
//
//  EndPageViewController.swift
//  Book_Sources
//
//  Created by Zofia Drabek on 24/03/2019.
//


import UIKit
import PlaygroundSupport

public class EndPageViewController: UIViewController, PlaygroundLiveViewMessageHandler, PlaygroundLiveViewSafeAreaContainer {
    
    var endImageView: UIImageView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        endImageView = UIImageView(image: UIImage(named: "end"))
        endImageView.contentMode = .scaleAspectFit
        
        view.addSubview(endImageView)
        
    }
    
    public override func viewDidLayoutSubviews() {
        
        endImageView.frame = CGRect(x: CGFloat(10.0), y: CGFloat(10.0), width: self.view.frame.width - CGFloat(20.0), height: self.view.frame.height - CGFloat(20.0))
        
        
        let layer = CAGradientLayer()
        layer.frame = view.frame
        layer.colors = [ UIColor(red:0.96, green:0.60, blue:0.60, alpha:1.0).cgColor, UIColor.white.cgColor, UIColor(red:0.96, green:0.60, blue:0.60, alpha:1.0).cgColor]
        layer.colors = [ UIColor.white.cgColor, UIColor(red:0.96, green:0.60, blue:0.60, alpha:1.0).cgColor, UIColor.white.cgColor]
        view.layer.insertSublayer(layer, at: 0)
    }
    
}
