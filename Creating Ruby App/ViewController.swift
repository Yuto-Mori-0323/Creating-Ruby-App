//
//  ViewController.swift
//  Creating Ruby App
//
//  Created by 森勇人 on 2019/02/09.
//  Copyright © 2019 yuto mori. All rights reserved.
//

import UIKit

class ViewController: UIViewController,XMLParserDelegate {
    
    var kanaList = [String]()
    var kana02 = [String]()
    
    @IBOutlet weak var textField: UITextField!
    
    
    @IBAction func Creating_Ruby(_ sender: Any) {
        
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

        print("url\(url)")

        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request){
            (data:Data?,response:URLResponse?, error:Error?) in
            
            guard let xmldata = data else{
                print("データなし")
                return
            }
        //    print("data01\(data01)")
            
        //    let parser : XMLParser = XMLParser(contentsOf: data01)!
            let parser = XMLParser(data: xmldata)
            parser.delegate = self
            parser.parse()
            
        
        /*    if let value = String(data: data01, encoding: String.Encoding.utf8){
                print ("value\(value)")
            } */
        }
 
        task.resume()
    }
    
    // XML解析開始時に実行されるメソッド
    func parserDidStartDocument(_ parser: XMLParser) {
        print("XML解析開始しました")
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        for parsedStr in attributeDict {
        //    let exchangeRate = ExchangeRate()
            print("parsedStr\(parsedStr)")
            switch parsedStr.key {
            case "name":
                kanaList.append(parsedStr.value)
            default: break
            }
        }
        print("kanaList\(kanaList)")
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError)
    }
    
    
    
    @IBAction func comeHome (segue: UIStoryboardSegue){
        
    }
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

