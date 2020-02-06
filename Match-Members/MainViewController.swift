//
//  MainViewController.swift
//  Match-Members
//
//  Created by Michael Lin on 2020/2/5.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var promptImage: UIImageView!
    @IBOutlet weak var NameBtn1: UIButton!
    @IBOutlet weak var NameBtn2: UIButton!
    @IBOutlet weak var NameBtn3: UIButton!
    @IBOutlet weak var NameBtn4: UIButton!
    
    var correctIndex: Int!
    var names = Constants.names.map({ $0 })
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set image bound
        promptImage.contentMode = .scaleAspectFill
        promptImage.layer.masksToBounds = true
        promptImage.layer.cornerRadius = promptImage.frame.width / 2
    
        genNewImage()
    }
    
    func genNewImage () {
        let nameBtnArr: [UIButton] = [
            NameBtn1,
            NameBtn2,
            NameBtn3,
            NameBtn4
        ]
        
        var selectedNames: [String] = []
        
        // Select 4 different names
        var randNames = names.map({ $0 })
        for _ in 0 ..< 4 {
            let randomIndex = Int(arc4random_uniform(UInt32(randNames.count)))
            selectedNames.append(randNames[randomIndex])
            randNames.remove(at: randomIndex)
        }
        
        let keyIndex = Int(arc4random_uniform(4))
        
        
        promptImage.image = UIImage(named: selectedNames[keyIndex].lowercased().replacingOccurrences(of: " ", with: ""))
        
        for i in 0 ..< 4 {
            nameBtnArr[i].setTitle(selectedNames[i], for: .normal)
        }
        
        names.remove(at: keyIndex)
        correctIndex = keyIndex
    }
    

    @IBAction func BtnOnTouchCallback(_ sender: UIButton) {
        if correctIndex == sender.tag {
            print("correct")
            score += 1
            genNewImage()
        } else {
            print("wrong")
            genNewImage()
        }
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
