//
//  RepoTableViewCell.swift
//  BrightwheelCodeChallenge
//
//  Created by Alex Hoff on 4/23/18.
//  Copyright © 2018 Alex Hoff. All rights reserved.
//

import UIKit

class RepoTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var topContributorLabel: UILabel!
    
    var item: Repo? {
        didSet {
            guard let item = item else { return }
            
            nameLabel.text = item.fullName
            starsLabel.text = "⭐️ " + String(describing: item.stargazersCount)
            
            if let contributor = item.topContributor {
                topContributorLabel.text = "👑 " + contributor
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = UIColor.Theme.cellBackground
        nameLabel.textColor = UIColor.Theme.titleColor
        starsLabel.textColor = UIColor.Theme.infoColor
        topContributorLabel.textColor = UIColor.Theme.infoColor
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
