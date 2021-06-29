//
//  ChatCollectionViewCell.swift
//  ChatFun
//
//  Created by Fuhrer_SS on 23.06.2021.
//

import UIKit

class ChatCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = String(describing: ChatCollectionViewCell.self)
    
    var stackView: UIStackView = {
       let stack = UIStackView()
        return stack
    }()
    
    var messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.backgroundColor = UIColor(hexaString: "D9D8D8")
        textView.layer.cornerRadius = 4
        textView.layer.shadowColor = UIColor(hexaString: "000000").cgColor
        textView.layer.shadowOffset = CGSize(width: 0, height: 0.2)
        textView.layer.shadowRadius = 4
        textView.layer.shadowOpacity = 0.5
        textView.layer.masksToBounds = false
        textView.isScrollEnabled = false
        textView.isEditable = false
        return textView
    }()
    
    var timeLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
       return label
    }()
    
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(timeLabel)
        addSubview(messageTextView)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
      
        self.messageTextView.text = nil
        self.timeLabel.text = nil
    }
}


