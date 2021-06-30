//
//  LoadingViewController.swift
//  ChatFun
//
//  Created by Fuhrer_SS on 30.06.2021.
//

import UIKit

class LoadingViewController: UIViewController {

    @IBOutlet weak var activitiIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activitiIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.performSegue(withIdentifier: "showTableView", sender: nil)
        }
        }
    

    

}
