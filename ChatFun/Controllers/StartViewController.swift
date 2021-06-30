//
//  StartViewController.swift
//  ChatFun
//
//  Created by Fuhrer_SS on 25.06.2021.
//

import UIKit

class StartViewController: UIViewController {


    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activitiIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView.isHidden = true
        loadingView.backgroundColor = UIColor.init(hexaString: "FFFFFF", alpha: 0.4)
        setupEnterButton()
//        enterButton.animation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        enterButton.animation()
    }
    @IBAction func enterButtonPressed(_ sender: Any) {
        activitiIndicator.startAnimating()
        loadingView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.performSegue(withIdentifier: "showTableView", sender: nil)
        }
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
