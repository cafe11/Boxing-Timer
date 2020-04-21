//
//  ViewController.swift
//  BoxingTimer
//
//  Created by 인우 최 on 03/07/2019.
//  Copyright © 2019 인우 최. All rights reserved.
//

import UIKit
import AudioToolbox // 진동 구현위해 가져온 프레임워크
import AVFoundation // 오디오 재생 관련 프레임워크를 가져온다.

class ViewController: UIViewController {
    
    var timer = Timer() //  타이머 객체 생성
    var seconds = 180 // 타이머 시작 초기값
    var roundNum = 1 // 라운드 초기 값
    var breake = 30 // 브레이크 타임 초기 값
    var isBreakTime = false // 휴식시간 변수
    var resumeTapped = true // 일시정지 변수 ( 앱이 시작 될 때 일시정지 되지 않도록 false 값을 준다.)
    
    
    var imgRed : UIImage? //빨간불 이미지가 들어있는 UIImage 타입의 변수
    var imgGreen : UIImage? //초록불 이미지가 들어있는 UIImage 타입의 변수
    
    var roundRed : UIImage? // 라운드 빨간불 UIImage 변수
    var roundGreen : UIImage? // 라운드 초록불 UIImage 변수
    
    var audioPlayer : AVAudioPlayer? // 오디오 플레이어를 선언
    var audioPlayer2 : AVAudioPlayer? // 오디오2 플레이어를 선어
    
    var timerModel:TimerModel? // 타이머 데이터 값 가져오기
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // 라운드불, 효과음
        imgRed = UIImage(named: "background_break.png")
        imgGreen = UIImage(named: "background_play.png")
        
        roundRed = UIImage(named: "round_break.png")
        roundGreen = UIImage(named: "round_play.png")
        
        let sound = Bundle.main.path(forResource: "boxing_ring", ofType: "wav")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        }
        catch{
            print(error)
        }
        
        let sound2 = Bundle.main.path(forResource: "preparations_ring", ofType: "mp3")
        do {
            audioPlayer2 = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound2!))
        }
        catch{
            print(error)
        }
        
        
        
    }
    
    // 화면보일 때 호출되는 함수
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
       
        //UserDefault로 데이터 저장한 것 읽어오기
        if let timerModelDictionay = UserDefaults().object(forKey: "kTimerModel")  { //저장된 데이터가 있을 경우
            timerModel = TimerModel(dictionary: timerModelDictionay as! NSDictionary) // 형변환 시켜서 함수에 적용
        }else { //저장된 데이터가 없을 경우
            timerModel = TimerModel()
        }
        
        resetTapped(resetButton!)
    }
    
    
    // 세팅 이동 버튼
    @IBAction func moveSetting(_ sender: Any) {
        let mov = self.storyboard!.instantiateViewController(withIdentifier:"SettingVC")
        self.present(mov, animated: false)
    }
    
    
    @IBOutlet var roundLight: UIImageView! // 라운드배경 불
    @IBOutlet var roundTxtLight: UIImageView! // 라운드텍스트 불
    
    @IBOutlet var roundText: UILabel! // 라운드 텍스트 레이블
    @IBOutlet var timerText: UILabel! // 타이머 텍스트 레이블
    
    
    @IBOutlet var startButton: UIButton! // start버튼 아울렛
    @IBOutlet var resetButton: UIButton! // reset버튼 아울렛
 
    // start버튼 액션
    @IBAction func starTapped(_ sender: Any)
    {
        if self.resumeTapped == false
        {
            timer.invalidate() //타이머 중지시키겠다.
            self.resumeTapped = true // 타이머 일시정지
            startButton.setImage(UIImage(named: "start_button"), for: .normal) // start버튼 hold에서 start로 변경
        }else{
            runTimer() // 설정된 타이머 가져온다.
            self.resumeTapped = false // 타이머 일시정지 끝 재생
            startButton.setImage(UIImage(named: "hold_button"), for: .normal) // start버튼 start에서 hold로 변경
            if timerModel!.sound { //시작음 알림
                audioPlayer?.play()
            }
            if timerModel!.vibration { //시작진동 알림
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            }
            
        }
    }
  
    // reset버튼 액션
    @IBAction func resetTapped(_ sender: Any)
    {
        timer.invalidate() // 타이머 중지 시키겠다.
        seconds = timerModel!.playTime // 타이머 시간을 3분으로 초기화
        roundNum = 1 // 라운드 1라운드로 초기화
        roundText.text = "\(roundNum) Round" //라운드 텍스트에 1라운드로 초기화된 라운드 적용
        
        timerText.text = timeString(time:TimeInterval(seconds)) //
        startButton.setImage(UIImage(named: "start_button"), for: .normal) // start버튼 hold에서 start로 변경
        roundLight.image = imgGreen // 라운드불 초록색으로
        roundTxtLight.image = roundGreen //라운드텍스트 초록색으로
    }
    
    // 타이머 동작 설정 및 동작 시작
    func runTimer()
    {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
        
    }
    
    // 복싱타이머 기본 사이클 (1라운드 3분 > 휴식시간 30초)
    @objc func updateTimer ()
    {
        timerText.text = timeString(time: TimeInterval(seconds))
        
        if seconds < 1 //초가 1초 이하면
        {
            
            if isBreakTime == false //브레이크타임이 아니면
            {
                
                if roundNum == timerModel!.round
                { // 현재 카운트 된 라운드 숫자가 라운드 설정값이 되면 중지 시킨다
                    timer.invalidate()
                    return
                }
                seconds = timerModel!.breakTime // 휴식시간 30초를 준다.
 
                roundLight.image = imgRed // 타이머 백그라운드 빨간색이미지로 바뀜
                roundTxtLight.image = roundRed // 라운드 백그라운드 빨간색이미지로 바뀜
                isBreakTime = true // 브레이크타임 시작
                

                // 브레이크타임 시작 알림음
                if timerModel!.sound {
                    audioPlayer?.play()
                }
                // 브레이크타임 시작 진동
                if timerModel!.vibration {
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                }
                
                
            } else {
                seconds = timerModel!.playTime //라운드 3분 시작
                roundNum += 1 //라운드 +1 추가
                roundText.text = "\(roundNum) Round" // 라운드 텍스트에 roundNum 표시

                roundLight.image = imgGreen // 타이머 백그라운드 초록이미지로 바뀜
                roundTxtLight.image = roundGreen // 타이머 백그라운드 초록이미지로 바뀜
                isBreakTime = false //브레이크타임 꺼짐
                
                // 브레이크타임 시작 알림음
                if timerModel!.sound {
                    audioPlayer?.play()
                }
                // 새로운 라운드 시작 진동
                if timerModel!.vibration {
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                }
                
            }
        }else{
            if seconds == breake && isBreakTime == false{ // 라운드타임 30초를 남겨두며 브레이크타임이 아닐시
                
                if timerModel!.sound {
                    audioPlayer2?.play()
                }
                if timerModel!.sound {
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                }
            }
            
            seconds -= 1
            
        }
    }
    
    // 기본 숫자에서 시간으로 변경해줄 메소드
    func timeString(time:TimeInterval) -> String
    {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format:"%02i : %02i", minutes, seconds)
    }
    
    
    
}

