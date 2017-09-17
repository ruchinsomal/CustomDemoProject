//
//  BaseVC.swift
//  CustomDemo
//
//  Created by Ruchin Somal on 17/09/17.
//  Copyright © 2017 Ruchin Somal. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    var screenWidth:CGFloat?
    var screenHeight:CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bounds = UIScreen.main.bounds
        screenWidth = bounds.size.width
        screenHeight = bounds.size.height
        //self.automaticallyAdjustsScrollViewInsets=false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.title = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
