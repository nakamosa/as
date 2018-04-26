//
//  procesViewController.swift
//  view
//
//  Created by 中尾元春 on 2018/02/26.
//  Copyright © 2018年 中尾元春. All rights reserved.
//

import UIKit

import WebKit
class procesViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate , WKNavigationDelegate, WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
    private var webView: WKWebView!

    
    
    // 写真を表示するビュー
    @IBOutlet weak var imageView2: UIImageView!
    var detail : UIImage! = nil
    var a = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // 選択した写真を取得する
        let image = detail  //info[UIImagePickerControllerOriginalImage] as! UIImage
        
        
        // フィルタ処理用に変換する
        let ciPhoto = CIImage(cgImage: (image?.cgImage)!)
        // フィルタの名前を指定する(今回はモザイク処理)
        let filter = CIFilter(name: "CIPixellate")
        // setValueで対象の画像、効果を指定する
        filter?.setValue(ciPhoto, forKey: kCIInputImageKey) // フィルタをかける対象の画像
        filter?.setValue(10, forKey: "inputScale")          // モザイクのブロックの大きさ
        // フィルタ処理のオブジェクト
        let filteredImage:CIImage = (filter?.outputImage)!
        // 矩形情報をセットしてレンダリング
        let ciContext:CIContext = CIContext(options: nil)
        let imageRef = ciContext.createCGImage(filteredImage, from: filteredImage.extent)
        // やっとUIImageに戻る
        let outputImage = UIImage(cgImage:imageRef!, scale:1.0, orientation:UIImageOrientation.up)
        
        
        // ビューに表示する
        self.imageView2.image = outputImage
        //imageView2.image = UIImage(named: "PNGイメージ-11744EA0C3F1-1.png")
        //imageView2.image = detail
        
        // Do any additional setup after loading the view, typically from a nib.
                // デフォルトの画像を表示する
        
    }
    
//    @IBAction func saveImage(_ sender: Any) {
//
//        UIImageWriteToSavedPhotosAlbum(imageView2.image!, nil, nil, nil)
//    }
    
    
    // カメラロールから写真を選択する処理
//    @IBAction func choosePicture() {
////        // カメラロールが利用可能か？
////        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
////            // 写真を選ぶビュー
////            let pickerView = UIImagePickerController()
////            // 写真の選択元をカメラロールにする
////            // 「.camera」にすればカメラを起動できる
////            pickerView.sourceType = .photoLibrary
////            // デリゲート
////            pickerView.delegate = self
////            // ビューに表示
////            self.present(pickerView, animated: true)
////        }
//    }
    
//    // 写真を選んだ後に呼ばれる処理
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        // 選択した写真を取得する
//        let image = detail  //info[UIImagePickerControllerOriginalImage] as! UIImage
//
//
//        // フィルタ処理用に変換する
//        let ciPhoto = CIImage(cgImage: (image?.cgImage)!)
//        // フィルタの名前を指定する(今回はモザイク処理)
//        let filter = CIFilter(name: "CIPixellate")
//        // setValueで対象の画像、効果を指定する
//        filter?.setValue(ciPhoto, forKey: kCIInputImageKey) // フィルタをかける対象の画像
//        filter?.setValue(10, forKey: "inputScale")          // モザイクのブロックの大きさ
//        // フィルタ処理のオブジェクト
//        let filteredImage:CIImage = (filter?.outputImage)!
//        // 矩形情報をセットしてレンダリング
//        let ciContext:CIContext = CIContext(options: nil)
//        let imageRef = ciContext.createCGImage(filteredImage, from: filteredImage.extent)
//        // やっとUIImageに戻る
//        let outputImage = UIImage(cgImage:imageRef!, scale:1.0, orientation:UIImageOrientation.up)
//
//
//        // ビューに表示する
//        self.imageView2.image = outputImage
//        // 写真を選ぶビューを引っ込める
//        self.dismiss(animated: true)
//    }
    
    // 写真をリセットする処理
//    @IBAction func resetPicture() {
////        // アラートで確認
////        let alert = UIAlertController(title: "確認", message: "画像を初期化してもよいですか？", preferredStyle: .alert)
////        let okButton = UIAlertAction(title: "OK", style: .default, handler:{(action: UIAlertAction) -> Void in
////            // デフォルトの画像を表示する
////            self.imageView2.image = UIImage(named: "PNGイメージ-11744EA0C3F1-1.png")
////        })
////        let cancelButton = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
////        // アラートにボタン追加
////        alert.addAction(okButton)
////        alert.addAction(cancelButton)
////        // アラート表示
//       // present(alert, animated: true, completion: nil)
//    }
    
   
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        let secondVc = segue.destination as! ViewControllerunti
//        // 値を渡す
//        secondVc.detail = imageView2.image
//       // secondVc.a = currentDrawNumber
//
//    }
    
}
