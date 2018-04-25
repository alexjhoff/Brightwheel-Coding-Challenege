//
//  RepoViewController.swift
//  BrightwheelCodeChallenge
//
//  Created by Alex Hoff on 4/23/18.
//  Copyright © 2018 Alex Hoff. All rights reserved.
//

import UIKit

class RepoViewController: UIViewController {

    var viewModel: RepoViewModel!
    let shapeLayer = CAShapeLayer()
    let label = UILabel()
    var timer = Timer()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        setUpTableView()
        setUpNavBar()
        setUpLoadingAnimation()
    }
    
    fileprivate func setUpView() {
        // Set up gradient layer
//        let gradient = CAGradientLayer()
//        let frame = self.view.frame
//        gradient.frame = frame
//        gradient.colors = [UIColor.gradientPink.cgColor, UIColor.gradientPurple.cgColor]
//
//        self.view.layer.insertSublayer(gradient, at: 0)
        view.backgroundColor = UIColor.Theme.viewBackground
        tableView.isHidden = true
    }
    
    fileprivate func setUpTableView() {
        viewModel.delegate = self
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
        tableView.backgroundColor = .clear
        tableView.register(RepoTableViewCell.nib, forCellReuseIdentifier: RepoTableViewCell.identifier)
        
        viewModel.getRepos {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.shapeLayer.removeFromSuperlayer()
                self.label.removeFromSuperview()
                self.tableView.isHidden = false
            }
        }
    }
    
    fileprivate func setUpNavBar() {
        navigationController?.navigationBar.topItem?.title = "Top 100 Github Repos"
        navigationController?.navigationBar.barTintColor = UIColor.Theme.navBarColor
        navigationController?.hidesBarsOnSwipe = true
    }
    
    fileprivate func setUpLoadingAnimation() {
        let center = view.center
        
        // Create circular loading layer
        let circularPath = UIBezierPath(arcCenter: center, radius: 80, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.Theme.infoColor.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.Theme.viewBackground.cgColor
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.strokeEnd = 0
        
        view.layer.addSublayer(shapeLayer)
        
        // Create loading label
        label.frame = CGRect(x: 0, y: 0, width: 90, height: 40)
        label.text = "Loading"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.center = center
        
        view.addSubview(label)
        
        // Begin animations
        animateCircle()
    }
    
    // MARK:- Loading Animations
    fileprivate func animateCircle() {
        // Create loading animation
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        
        // Animate once before timer
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
        animateLabel()
        
        // Repeat animation until table is loaded
        timer = Timer.scheduledTimer(withTimeInterval: 1.65, repeats: true, block: { (timer) in
            self.shapeLayer.add(basicAnimation, forKey: "basicAnimation")
            
            self.animateLabel()
        })
    }
    
    fileprivate func animateLabel() {
        UIView.transition(with: label, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.label.text = "Loading"
        }) { (_) in
            UIView.transition(with: self.label, duration: 0.4, options: .transitionCrossDissolve, animations: {
                self.label.text = "Loading."
            }) { (_) in
                UIView.transition(with: self.label, duration: 0.4, options: .transitionCrossDissolve, animations: {
                    self.label.text = "Loading.."
                }) { (_) in
                    UIView.transition(with: self.label, duration: 0.4, options: .curveLinear, animations: {
                        self.label.text = "Loading..."
                    })
                }
            }
        }
    }
}

extension RepoViewController: RepoViewModifier {
    func navBarIsHidden(_ cond: Bool) {
        UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.navigationController?.setNavigationBarHidden(cond, animated: true)
        }, completion: nil)
    }
}
