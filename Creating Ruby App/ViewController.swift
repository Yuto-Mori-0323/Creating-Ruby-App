//
//  ViewController.swift
//  Creating Ruby App
//
//  Created by 森勇人 on 2019/02/09.
//  Copyright © 2019 yuto mori. All rights reserved.
//

import UIKit

class ViewController: UIViewController,XMLParserDelegate {
    
    @IBOutlet weak var textField: UITextField! //テキスト入力
    @IBOutlet weak var Results: UITextView!  //テキスト出力
    @IBOutlet weak var Execution: UIButton!  //実行ボタン
    
    //実行ボタン押下
    @IBAction func Execution(_ sender: Any) {
        mainProcessing()
    }
    
    //XML解析が非同期処理のため、完了を待ち合わせるクロージャを定義
    typealias CompletionClosure = ((_ result:String) -> Void)
    
    func mainProcessing() {
        Creating_Ruby(completionClosure: { (result:String) in
            // 以下はCreating_RubyでcompletionClosure(furigana)後に実行される
            // メインスレッドからUIを更新(バックグラウンドからのUI更新はサポート外)
            DispatchQueue.main.async {
                self.Results.text = result
            }
            
        })
    }

    func Creating_Ruby(completionClosure:@escaping CompletionClosure)  {
        
        let yahooID = "dj00aiZpPWc1ZHljbjRvNVNLSCZzPWNvbnN1bWVyc2VjcmV0Jng9NTg-" //取得したyahooID
        let grade = "1" //yahooAPI「るび振り」のパラメータ。「1」は漢字全てをひらがなにする
        let sentence = textField.text!
        let text = "https://jlp.yahooapis.jp/FuriganaService/V1/furigana?appid=" + yahooID + "&grade=" + grade + "&sentence=" + sentence
        
        //エンコード処理
        guard let encoding_text = text.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            return
        }
        
        //アンラップ
        guard let url = URL(string: encoding_text) else{
            return
        }
        
        //サーバへの通信開始
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request)
        {(data:Data?,response:URLResponse?, error:Error?)  in
            guard let xmldata = data else{
                return
            }
            //取得したXmlの解析
            let xmlanalysis = XmlAnalysis()
            let furigana = xmlanalysis.analysis(xmldata:xmldata)
            //furiganaを受け取ったらmainProcessingに戻る
            completionClosure(furigana)
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //出力テキストのレイアウト
        Results.layer.borderColor = UIColor.gray.cgColor
        Results.layer.borderWidth = 0.3
        
        //実行ボタンのレイアウト
        let rgba = UIColor(red: 255/255, green: 128/255, blue: 168/255, alpha: 1.0)
        Execution.backgroundColor = rgba
        Execution.layer.borderWidth = 0.3
        Execution.layer.borderColor = UIColor.black.cgColor
        Execution.layer.cornerRadius = 5.0
        Execution.setTitleColor(UIColor.white, for: UIControl.State.normal)
    }
}

