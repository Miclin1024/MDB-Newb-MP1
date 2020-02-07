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
    var gracePeriodTimer: Timer?
    
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
    
    override func viewDidDisappear(_ animated: Bool) {
        gameEndHandler()
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
        
        // Randomly pick one as key and apply the photo and labels
        let keyIndex = Int(arc4random_uniform(4))
        promptImage.image = UIImage(named: selectedNames[keyIndex].lowercased().replacingOccurrences(of: " ", with: ""))
        for i in 0 ..< 4 {
            nameBtnArr[i].setTitle(selectedNames[i], for: .normal)
        }
        
        // Remove the name from array
        names = names.filter({(elem) -> Bool in
            return elem != selectedNames[keyIndex]
        })
        
        correctIndex = keyIndex
    }
    
    // --------------------- //
    // Answer Select Handler //
    // --------------------- //
    
    func correctAnswerHandler() {
        
        //Haptic Control
        let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
        notificationFeedbackGenerator.prepare()
        notificationFeedbackGenerator.notificationOccurred(.success)
        
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
        
        gracePeriodTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {timer in
            self.genNewImage()
            self.resetTimer()
            self.setAllBtnInteraction(true)
            self.gracePeriodTimer = nil
        })
    }
    
    func incorrectAnswerHandler() {
        
        let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
        notificationFeedbackGenerator.prepare()
        notificationFeedbackGenerator.notificationOccurred(.error)
        
        setAllBtnInteraction(false)
        displayAnswer()
        
        currentStreak = 0
        
        if let timer = timer {
            timer.invalidate()
        }
        
        gracePeriodTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {timer in
            self.genNewImage()
            self.resetTimer()
            self.setAllBtnInteraction(true)
            self.gracePeriodTimer = nil
        })
    }
    
    // ----------------------------- //
    // Game Sequence Control Routine //
    // ----------------------------- //
    
    func gamePauseHandler() {
        isPaused = true
        
        controlPauseBtn.setImage(UIImage(named: "Play"), for: .normal)
        setAllBtnInteraction(false)
        
        UIView.animate(withDuration: 0.5) {
            self.blurredEffectView.effect = UIBlurEffect(style: UIBlurEffect.Style.light)
        }
        
        if let timer = timer {
            timer.invalidate()
        }
        
        if let gracePeriodTimer = gracePeriodTimer {
            gracePeriodTimer.invalidate()
            
            // Set gracePeriodTimer to nil so the next game pause does not incorrectly trigger the call
            self.gracePeriodTimer = nil
            self.genNewImage()
            timerProgress = 0
            UIView.animate(withDuration: 0.2) {
                self.timerBar.setProgress(self.timerProgress, animated: true)
            }
        }
    }
    
    func gameResumeHandler() {
        isPaused = false
        
        controlPauseBtn.setImage(UIImage(named: "Pause"), for: .normal)
        setAllBtnInteraction(true)
        
        disableStats()
        UIView.animate(withDuration: 0.5) {
            self.blurredEffectView.effect = nil
        }
        
        buildTimer()
    }
    
    func gameEndHandler() {
        // Reset the name list
        names = Constants.names.map({ $0 })
        
        if let timer = timer {
            timer.invalidate()
        }
        timerProgress = 0
        enableStats()
    }
    
    // --------------- //
    // UI/UX Utilities //
    // --------------- //
    
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
    
    // ------------------------- //
    // UI Interactable Callbacks //
    // ------------------------- //

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
