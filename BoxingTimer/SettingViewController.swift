//
//  SettingViewController.swift
//  BoxingTimer
//
//  Created by 인우 최 on 21/07/2019.
//  Copyright © 2019 인우 최. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var timerModel : TimerModel!
    var expensionIndex : IndexPath?
    
    let roundArray = Array(1...100)  // 라운드 픽커 배열
    let MinuteArray = Array(0...60) // 운동시간,휴식시간 픽커(분) 배열
    let SecondArray = Array(0...60) // 운동시간,휴식시간 픽커(초) 배열
    
   
    
    
    var playMinute : Int = 0
    var PlaySecond : Int = 0
    
    var breakMinute : Int = 0
    var breakSecond : Int = 0
    
    @IBOutlet var vibrationSwich: UISwitch!
    @IBOutlet var soundSwitch: UISwitch!
    

    
    // 이전 페이지로 되돌아가기 버튼
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: false) {
            
        }
    }

    @IBOutlet var roundStt: UILabel! // 라운드 세팅 값 텍스트
    @IBOutlet var playStt: UILabel! // 운동시간 세팅 값 텍스트
    @IBOutlet var breakStt: UILabel! // 휴식시간 세팅 값 텍스트
    
   
    @IBOutlet var roundPicker: UIPickerView! //라운드 세팅 값 픽커
    @IBOutlet var playTimePicker: UIPickerView! //운동시간 세팅 값 픽커
    @IBOutlet var breakTimePicker: UIPickerView! //휴식시간 세팅 값 픽커
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // 델리게이트 프로토콜이 구현되어 있는 객체를 delegae 속성을 통해 참조하고
        // 델리게이트 메서드를 찾아서 호출하기 위함 (픽커 사용시 꼭 필요)
        roundPicker.delegate = self
        roundPicker.dataSource = self
        playTimePicker.delegate = self
        playTimePicker.dataSource = self
        breakTimePicker.delegate = self
        breakTimePicker.dataSource = self
        
        //UserDefaults 로컬 저장
        if let timerModelDictionay = UserDefaults().object(forKey: "kTimerModel")  {
            timerModel = TimerModel(dictionary: timerModelDictionay as! NSDictionary)
        }else {
            timerModel = TimerModel()
        }

        reloadSetting()
    }
    
    func numberString(number:Int) -> String {
        
        if number < 10 {
            
            return "0\(number)"
            
        } else {
            
            return "\(number)"
            
        }
        
    }
    
    // 저장된 옵션 데이터 값 계속 유지 (앱 종료 후 실행 해도 저장된 옵션 값으로 시작)
    func reloadSetting() {
        self.playMinute = timerModel.playTime/60
        self.PlaySecond = timerModel.playTime%60
        
        self.breakMinute = timerModel.breakTime/60
        self.breakSecond = timerModel.breakTime%60
        
        roundStt.text = String(timerModel.round)
        playStt.text = "\(numberString(number: timerModel.playTime/60)) : \(numberString(number: timerModel.playTime%60))"
        breakStt.text = "\(numberString(number: timerModel.breakTime/60)) : \(numberString(number: timerModel.breakTime%60))"
        
        roundPicker.selectRow(timerModel.round - 1, inComponent: 0, animated: false)
        playTimePicker.selectRow(timerModel.playTime/60, inComponent: 0, animated: false)
        playTimePicker.selectRow(timerModel.playTime%60, inComponent: 1, animated: false)
        breakTimePicker.selectRow(timerModel.breakTime/60, inComponent: 0, animated: false)
        breakTimePicker.selectRow(timerModel.breakTime%60, inComponent: 1, animated: false)
        vibrationSwich.isOn = timerModel.vibration
        soundSwitch.isOn = timerModel.sound
        
    }
    
    public func numberOfComponents(in pickerView:UIPickerView) -> Int {
        
        if roundPicker == pickerView {
            return 1 // 라운드픽커 1개
        }else if playTimePicker == pickerView {
            return 2 // 운동시간 픽커 2개 ( 분 / 초 )
        }else if breakTimePicker == pickerView {
            return 2 // 휴식시간 픽커 2개 ( 분 / 초)
        }
        
        return 1
    }
    
    // 배열의 갯수를 픽커에 넘겨준다.
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component:Int) -> Int {
        
        if pickerView == roundPicker {
            return roundArray.count
        } else if pickerView == playTimePicker {
            if component == 0 {
                return MinuteArray.count
            } else if component == 1 {
                return SecondArray.count
            }
        } else if pickerView == breakTimePicker {
            if component == 0 {
                return MinuteArray.count
            } else if component == 1 {
                return SecondArray.count
            }
        }
        
        return 0
    }
    
    // 배열의 데이터 값을 받는다.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == roundPicker {
            return String(roundArray[row])
        } else if pickerView == playTimePicker {
            if component == 0 {
                return numberString(number: MinuteArray[row])
            } else if component == 1 {
                return numberString(number: SecondArray[row])
            }
        } else if pickerView == breakTimePicker {
            if component == 0 {
                return numberString(number: MinuteArray[row])
            } else if component == 1 {
                return numberString(number: SecondArray[row])
            }
            
        }
        
        return nil
    }
   
    // 선택된 배열 값을 연결된 라벨에 나타난다.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == roundPicker {
            self.roundStt.text = String(roundArray[row])
            timerModel.round = roundArray[row]
        } else if pickerView == playTimePicker {
            if component == 0 {
                self.playMinute = MinuteArray[row]
            } else if component == 1 {
                self.PlaySecond = SecondArray[row]
            }
            self.playStt.text = "\(numberString(number: self.playMinute)) : \(numberString(number: self.PlaySecond))"
            timerModel.playTime = self.playMinute * 60 + self.PlaySecond
            
        } else if pickerView == breakTimePicker {
            if component == 0 {
                self.breakMinute = MinuteArray[row]
            } else if component == 1 {
                self.breakSecond = SecondArray[row]
            }
            self.breakStt.text = "\(numberString(number: breakMinute)) : \(numberString(number: breakSecond))"
            timerModel.breakTime = self.breakMinute * 60 + self.breakSecond
        }
    }
    
    
    //MARK: 확장 (TableViewDelegate 사용)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let index = expensionIndex {
            if index.row == indexPath.row {
                expensionIndex = nil
            }else {
                expensionIndex = indexPath
            }
        }else {
            expensionIndex = indexPath
        }
        
        tableView.reloadRows(at: [indexPath], with: .none)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight:CGFloat = 0
        
        // 라운드, 플레이시간, 휴식시간 클릭시 픽커뷰 펼침과 닫힘
        if let index = expensionIndex {
            if index.row == indexPath.row {
                if index.row == 0 {
                    rowHeight = 220
                }else if index.row == 1 {
                    rowHeight = 220
                }else if index.row == 2 {
                    rowHeight = 220
                }else {
                    rowHeight = 80
                }
            }else {
                rowHeight = 80
            }
        }else {
            rowHeight = 80
        }

        return rowHeight
    }
    
    // 옵션 저장 버튼
    @IBAction func saveAction(_ sender: Any) {
        let timerModelDictionary = timerModel.getDictionary()
        
        //UserDefaults로 저장 'kTimerModel' 명으로 데이터 값 저장
        UserDefaults().set(timerModelDictionary, forKey: "kTimerModel")
        UserDefaults().synchronize()
        
        // 이전 페이지로 돌아간다.
        self.dismiss(animated: false) {
            
        }
    }
    
    // 리셋 버튼
    @IBAction func initAction(_ sender: Any) {
        timerModel = TimerModel()
        reloadSetting()
    }
    
    // 진동알림 스위치
    @IBAction func vibrationAction(_ sender: Any) {
        timerModel.vibration = vibrationSwich.isOn
    }
    
    // 사운드알림 스위치
    @IBAction func soundAction(_ sender: Any) {
        timerModel.sound = soundSwitch.isOn
    }
}

// component : 구성요소
