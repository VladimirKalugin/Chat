//
//  ChatTableViewCell.swift
//  ChatFun
//
//  Created by Fuhrer_SS on 25.06.2021.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
   
    @IBOutlet weak var viewOfCell: UIView!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewOfCell.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
