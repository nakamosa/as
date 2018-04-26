import UIKit

class ViewController2: UIViewController {
    private var myWindow: UIWindow!
    private var myWindowButton: UIButton!
    private var mySlider: UISlider!
    private var mySlider2: UISlider!
    private var mySlider3: UISlider!
    @IBOutlet weak var myButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var lastPoint = CGPoint.zero
    var currentPoint = CGPoint.zero
    var midPoint1 = CGPoint.zero
    var midPoint2 = CGPoint.zero
    var swiped = false
    var color = UIColor(red:0,green:0,blue:0,alpha:1).cgColor
    var saveImage: UIImage?
    var currentDrawNumber = 0
    var saveImageArray = [UIImage()]
    
    let ovalShapeLayer = CAShapeLayer() // 輪郭は青
    
    @IBOutlet weak var Slider: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Slider.minimumValue=0.01
        Slider.maximumValue=10// Do any additional setup after loading the view, typically from a nib.
        
        
        myWindow = UIWindow()
        myWindowButton = UIButton()
        
        mySlider = UISlider()
        mySlider2 = UISlider()
        mySlider3 = UISlider()
        
        
        let myImageView: UIImageView = UIImageView()
        
        self.view.addSubview(myImageView)
        
        // ボタンを生成する.
        myButton.layer.masksToBounds = true
        myButton.addTarget(self, action: #selector(ViewController2.onClickMyButton(sender:)), for: .touchUpInside)
        
        
        //self.view2.isUserInteractionEnabled = false
        
        
    }
    
    
    @objc func aa(){
        
        ovalShapeLayer.fillColor = UIColor(red:CGFloat(mySlider.value/255),green:CGFloat(mySlider2.value/255),blue:CGFloat(mySlider3.value/255),alpha:1).cgColor
        ovalShapeLayer.lineWidth = 1.0
        ovalShapeLayer.path = UIBezierPath(ovalIn: CGRect(x:60, y:40, width:self.myWindow.frame.width/1.35, height:self.myWindow.frame.width/1.35)).cgPath
        self.myWindow.layer.addSublayer(ovalShapeLayer)
    }
    
    //直線の描画
    func drawLines(fromPoint:CGPoint,toPoint:CGPoint){
        UIGraphicsBeginImageContext(self.imageView.frame.size)
        imageView.image?.draw(in: CGRect(x:0,y:0,width:self.imageView.frame.width,height:self.imageView.frame.height))
        let context = UIGraphicsGetCurrentContext()
        
        context?.move(to:CGPoint(x:fromPoint.x,y:fromPoint.y))
        context?.addLine(to:CGPoint(x:toPoint.x,y:toPoint.y))
        context?.setBlendMode(CGBlendMode.normal)
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(CGFloat(Slider.value * 10))
        context?.setStrokeColor(UIColor(red:CGFloat(mySlider.value/255),green:CGFloat(mySlider2.value/255),blue:CGFloat(mySlider3.value/255),alpha:1).cgColor)
        
        context?.strokePath()
        
        ovalShapeLayer.fillColor = UIColor(red:CGFloat(mySlider.value/255),green:CGFloat(mySlider2.value/255),blue:CGFloat(mySlider3.value/255),alpha:1).cgColor
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    //曲線の描画
    func drawCurves(fromPoint:CGPoint,toPoint:CGPoint,controlPoint:CGPoint){
        UIGraphicsBeginImageContext(self.imageView.frame.size)
        imageView.image?.draw(in: CGRect(x:0,y:0,width:self.imageView.frame.width,height:self.imageView.frame.height))
        let context = UIGraphicsGetCurrentContext()
        
        context?.move(to:CGPoint(x:fromPoint.x,y:fromPoint.y))
        context?.addQuadCurve(to:CGPoint(x:toPoint.x,y:toPoint.y),control:CGPoint(x:controlPoint.x,y:controlPoint.y))
        context?.setBlendMode(CGBlendMode.normal)
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(CGFloat(Slider.value * 10))
        context?.setStrokeColor(UIColor(red:CGFloat(mySlider.value/255),green:CGFloat(mySlider2.value/255),blue:CGFloat(mySlider3.value/255),alpha:1).cgColor)
        
        context?.strokePath()
        func aa(){
            ovalShapeLayer.fillColor = UIColor(red:CGFloat(mySlider.value/255),green:CGFloat(mySlider2.value/255),blue:CGFloat(mySlider3.value/255),alpha:1).cgColor
        }
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    //タッチスタート
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            lastPoint = touch.location(in: self.imageView)
            saveImage = self.imageView.image
        }
        
    }
    
