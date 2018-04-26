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
    
    // Set labels if the a repo object is passed to the cell
    var item: Repo? {
        didSet {
            guard let item = item else { return }
            
            nameLabel.text = item.fullName
            starsLabel.text = "⭐️ " + String(describing: item.stargazersCount)
            topContributorLabel.text = "👑 "
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = UIColor.Theme.cellBackground
        nameLabel.textColor = UIColor.Theme.titleColor
        starsLabel.textColor = UIColor.Theme.infoColor
        topContributorLabel.textColor = UIColor.Theme.infoColor
    }
    
    func setContributor(_ contributor: String, _ contributorUrl: String) {
        // Update contributor if contributors url matches
        if item?.contributorsUrl == contributorUrl {
            DispatchQueue.main.async {
                self.topContributorLabel.text = "👑 " + contributor
            }
        }
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
