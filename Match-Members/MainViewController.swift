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
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var statsStack: UIStackView!
    @IBOutlet weak var longestStreakLabel: UILabel!
    @IBOutlet weak var lastNames1: UILabel!
    @IBOutlet weak var lastNames2: UILabel!
    @IBOutlet weak var lastNames3: UILabel!
    
    var nameBtnArr: [UIButton]!
    var statsLastNamesArr: [UILabel]!
    var lastThreeAnswered: [String] = ["", "", ""]
    let blurredEffectView = UIVisualEffectView(effect: nil)
    
    var correctIndex: Int!
    var names = Constants.names.map({ $0 })
    var score: Int!
    var currentStreak: Int!
    var longestStreak: Int!
    
    var timerProgress: Float = 0
    var timer: Timer?
    
    var isPaused = false
    var statsShow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameBtnArr = [
            NameBtn1,
            NameBtn2,
            NameBtn3,
            NameBtn4
        ]
        
        statsLastNamesArr = [
            lastNames1,
            lastNames2,
            lastNames3
        ]
        
        resetTimer()
        blurredEffectView.frame = view.bounds
        blurredEffectView.isUserInteractionEnabled = false
        view.insertSubview(blurredEffectView, at: 5)
        // Set image bound
        promptImage.contentMode = .scaleAspectFill
        promptImage.layer.masksToBounds = true
        promptImage.layer.cornerRadius = 65
    
        genNewImage()
    }
        
    func genNewImage () {
        
        if names.count <= 4{
            gameEndHandler()
        }
        
        var selectedNames: [String] = []
        
        // Select 4 different names
        var randNames = names.map({ $0 })
        for i in 0 ..< 4 {
            let randomIndex = Int(arc4random_uniform(UInt32(randNames.count)))
            selectedNames.append(randNames[randomIndex])
            randNames.remove(at: randomIndex)
            nameBtnArr[i].setBackgroundImage(UIImage(named: "NameBtnBackground"), for: .normal)
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
        setAllBtnInteraction(false)
        displayAnswer()
        score += 1; currentStreak += 1
        scoreLabel.text = String(score)
        if currentStreak > longestStreak {
            longestStreak = currentStreak
        }
        if let timer = timer {
            timer.invalidate()
        }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {timer in
            self.genNewImage()
            self.resetTimer()
            self.setAllBtnInteraction(true)
        })
    }
    
    func incorrectAnswerHandler() {
        setAllBtnInteraction(false)
        displayAnswer()
        currentStreak = 0
        if let timer = timer {
            timer.invalidate()
        }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {timer in
            self.genNewImage()
            self.resetTimer()
            self.setAllBtnInteraction(true)
        })
    }
    
    func displayAnswer() {
        lastThreeAnswered.remove(at: 0)
        lastThreeAnswered.append(nameBtnArr[correctIndex].titleLabel?.text! ?? "")
        
        for i in 0..<4 {
            if i != correctIndex {
                nameBtnArr[i].setBackgroundImage(UIImage(named: "Wrong"), for: .normal)
            } else {
                nameBtnArr[i].setBackgroundImage(UIImage(named: "Correct"), for: .normal)
            }
        }
    }
    
    func gamePauseHandler() {
        isPaused = true
        controlPauseBtn.setImage(UIImage(named: "Play"), for: .normal)
        setAllBtnInteraction(false)
        print(lastThreeAnswered)
        
        UIView.animate(withDuration: 0.5) {
            self.blurredEffectView.effect = UIBlurEffect(style: UIBlurEffect.Style.light)
        }
        
        if let timer = timer {
            timer.invalidate()
        }
    }
    
    func gameResumeHandler() {
        isPaused = false
        controlPauseBtn.setImage(UIImage(named: "Pause"), for: .normal)
        disableStats()
        setAllBtnInteraction(true)
        UIView.animate(withDuration: 0.5) {
            self.blurredEffectView.effect = nil
        }
        buildTimer()
    }
    
    func enableStats() {
        statsShow = true
        updateStats()
        UIView.animate(withDuration: 0.3) {
            self.statsStack.alpha = 1
        }
    }
    
    func disableStats() {
        statsShow = false
        UIView.animate(withDuration: 0.3) {
            self.statsStack.alpha = 0
        }
    }
    
    func updateStats() {
        longestStreakLabel.text = String(longestStreak)
        for i in 0..<3 {
            statsLastNamesArr[i].text = lastThreeAnswered[i]
        }
    }
    
    func gameEndHandler() {
        if let timer = timer {
            timer.invalidate()
        }
        names = Constants.names.map({ $0 })
        timerProgress = 0
        enableStats()
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
    
    func setAllBtnInteraction(_ enabled: Bool) {
        for i in nameBtnArr {
            i.isUserInteractionEnabled = enabled
        }
    }

    @IBAction func BtnOnTouchCallback(_ sender: UIButton) {
        if correctIndex == sender.tag {
            correctAnswerHandler()
        } else {
            incorrectAnswerHandler()
        }
    }
    
    @IBAction func controlStatsCallback(_ sender: Any) {
        if statsShow {
            disableStats()
            gameResumeHandler()
        } else {
            gamePauseHandler()
            enableStats()
        }
    }
    
    @IBAction func controlPauseCallback(_ sender: UIButton) {
        if isPaused {
            gameResumeHandler()
        } else {
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