    //タッチ移動
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            
            //初回の移動なら最初の中間点まで直線を引く
            if swiped == false{
                currentPoint = touch.location(in: self.imageView)
                midPoint1 = CGPoint(x:(lastPoint.x + currentPoint.x)/2,y:(lastPoint.y + currentPoint.y)/2)
                
                drawLines(fromPoint:lastPoint,toPoint:midPoint1)
                lastPoint = currentPoint
                swiped = true
                
            }else{
                //2回目以降の移動なら中間点を繋いで曲線を引く
                currentPoint = touch.location(in: self.imageView)
                midPoint2 = CGPoint(x:(lastPoint.x + currentPoint.x)/2,y:(lastPoint.y + currentPoint.y)/2)
                drawCurves(fromPoint:midPoint1,toPoint:midPoint2,controlPoint:lastPoint)
                midPoint1 = midPoint2
                lastPoint = currentPoint
                swiped = true
            }
        }
    }
    
    //最後のタッチは、最後の中間点から最終点まで直線を引く
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            currentPoint = touch.location(in: self.imageView)
            drawLines(fromPoint: midPoint1, toPoint: currentPoint)
            swiped = false
            
        }
        while currentDrawNumber != saveImageArray.count - 1 {
            
            saveImageArray.removeLast()
        }
        
        currentDrawNumber += 1
        saveImageArray.append(self.imageView.image!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func slideSlider(_ sender: Any) {
    }
    
    @IBAction func redo(_ sender: Any) {
        if currentDrawNumber + 1 > saveImageArray.count - 1 {return}
        
        self.imageView.image = saveImageArray[currentDrawNumber + 1]   //保存しているUndo前のimageに置き換える
        
        currentDrawNumber += 1
    }
    @IBAction func undo(_ sender: Any) {
        if currentDrawNumber <= 0 {return}
        
        self.imageView.image = saveImageArray[currentDrawNumber - 1]   //保存している直前imageに置き換える
        
        currentDrawNumber -= 1
    }
    
    
    func myview(){
        let TestView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 250, height: 250))
        let bgColor = UIColor.blue
        TestView.backgroundColor = bgColor
        self.view.addSubview(TestView)
    }
    
    
    @IBAction func bbbb(_ sender: Any) {
        
        
    }
    
    
    
    internal func makeMyWindow(){
        myWindow.backgroundColor = UIColor.gray
        myWindow.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height-30)
        myWindow.layer.position = CGPoint(x:self.view.frame.width/2, y:self.view.frame.height/2)
        myWindow.alpha = 1
        
        // myWindowをkeyWindowにする.
        myWindow.makeKey()
        
        // windowを表示する.
        self.myWindow.makeKeyAndVisible()
        
        // ボタンを作成する.
        myWindowButton.frame = CGRect(x:0, y:0, width:100, height:60)
        myWindowButton.backgroundColor = UIColor.orange
        myWindowButton.setTitle("Close", for: .normal)
        myWindowButton.setTitleColor(UIColor.white, for: .normal)
        myWindowButton.layer.masksToBounds = true
        myWindowButton.layer.cornerRadius = 20.0
        myWindowButton.layer.position = CGPoint(x:self.myWindow.frame.width/2, y:self.myWindow.frame.height-50)
        myWindowButton.addTarget(self, action: #selector(ViewController2.onClickMyButton(sender:)), for: .touchUpInside)
        self.myWindow.addSubview(myWindowButton)
        
        
        mySlider.layer.position = CGPoint(x:self.myWindow.frame.width/2, y:self.myWindow.frame.height-100)
        mySlider.frame.size.width = self.myWindow.frame.width-50
        mySlider.minimumValue = 0
        mySlider.maximumValue = 255
        self.myWindow.addSubview(mySlider)
        
        mySlider2.layer.position = CGPoint(x: self.myWindow.frame.width/2, y: self.myWindow.frame.height-150)
        mySlider2.frame.size.width = self.myWindow.frame.width-50
        mySlider2.minimumValue = 0
        mySlider2.maximumValue = 255
        self.myWindow.addSubview(mySlider2)
        
        mySlider3.layer.position = CGPoint(x: self.myWindow.frame.width/2, y: self.myWindow.frame.height-200)
        mySlider3.frame.size.width = self.myWindow.frame.width-50
        mySlider3.minimumValue = 0
        mySlider3.maximumValue = 255
        self.myWindow.addSubview(mySlider3)
        
        Timer.scheduledTimer(timeInterval:0.1, target: self, selector: #selector(ViewController2.aa), userInfo: nil, repeats: true)
        
        
        
    }
    
    /*
     ボタンイベント
     */
    @objc internal func onClickMyButton(sender: UIButton) {
        
        if sender == myWindowButton {
            myWindow.isHidden = true
            
        }
        else if sender == myButton {
            makeMyWindow()
        }
    }
    ////             アラートで確認
    //let alert = UIAlertController(title: "確認", message: "画像を初期化してもよいですか？", preferredStyle: .alert)
    //let okButton = UIAlertAction(title: "OK", style: .default, handler:{(action: UIAlertAction) -> Void in
    //    })
    //let cancelButton = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
    //// アラートにボタン追加
    //alert.addAction(okButton)
    //alert.addAction(cancelButton)
    //// アラート表示
    //present(alert, animated: true, completion: nil)
    //    }
    //
    //    if okButton {
    //
    //    }else{
    //
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        let secondVc = segue.destination as! procesViewController
//        // 値を渡す
//        secondVc.detail = imageView.image
//        secondVc.a = currentDrawNumber
//
//    }
    
    @IBAction func saveImage(_ sender: Any) {
        // 選択した写真を取得する
        let image = imageView.image  //info[UIImagePickerControllerOriginalImage] as! UIImage
        
        
        // フィルタ処理用に変換する
        let ciPhoto = CIImage(cgImage: (image?.cgImage)!)
        // フィルタの名前を指定する(今回はモザイク処理)
        let filter = CIFilter(name: "CIDiscBlur")
        // setValueで対象の画像、効果を指定する
        filter?.setValue(ciPhoto, forKey: kCIInputImageKey) // フィルタをかける対象の画像
        filter?.setValue(40.0, forKey: "inputRadius")      // モザイクのブロックの大きさ
        // フィルタ処理のオブジェクト
        let filteredImage:CIImage = (filter?.outputImage)!
        // 矩形情報をセットしてレンダリング
        let ciContext:CIContext = CIContext(options: nil)
        let imageRef = ciContext.createCGImage(filteredImage, from: filteredImage.extent)
        // やっとUIImageに戻る
        let outputImage = UIImage(cgImage:imageRef!, scale:1.0, orientation:UIImageOrientation.up)
        
                UIImageWriteToSavedPhotosAlbum(outputImage, nil, nil, nil)
            }
    
}



