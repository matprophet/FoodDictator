//
//  CandidateTableViewCell.swift
//  Food Dictator
//
//  Created by Mat Davidson on 5/9/16.
//  Copyright © 2016 Mat Davidson. All rights reserved.
//

import UIKit

class CandidateTableViewCell: UITableViewCell {
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    
    var _isElectable: Bool = true
    var isElectable: Bool {
        get {
            return _isElectable
        }
        set {
            _isElectable = newValue
            profileImageView.alpha = _isElectable ? 1.0 : 0.5
            
            let textColor = _isElectable ? UIColor.blackColor() : UIColor.lightGrayColor()
            nameLabel.textColor = textColor
            subtitleLabel.textColor = textColor
            statusLabel.textColor = textColor
            
            statusLabel.hidden = _isElectable
        }
    }
    
    override func awakeFromNib() {
        profileImageView.clipsToBounds = true
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.borderColor = UIColor.init(white: 0.80, alpha: 1.0).CGColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = ""
        subtitleLabel.text = ""
        profileImageView.image = nil
        statusLabel.hidden = true
        isElectable = true
    }
}