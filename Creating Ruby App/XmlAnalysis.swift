//
//  XmlAnalysis.swift
//  Creating Ruby App
//
//  Created by 森勇人 on 2019/02/11.
//  Copyright © 2019 yuto mori. All rights reserved.
//

import UIKit

class XmlAnalysis: UIViewController,XMLParserDelegate {
    
    var judgeFlag = 0 /*XML解析中に使用する変数
                       0 → 初期値
                       1 → 開始タグに単語の表記(Surface)が現れた場合
                       2 → 開始タグに単語のよみ(Furigana)が現れた場合
                       3 → 単語の表記(Surface)を変数(Surface)に格納済みの場合
                       4 → 単語のよみ(Furigana)を変数(Furigana)に格納済みの場合
                       9 → 開始タグにSubWordListが現れた場合
                                            */
    var Surface = "" //mainProcessing
    var Furigana = "" //ふりがなを一時的に格納する変数
    var furigana = "" //最終的に取得するふりがな
    var furiganaList = [String]() ////ふりがなを一時的に格納する配列
    
    //XML解析
    func analysis(xmldata:Data) -> String {
        let parser = XMLParser(data: xmldata)
        parser.delegate = self
        parser.parse()
        return furigana
    }
    
    // XML解析開始時に実行されるメソッド
    func parserDidStartDocument(_ parser: XMLParser) {
    }
    
    // 解析中に要素の開始タグがあったときに実行されるメソッド
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if  judgeFlag != 9{
            switch elementName {
            case "Surface":
                judgeFlag = 1
            case "Furigana":
                judgeFlag = 2
            case "SubWordList":
                judgeFlag = 9
                /*SubWordListはFuriganaと二重表記になってしまうため格納しない。
                  SubWordList - 単語が漢字かな交じりのとき、その単語を、さらに細かく漢字部分とひらがな部分に分割した
                  結果のリスト。*/
            default:
                break
            }
        }
    }

    // 開始タグと終了タグでくくられたデータがあったときに実行されるメソッド
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch judgeFlag {
        case 1:
            Surface = string
            judgeFlag = 3
        case 2:
            Furigana = string
            judgeFlag = 4
        default:
            break
        }
    }
    
    // 解析中に要素の終了タグがあったときに実行されるメソッド
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Word" {
            switch judgeFlag {
            case 3:
                furiganaList.append(Surface)
            case 4:
                furiganaList.append(Furigana)
            case 9:
                furiganaList.append(Furigana)
                judgeFlag = 0
            default:
                break
            }
            judgeFlag = 0
        }
    }
    
    // XML解析終了時に実行されるメソッド
    func parserDidEndDocument(_ parser: XMLParser) {
        //配列からふりがなの生成
        for furigana_piece in furiganaList {
            furigana = furigana + furigana_piece
        }
    }
    
    // XML解析エラー時に実行されるメソッド
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
