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
    @IBOutlet weak var timerBar: UIProgressView!
    @IBOutlet weak var controlPauseBtn: UIButton!
    
    var correctIndex: Int!
    var names = Constants.names.map({ $0 })
    var score = 0
    var currentStreak = 0
    var longestStreak = 0
    
    var timerProgress: Float = 0
    var timer: Timer?
    
    var isPaused = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetTimer()
        // Set image bound
        promptImage.contentMode = .scaleAspectFill
        promptImage.layer.masksToBounds = true
        promptImage.layer.cornerRadius = promptImage.frame.width / 2 - 1
    
        genNewImage()
    }
    
    func genNewImage () {
        
        if names.count <= 4{
            gameEndHandler()
        }
        
        
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
    
    func correctAnswerHandler() {
        print("correct")
        score += 1; currentStreak += 1
        if currentStreak > longestStreak {
            longestStreak = currentStreak
        }
        genNewImage()
        resetTimer()
    }
    
    func incorrectAnswerHandler() {
        print("wrong")
        currentStreak = 0
        genNewImage()
        resetTimer()
    }
    
    func displayAnswer() {
        
    }
    
    func gamePauseHandler() {
        if let timer = timer {
            timer.invalidate()
        }
    }
    
    func gameRestartHandler() {
        buildTimer()
    }
    
    func gameEndHandler() {
        if let timer = timer {
            timer.invalidate()
        }
        timerProgress = 0
    }
    
    func resetTimer() {
        timerProgress = 0
        UIView.animate(withDuration: 0.2) {
            self.timerBar.setProgress(self.timerProgress, animated: true)
        }
        
        if let timer = timer {
            timer.invalidate()
        }
        
        buildTimer()
    }
    
    func buildTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            self.timerProgress += 0.2
            UIView.animate(withDuration: 0.2) {
                self.timerBar.setProgress(self.timerProgress, animated: true)
            }
            if self.timerProgress == 1 {
                timer.invalidate()
                self.incorrectAnswerHandler()
            }
        })
    }

    @IBAction func BtnOnTouchCallback(_ sender: UIButton) {
        if correctIndex == sender.tag {
            correctAnswerHandler()
        } else {
            incorrectAnswerHandler()
        }
    }
    
    @IBAction func controlPauseCallback(_ sender: UIButton) {
        if isPaused {
            isPaused = false
            controlPauseBtn.setImage(UIImage(named: "Pause"), for: .normal)
            gameRestartHandler()
        } else {
            isPaused = true
            controlPauseBtn.setImage(UIImage(named: "Play"), for: .normal)
            gamePauseHandler()
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
