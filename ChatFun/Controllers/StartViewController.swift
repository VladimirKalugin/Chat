//
//  StartViewController.swift
//  ChatFun
//
//  Created by Fuhrer_SS on 25.06.2021.
//

import UIKit

class StartViewController: UIViewController {


    @IBOutlet weak var enterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupEnterButton()
//        enterButton.animation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        enterButton.animation()
    }
    
    private func setupEnterButton() {
        let hight = enterButton.bounds.size.height
        enterButton.layer.cornerRadius = hight / 2
        enterButton.backgroundColor = UIColor(hexaString: "CF1F28")
        
        enterButton.tintColor = UIColor(hexaString: "FFFFFF")
        
        enterButton.layer.shadowColor = UIColor(hexaString: "E4222D").cgColor
        enterButton.layer.shadowOpacity = 0.5
        enterButton.layer.shadowRadius = 9
        enterButton.layer.shadowOffset.height = 0.2
    }
    
    

}
