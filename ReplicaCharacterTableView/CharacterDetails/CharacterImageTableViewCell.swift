//
//  CharacterImageTableViewCell.swift
//  ReplicaCharacterTableView
//
//  Created by JFC on 07/06/20.
//  Copyright © 2020 JFC. All rights reserved.
//

import UIKit

class CharacterImageTableViewCell: UITableViewCell {
	@IBOutlet var characterImageView: UIImageView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
