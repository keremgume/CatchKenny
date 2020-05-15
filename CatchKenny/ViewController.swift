//
//  ViewController.swift
//  CatchKenny
//
//  Created by Kerem Güme on 13.05.2020.
//  Copyright © 2020 Kerem Güme. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var kennyImage: UIImageView!
    
    var timer = Timer()
    var kennyTimer = Timer()
    var counter = 0
    var userScore = 0
    var highestScore = 0
    var maxXPosition:CGFloat = 0
    var maxYPosition:CGFloat = 0
    
    // ----- Viewer -----
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kennyImage.isUserInteractionEnabled = true
        
        let kennyTapped = UITapGestureRecognizer(target: self, action: #selector(kennyCatched))
        kennyImage.addGestureRecognizer(kennyTapped)
        
        maxXPosition = UIScreen.main.bounds.width - kennyImage.frame.width
        maxYPosition = UIScreen.main.bounds.height - kennyImage.frame.height - 80
        resetScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        throwAlert(alertTitle: "Start!", alertMessage: "Click OK to start game!", isGameStart: true)
    }
    
    
    @objc func timerFunc() {
        counter -= 1
        timerLabel.text = "Time: \(counter) sec"
        
        if counter == 0 {
            timer.invalidate() // stops the timer
            kennyTimer.invalidate()
            timerLabel.text = "Time Over!"
            kennyImage.isHidden = true
            
            // check if user score is higher than the top score and update if necessary
            if userScore > highestScore {
                UserDefaults.standard.set(userScore, forKey: "userHighScore")
            }
            
            throwAlert(alertTitle: "Time Over!", alertMessage: "Your Score is \(userScore). Do you want to play again!", isGameStart: false)
        }
    }
    
    @objc func kennyCatched() {
        userScore += 1
        scoreLabel.text = "Score: \(userScore)"
    }
    
    
    // created function to create alert for the user
    func throwAlert(alertTitle: String, alertMessage:String, isGameStart:Bool) {
        let userAlert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        if isGameStart {
            let startButton = UIAlertAction(title: "Start", style: .cancel) { (UIAlertAction) in
                self.startTimers()
            }
            userAlert.addAction(startButton)
        } else {
            let okButton = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
                self.updateHighScore()
                self.kennyImage.isHidden = true
            }
            let restartButton = UIAlertAction(title: "Restart", style: .default) { (UIAlertAction) in
                self.resetScreen()
                self.startTimers()
            }
            userAlert.addAction(okButton)
            userAlert.addAction(restartButton)
        }
        self.present(userAlert, animated: true, completion: nil)
    }
    
    
    func updateHighScore() {
        
        let storedScore = UserDefaults.standard.object(forKey: "userHighScore")
        if (storedScore as? Int) != nil {
            highestScore = storedScore as! Int
            highScoreLabel.text = "High Score: \(highestScore)"
        } else {
            highestScore = 0
            highScoreLabel.text = "High Score: \(highestScore)"
        }
    }
    
    
    // prepares the screen for the new game
    func resetScreen() {
        counter = 10
        userScore = 0
        updateHighScore()
        scoreLabel.text = "Score: \(userScore)"
        timerLabel.text = "Time: \(counter) sec"
        kennyImage.isHidden = true
    }
    
    
    @objc func kennyRandomPlace() {
        let kennyPositionX: Int
        var kennyPositionY: Int
        
        kennyImage.isHidden = true
        kennyPositionX = Int(arc4random_uniform(UInt32(maxXPosition)))
        kennyPositionY = Int(arc4random_uniform(UInt32(maxYPosition)))
        
        if kennyPositionY < 170 {
            kennyPositionY = 170
        }
        
        kennyImage.frame = CGRect(x: kennyPositionX, y: kennyPositionY, width: 100, height: 100)
        
        kennyImage.isHidden = false
    }
    
    func startTimers() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFunc), userInfo: nil, repeats: true)
        
        kennyTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(kennyRandomPlace), userInfo: nil, repeats: true)
    }
    
}

