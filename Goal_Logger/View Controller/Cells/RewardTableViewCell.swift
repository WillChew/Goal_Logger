//
//  RewardTableViewCell.swift
//  Goal_Logger
//
//  Created by Will Chew on 2019-12-31.
//  Copyright © 2019 Will Chew. All rights reserved.
//

import UIKit

class RewardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var stockLevel: UILabel!
    @IBOutlet weak var rewardImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        self.rewardImage.image = UIImage()
    }
    
}
