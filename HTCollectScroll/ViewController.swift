//
//  ViewController.swift
//  HTCollectScroll
//
//  Created by taotao on 1/16/16.
//  Copyright © 2016 taotao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let screenSize = UIScreen.mainScreen().bounds.size

    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = CGRectMake(0, 20, screenSize.width, 200)
        let infinitScroll = HTScrollView.init(frame: frame)
        self.view.addSubview(infinitScroll)
        
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

