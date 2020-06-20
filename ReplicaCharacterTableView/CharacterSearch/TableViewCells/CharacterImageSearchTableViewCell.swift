//
//  CharacterImageSearchTableViewCell.swift
//  ReplicaCharacterTableView
//
//  Created by JFC on 16/06/20.
//  Copyright © 2020 JFC. All rights reserved.
//

import UIKit

class CharacterImageSearchTableViewCell: UITableViewCell {
	var accessoryButton: UIButton?
	@IBOutlet var characterSearchImageImageView: UIImageView!
	@IBOutlet var characterSearchNameLabel: UILabel!
	@IBOutlet var characterSearchDescriptionLabel: UILabel!
	
	
    override func layoutSubviews() {
		super.layoutSubviews()
	
		frame.origin.x = 10
        backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
		
		selectedBackgroundView?.layer.cornerRadius = 22
		selectedBackgroundView?.frame.origin.x = 30
		
		backgroundView = UIView(frame: bounds)
        backgroundView?.frame.origin.x = bounds.maxX - 18
        backgroundView?.frame.size.width = 10
        backgroundView?.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.98, alpha: 1.0)
		
		layer.cornerRadius = 20
        contentView.layer.cornerRadius = 20
		
		let shadowPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.bottomLeft, .topLeft], cornerRadii: CGSize(width: 20, height: 20))
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 1
        layer.shadowRadius = 10
        layer.shadowPath = shadowPath.cgPath
		
		characterSearchNameLabel?.frame.origin.y = (imageView?.frame.minY ?? 0) + 10
        characterSearchImageImageView?.frame.origin = .zero
        characterSearchImageImageView?.frame.size.height = bounds.height
        
        accessoryButton = subviews.compactMap { $0 as? UIButton }.first
        accessoryButton?.frame.origin.y = bounds.height - 20
	}
}
