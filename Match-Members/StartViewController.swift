//
//  MainViewController.swift
//  Match-Members
//
//  Created by Michael Lin on 2020/2/5.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func StartBtn(_ sender: Any) {
        performSegue(withIdentifier: "StartSequence", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
