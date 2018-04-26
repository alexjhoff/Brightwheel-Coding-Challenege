//
//  RepoViewController.swift
//  BrightwheelCodeChallenge
//
//  Created by Alex Hoff on 4/23/18.
//  Copyright © 2018 Alex Hoff. All rights reserved.
//

import UIKit

class RepoViewController: UIViewController {

    // View model
    var viewModel: RepoViewModel!
    
    // Loading animation variables
    private let shapeLayer = CAShapeLayer()
    private let label = UILabel()
    private var timer = Timer()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // View set up methods
        setUpView()
        setUpTableView()
        setUpNavBar()
        setUpLoadingAnimation()
    }
    
    // MARK:- View set up
    // Modifies all view related objects
    fileprivate func setUpView() {
        // Set up gradient layer
        let gradient = CAGradientLayer()
        let frame = self.view.frame
        gradient.frame = frame
        gradient.colors = [UIColor.Theme.viewBackground.cgColor,
                           UIColor.Theme.titleColor.cgColor]

        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    // Set up table view dependencies and hide it until the repos are fetched
    fileprivate func setUpTableView() {
        // Assign the tableview as the responder to the view models delegate protocol call
        viewModel.delegate = self
        
        // Assign the dataSource and delegate function responsibility to the view model
        tableView.dataSource = viewModel
        tableView.prefetchDataSource = viewModel
        tableView.delegate = viewModel
        tableView.backgroundColor = .clear
        tableView.register(RepoTableViewCell.nib, forCellReuseIdentifier: RepoTableViewCell.identifier)
        tableView.isHidden = true
        
        // Reload and show the table view once the repos are loaded
        viewModel.getRepos {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.shapeLayer.removeFromSuperlayer()
                self.label.removeFromSuperview()
                self.tableView.isHidden = false
            }
        }
    }
    
    // Set the nav bar to see through and give its header
    fileprivate func setUpNavBar() {
        navigationController?.navigationBar.topItem?.title = "Top 100 Github Repos"
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    // Set up the loading animation objects
    fileprivate func setUpLoadingAnimation() {
        let center = view.center
        
        // Create circular loading layer
        let circularPath = UIBezierPath(arcCenter: center, radius: 80, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.Theme.infoColor.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
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
    // Create loading animations which repeat every 1.65 seconds until they are deallocated
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

// Protocol method for the view models delegate to hide the navigation bar on swipe
extension RepoViewController: RepoViewModifier {
    func navBarIsHidden(_ cond: Bool) {
        UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.navigationController?.setNavigationBarHidden(cond, animated: true)
        }, completion: nil)
    }
}
