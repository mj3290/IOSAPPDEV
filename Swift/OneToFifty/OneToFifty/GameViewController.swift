//
//  GameViewController.swift
//  OneToFifty
//
//  Created by Kim Dong-woo on 2017. 4. 20..
//  Copyright © 2017년 Kim Dong-woo. All rights reserved.
//

import UIKit
import CoreData
import AudioToolbox

var ScoreList : [ScoreBoard] = []

class GameViewController: UIViewController {

    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var timerClock: TimerLabel!
    @IBOutlet weak var nextNumber: UILabel!
    
    private var gameManagerClass:NumberManager!
    private var arrayButton:[UIButton] = []
    private var nextNumNotifier:[Int:UIButton] = [:]
    private var timer = Timer()
    private var timerBtn = Timer()
    private var toggleVal = 0
    private var isStarted = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resolveScore()
        createNumPadButtons()
        
        gameManagerClass = NumberManager()
        
    }
    
    /// 진동호출
    func Viberate() {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }
    
    /// 점수 리스트 DB에서 읽어서 리스트에 저장
    func resolveScore() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext  = appDelegate.persistentContainer.viewContext
        
        let request : NSFetchRequest<ScoreBoard> = ScoreBoard.fetchRequest()
        let scores : [ScoreBoard] = try! context.fetch(request)
   
        ScoreList = scores
    }
    
      
    /// 점수등록
    ///
    /// - Parameter score  : 점수
    private func addScore(score: String){
       
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext  = appDelegate.persistentContainer.viewContext
        
        
        let newScore  = ScoreBoard(context: context)
        newScore.score = score
        newScore.date = Date() as NSDate
        
        do {
            try context.save()
        }
        catch let error {
            print("save error : \(error.localizedDescription)")
        }
        
        ScoreList.append(newScore)
    }

    
    /// 숫자 버튼 생성
    private func createNumPadButtons() {
        var initX = 21
        var initY = 200
        let offset = 8
        
        for i in 1...5 {
            for j in 1...5 {
                let button = UIButton(type: .system)
                button.frame = CGRect(x: initX, y: initY, width:60, height:60)
                button.backgroundColor = UIColor.darkGray
                button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                button.setTitleColor( UIColor.white, for: .normal)
                button.titleLabel?.font = UIFont(name: "Verdana", size: 20)
                
                self.view.addSubview(button)
                arrayButton.append(button)
                
                initX += (60+offset)
            }
            initX = 21
            initY += (60+offset)
        }
    }
    
    /// 버튼 눌렀을 때 이벤트
    ///
    /// - Parameter sender: 눌린 버튼
    @IBAction func buttonAction(sender: UIButton)
    {
        let btnText = sender.titleLabel?.text
        if let str = btnText {
            if str != nil {
                let btnNum = Int(str)
                if btnNum == 50 {
                    timerClock.stop(self)
                    
                    offTimer()
                    offBtnTimer()
                    
                    sender.isHidden = true
                    
                    let localAlert = UIAlertController(title : "결과", message: "당신의 기록은 : " + "\(String(timerClock.text!) ?? "")", preferredStyle: .alert)
                    let localAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    localAlert.addAction(localAction)
                    
                    self.present(localAlert, animated: true, completion: nil)
                    
                    addScore(score:timerClock.text!)
                    
                    btnStart.isEnabled = true
                    isStarted = 0
                    btnStart.titleLabel?.text = "START"
                    
                    for btn in arrayButton {
                        btn.titleLabel?.text = ""
                        btn.isHidden = false
                    }
                    return
                }
                
                offTimer()
                offBtnTimer()
                
                sender.backgroundColor = UIColor.darkGray
                
                let retVal = gameManagerClass.UpdateNumber(clickNumber: btnNum!)
                if retVal == nomoreNumber {
                    nextNumber.text = String(gameManagerClass.nextNumber)
                    sender.isHidden = true
                }
                else
                {
                    if retVal != isNotCorrect {
                        nextNumber.text = String(gameManagerClass.nextNumber)
                        nextNumNotifier[retVal] = sender
                        sender.setTitle(String(retVal), for: .normal)
                    }
                    else {
                        Viberate() // 잘못 눌렀을 때 진동
                    }
                }
                
                onTimer()
            }
        }
        
    }
    
    // 3초동안 못 찾으면 깜빡임 용도
    func timerAction() {
        onBtnTimer()
        offTimer()
    }
    
    // Button Flicker
    func btnTimerAction() {
        let nextNum = Int(nextNumber.text!)
        let btn = nextNumNotifier[nextNum!]
        
        if let b:UIButton = btn {
            if b != nil {
                toggleVal = 1 - toggleVal
                if toggleVal == 1 {
                    b.backgroundColor = UIColor.red
                }
                else {
                    b.backgroundColor = UIColor.darkGray
                }
            }
        }
    }
    
    // 3초안에 못 눌렀으면 해당 버튼 알려주기
    private func onBtnTimer() {
        timerBtn = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(btnTimerAction), userInfo: nil, repeats: true)
    }
    
    private func offBtnTimer() {
        timerBtn.invalidate()
        toggleVal = 0
    }
    
    // 다음 숫자 3초안에 눌렀는지 체크하는 타이머
    private func onTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    private func offTimer() {
        timer.invalidate()
    }
 
    /// 게임시작
    ///
    /// - Parameter sender: 시작버튼
    @IBAction func touchStartup(_ sender: Any) {
        if isStarted == 0 {
            timerClock.text = "00:00:00"
          
            gameManagerClass.InitNumber()
            nextNumber.text = "1"
            
            let firstSetting:[Int] = gameManagerClass.getFirstSettingNumber()
            
            var i = 0
            for btn in arrayButton {
                if btn.isHidden == true {
                    btn.isHidden = false
                }
                btn.setTitle(String(firstSetting[i]), for: .normal)
                nextNumNotifier[firstSetting[i]] = btn
                
                i += 1
            }
            
            onTimer()
            isStarted = 1
            
            timerClock.start(self)
            btnStart.isEnabled = false

         }

    }

        
}
