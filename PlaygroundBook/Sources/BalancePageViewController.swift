//
//  BalerinaPageViewController.swift
//  Book_Sources
//
//  Created by Zofia Drabek on 21/03/2019.
//

import UIKit
import PlaygroundSupport

public class BalancePageViewController: UIViewController, PlaygroundLiveViewMessageHandler, PlaygroundLiveViewSafeAreaContainer {
    
    var leverView: UIImageView!
    var balanceDancersView: UIImageView!
    var stackView: UIStackView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        leverView = UIImageView(image: UIImage(named: "leverBalance"))
        balanceDancersView = UIImageView(image: UIImage(named: "balanceDancers"))
        stackView = UIStackView()
        stackView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.alignment = .center
        
        stackView.contentMode = .center
        leverView.contentMode = .scaleAspectFit
        balanceDancersView.contentMode = .scaleAspectFit
        
        view.addSubview(stackView)
        
    }
    
    public override func viewDidLayoutSubviews() {
        
        stackView.frame = CGRect(x: CGFloat(10.0), y: CGFloat(10.0), width: self.view.frame.width - CGFloat(20.0), height: self.view.frame.height - CGFloat(20.0))
        
        if self.view.frame.width < self.view.frame.height {
            stackView.axis = .vertical
        } else {
            stackView.axis = .horizontal
        }
        
        let layer = CAGradientLayer()
        layer.frame = view.frame
        layer.colors = [ UIColor(red:0.96, green:0.60, blue:0.60, alpha:1.0).cgColor, UIColor.white.cgColor, UIColor(red:0.96, green:0.60, blue:0.60, alpha:1.0).cgColor]
        layer.colors = [ UIColor.white.cgColor, UIColor(red:0.96, green:0.60, blue:0.60, alpha:1.0).cgColor, UIColor.white.cgColor]
        view.layer.insertSublayer(layer, at: 0)
        stackView.addArrangedSubview(balanceDancersView)
        stackView.addArrangedSubview(leverView)
        
    }
    
}
