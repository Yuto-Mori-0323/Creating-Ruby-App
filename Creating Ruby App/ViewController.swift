//
//  ViewController.swift
//  Creating Ruby App
//
//  Created by 森勇人 on 2019/02/09.
//  Copyright © 2019 yuto mori. All rights reserved.
//

import UIKit
var test = ""

class ViewController: UIViewController,XMLParserDelegate {
    
    var judgeFlag = 0
    var Surface = ""
    var Furigana = ""
    var furigana = ""
    var furiganaList = [String]()
    
    @IBOutlet weak var Results: UITextView!
    
    @IBOutlet weak var Execution: UIButton!
    @IBAction func Execution(_ sender: Any) {
 /*        Creating_Ruby({ furigana in
            print("furigana:\(furigana)")
            self.Results.text = furigana
        })
         */   hogeC()
        print("ここで終わり")
        
    }
    typealias CompletionClosure = ((_ result:String) -> Void)
    func hogeC() {
        
        // ①
        Creating_Ruby(completionClosure: { (result:String) in
            // ⑥ 10が返ってくる
            print("result\(result)")
            // メインスレッドからUIを更新
            DispatchQueue.main.async {
                self.Results.text = result
           //     self.Results.sizeToFit()
            }
            
        })
        
        // ④
    }
    
    @IBOutlet weak var textField: UITextField!
    
    
    
    func Creating_Ruby(completionClosure:@escaping CompletionClosure)  {
        
        let yahooID = "dj00aiZpPWc1ZHljbjRvNVNLSCZzPWNvbnN1bWVyc2VjcmV0Jng9NTg-"
        let grade = "1"
        let sentence = textField.text!
        
        let text = "https://jlp.yahooapis.jp/FuriganaService/V1/furigana?appid=" + yahooID + "&grade=" + grade + "&sentence=" + sentence
        
        guard let encoding_text = text.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            return
        }
    //    print ("URL\(URL)")
    //    print ("encoding_URL\(encoding_URL)")
    //    let url = URL(string: encoding_text)
        guard let url = URL(string: encoding_text) else{
            return
        }
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request)
        {(data:Data?,response:URLResponse?, error:Error?)  in  //ここからクロージャ
            guard let xmldata = data else{
                print("データなし")
                return
            }
            //取得したXmlの解析
            let xmlanalysis = XmlAnalysis()
            let furigana = xmlanalysis.analysis(xmldata:xmldata)
            completionClosure(furigana)
            
        }
        print("task.resume実行前")
        task.resume()
        print("task.resume実行後")
        
    }
    
    
   
    
    
    
    
    
  //  @IBAction func comeHome (segue: UIStoryboardSegue){
        
  //  }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 枠のカラー
        Results.layer.borderColor = UIColor.gray.cgColor
        
        // 枠の幅
        Results.layer.borderWidth = 0.3
        
        let rgba = UIColor(red: 255/255, green: 128/255, blue: 168/255, alpha: 1.0) // ボタン背景色設定
        Execution.backgroundColor = rgba                                               // 背景色
        Execution.layer.borderWidth = 0.3                                              // 枠線の幅
        Execution.layer.borderColor = UIColor.black.cgColor                            // 枠線の色
        Execution.layer.cornerRadius = 5.0// 角丸のサイズ
        Execution.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        
    
        // Do any additional setup after loading the view, typically from a nib.
    }
    //override func viewDidDisappear(_ animated: Bool) {
    //    send_furigana = furigana
        
        
    //}


}

