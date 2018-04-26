import UIKit

class ViewController3: UIViewController , UITextFieldDelegate {
    
    
    @IBAction func rightswipe(_ sender: Any) {
        if(imageSub != 0){
            imageSub = imageSub-1
        }
        if let url = URL(string: wordImageArray[imageSub]) {
            let req = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: req, completionHandler: {data, response, error in
                if let data = data {
                    if let anImage = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.pic.image = anImage
                        }
                    }
                }
                
            })
            task.resume()
        }
    }
    
    @IBAction func leftswipe(_ sender: Any) {
        //imageSubを1つすすめる
        imageSub = imageSub+1
        
        //画像配列の末尾に到達している場合、配列に新たな10件を登録する
        if((imageSub) == wordImageArray.count){
            
            
            //パラメータのstartを決める
            let startPara: String = String(imageSub)
            
            //検索ワード
            let pasteboard = UIPasteboard.general
            let copiedText = pasteboard.string
            
            // パラメータを指定する
            let parameter = ["key": apikey,"cx":cx,"searchType":searchType,"q":copiedText,"start":startPara,"imgType":"photo"]
            
            // パラメータをエンコードしたURLを作成する
            let requestUrl = createRequestUrl(parameter: parameter as! [String : String])
            
            // APIをリクエストする
            request(requestUrl: requestUrl) { result in
                if let url = URL(string: self.wordImageArray[self.imageSub+1]) {
                    let req = URLRequest(url: url)
                    let task = URLSession.shared.dataTask(with: req, completionHandler: {data, response, error in
                        if let data = data {
                            if let anImage = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    self.pic.image = anImage
                                }
                            }
                        }
                    })
                    task.resume()
                }
            }
        }else{
            if let url = URL(string: wordImageArray[imageSub]) {
                let req = URLRequest(url: url)
                let task = URLSession.shared.dataTask(with: req, completionHandler: {data, response, error in
                    if let data = data {
                        if let anImage = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.pic.image = anImage
                            }
                        }
                    }
                })
                task.resume()
            }
        }
        
    }
    
    @IBOutlet weak var pic: UIImageView!
    
    @IBOutlet weak var text: UITextField!
    
    
    
    // 写真をリセットする処理
    @IBAction func resetPicture() {
        // アラートで確認
        let alert = UIAlertController(title: "確認", message: "画像を初期化してもよいですか？", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler:{(action: UIAlertAction) -> Void in
            // デフォルトの画像を表示する
            self.pic.image = UIImage(named: "default.png")
        })
        let cancelButton = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        // アラートにボタン追加
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        // アラート表示
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    // APIを利用するためのアプリケーションID（APIキー）
    let apikey: String = "AIzaSyAi8IQ0VNB92hVu6alC1xJI3AGt5Af55qc"
    
    //APIを利用するためのサーチエンジンキー（検索エンジンキー）
    let cx: String = "016697331958175786609:gl3fas3mjjq"
    
    //利用するAPIのサーチタイプ
    let searchType: String = "image"
    
    // APIのURL
    let entryUrl: String = "https://www.googleapis.com/customsearch/v1"
    
    //関連画像URLを格納する配列
    var wordImageArray: [String] = [String]()
    
    //現在表示している画像の添字を格納する変数
    var imageSub :Int = 0;
    
    
    
    @IBAction func button(_ sender: Any) {
        let query = text.text
        //配列の要素全削除
        wordImageArray.removeAll()
        
        // パラメータを指定する
        let parameter = ["key": apikey,"cx":cx,"searchType":searchType,"q":query,"safe":"off"]
        
        // パラメータをエンコードしたURLを作成する
        let requestUrl = createRequestUrl(parameter: parameter as! [String : String])
        
        // APIをリクエストする
        request(requestUrl: requestUrl) { result in
            if let url = URL(string: self.wordImageArray[0]) {
                let req = URLRequest(url: url)
                let task = URLSession.shared.dataTask(with: req, completionHandler: {data, response, error in
                    if let data = data {
                        if let anImage = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.pic.image = anImage
                            }
                        }
                    }
                })
                task.resume()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // textField の情報を受け取るための delegate を設定
        text.delegate = self as UITextFieldDelegate
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        // キーボードを閉じる
        textField.resignFirstResponder()
        
        return true
    }
    
    
    
    
    // パラメータのURLエンコード処理
    func encodeParameter(key: String, value: String) -> String? {
        // 値をエンコードする
        guard let escapedValue = value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            // エンコード失敗
            return nil
        }
        // エンコードした値をkey=valueの形式で返却する
        return "\(key)=\(escapedValue)"
    }
    
    // URL作成処理
    func createRequestUrl(parameter: [String: String]) -> String {
        var parameterString = ""
        for key in parameter.keys {
            // 値の取り出し
            guard let value = parameter[key] else {
                // 値なし。次のfor文の処理を行なう
                continue
            }
            
            // 既にパラメータが設定されていた場合
            if parameterString.lengthOfBytes(using: String.Encoding.utf8) > 0 {
                // パラメータ同士のセパレータである&を追加する
                parameterString += "&"
            }
            
            
            
            // 値をエンコードする
            guard let encodeValue = encodeParameter(key: key, value: value) else {
                // エンコード失敗。次のfor文の処理を行なう
                continue
            }
            // エンコードした値をパラメータとして追加する
            parameterString += encodeValue
            
        }
        let requestUrl = entryUrl + "?" + parameterString
        return requestUrl
    }
    
    // 検索結果をパース
    func parseData(items: [Any], resultHandler: @escaping (([String]?) -> Void)) {
        
        for item in items {
            
            // レスポンスデータから画像の情報を取得する
            guard let item = item as? [String: Any], let imageURL = item["link"] as? String else {
                
                resultHandler(nil)
                return
            }
            print(imageURL)
            
            // 配列に追加
            wordImageArray.append(imageURL)
            
        }
        
        resultHandler(wordImageArray)
    }
    
    // リクエストを行なう
    func request(requestUrl: String, resultHandler: @escaping (([String]?) -> Void)) {
        // URL生成
        guard let url = URL(string: requestUrl) else {
            // URL生成失敗
            resultHandler(nil)
            return
        }
        
        // リクエスト生成
        let request = URLRequest(url: url)
        
        // APIをコールして検索を行う
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            // 通信完了後の処理
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue) ?? "")
            
            // エラーチェック
            guard error == nil else {
                // エラー表示
                let alert = UIAlertController(title: "エラー", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                
                // UIに関する処理はメインスレッド上で行なう
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
                resultHandler(nil)
                return
            }
            
            // JSONで返却されたデータをパースして格納する
            guard let data = data else {
                // データなし
                resultHandler(nil)
                return
            }
            
            // JSON形式への変換処理
            guard let jsonData = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] else {
                // 変換失敗
                resultHandler(nil)
                return
            }
            
            // データを解析
            guard let resultSet = jsonData["items"] as? [Any] else {
                // データなし
                resultHandler(nil)
                return
            }
            self.parseData(items: resultSet, resultHandler: resultHandler)
        }
        // 通信開始
        task.resume()
    }
}


