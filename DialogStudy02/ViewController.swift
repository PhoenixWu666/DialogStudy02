//
//  ViewController.swift
//  DialogStudy02
//
//  Created by Phoenix Wu on 2017/12/11.
//  Copyright © 2017年 Phoenix Wu. All rights reserved.
//

import UIKit
import ApiAI

// transfer text to voice speech
import AVFoundation

class ViewController: UIViewController {

    let speechSynthesizer = AVSpeechSynthesizer()
    
    // Dialogflow からのレスポンス示すラベル
    @IBOutlet weak var responseLbl: UILabel!
    
    // ユーザー入力
    @IBOutlet weak var msgField: UITextField!
    
    func speechAndText(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechSynthesizer.speak(speechUtterance)
        
        // レスポンス示すアニメを作る
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
            self.responseLbl.text = text
        }, completion: nil)
    }
    
    func sendTxtMsg() {
        if let text = msgField.text, !text.isEmpty, let txtRequest = ApiAI.shared()?.textRequest() {
            txtRequest.query = text
            txtRequest.setMappedCompletionBlockSuccess({
                request, response in
                
                if let resp = response as? AIResponse, let txtResp = resp.result.fulfillment.messages[0]["speech"] as? String {
                    print(resp.result.fulfillment.messages)
                    self.speechAndText(text: txtResp)
                }
            }, failure: {
                request, error in
                
                // コンソールでエラーメッセージを示す
                if let err = error {
                    print(err)
                } else {
                    print("Unknown error!")
                }
            })
            
            ApiAI.shared().enqueue(txtRequest)
            msgField.text = ""
        }
    }
    
    @IBAction func sendMsg(_ sender: UIButton) {
        sendTxtMsg()
    }
    
}

