//
//  ViewController2.swift
//  GestureCalculator
//
//  Created by Bindita Chaudhuri on 10/29/18.
//  Copyright © 2018 Bindita Chaudhuri. All rights reserved.
//

import UIKit
import AVFoundation
import UIKit.UIGestureRecognizerSubclass

class ViewController2: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let SwipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.equalsigngesture))
        SwipeRight.direction = UISwipeGestureRecognizer.Direction.right
        SwipeRight.numberOfTouchesRequired = 2
        self.view.addGestureRecognizer(SwipeRight)
        
        
        let SwipeLeft1 = UISwipeGestureRecognizer(target: self, action: #selector(self.deletegesture))
        SwipeLeft1.direction = UISwipeGestureRecognizer.Direction.left
        SwipeLeft1.numberOfTouchesRequired = 2
        self.view.addGestureRecognizer(SwipeLeft1)
        
        let SwipeLeft2 = UISwipeGestureRecognizer(target: self, action: #selector(self.cleargesture))
        SwipeLeft2.direction = UISwipeGestureRecognizer.Direction.left
        SwipeLeft2.numberOfTouchesRequired = 3
        self.view.addGestureRecognizer(SwipeLeft2)
        
        
        let SwipeUp1 = UISwipeGestureRecognizer(target: self, action: #selector(self.digit6gesture))
        SwipeUp1.direction = UISwipeGestureRecognizer.Direction.up
        SwipeUp1.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(SwipeUp1)
        
        let SwipeUp2 = UISwipeGestureRecognizer(target: self, action: #selector(self.plusgesture))
        SwipeUp2.direction = UISwipeGestureRecognizer.Direction.up
        SwipeUp2.numberOfTouchesRequired = 2
        self.view.addGestureRecognizer(SwipeUp2)
        
        let SwipeUp3 = UISwipeGestureRecognizer(target: self, action: #selector(self.multiplygesture))
        SwipeUp3.direction = UISwipeGestureRecognizer.Direction.up
        SwipeUp3.numberOfTouchesRequired = 3
        self.view.addGestureRecognizer(SwipeUp3)
        
        
        let SwipeDown1 = UISwipeGestureRecognizer(target: self, action: #selector(self.digit0gesture))
        SwipeDown1.direction = UISwipeGestureRecognizer.Direction.down
        SwipeDown1.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(SwipeDown1)
        
        let SwipeDown2 = UISwipeGestureRecognizer(target: self, action: #selector(self.minusgesture))
        SwipeDown2.direction = UISwipeGestureRecognizer.Direction.down
        SwipeDown2.numberOfTouchesRequired = 2
        self.view.addGestureRecognizer(SwipeDown2)
        
        let SwipeDown3 = UISwipeGestureRecognizer(target: self, action: #selector(self.dividegesture))
        SwipeDown3.direction = UISwipeGestureRecognizer.Direction.down
        SwipeDown3.numberOfTouchesRequired = 3
        self.view.addGestureRecognizer(SwipeDown3)
        
        
        let decimal = UILongPressGestureRecognizer(target: self, action: #selector(self.decimalgesture))
        decimal.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(decimal)
        
        //let logarithm = UIPinchGestureRecognizer(target: self, action: #selector(self.loggesture))
        //self.view.addGestureRecognizer(logarithm)
    }

    var firstgesture : UIGestureRecognizer? = nil
    @IBOutlet weak var inputarea: UILabel!
    @IBOutlet weak var resultarea: UILabel!
    
    var digit3flag = 0
    var digit6flag = 0
    var textnumber = ""
    var text_to_display = ""
    var op = ""
    //var touchbeganbutnotendedflag = 0
    //var logstartflag = 0
    
    var counter = 0
    var flag = 0
    var number1 = "" //: Double? = 0
    var number2 = "" //: Double? = 0
    var touchViews = [UITouch:TouchSpotView]()
    let synthesizer = AVSpeechSynthesizer()
    
    //var tap1 = 0
    //var tap1time: Double?
    //@IBOutlet weak var tapview: TouchableView!
    
    // 1
    /*
    var storedError: NSError?
    let downloadGroup = DispatchGroup()
    for address in ["add1","add2","add3"] {
        let url = URL(string: address)
        downloadGroup.enter()
        let photo = DownloadPhoto(url: url!) { _, error in
            if error != nil {
                storedError = error
            }
            downloadGroup.leave()
        }
        PhotoManager.shared.addPhoto(photo)
    }
    
    // 2
    downloadGroup.notify(queue: DispatchQueue.main) {
        completion?(storedError)
    }
    
    @objc func loggesture(sender: UIPinchGestureRecognizer){
        var result:Double?
        if (sender.state == UIGestureRecognizer.State.ended) {
            if sender.scale >= 1.0{
                logstartflag = 1
                text_to_display += "log("
                displayinput(text_to_display)
            }
            else{
                logstartflag = 0
                text_to_display += ")"
                displayinput(text_to_display)
                result = log(Double(textnumber)!)
                displayresult(String(result!))
                speaktext(String(result!))
                textnumber = ""
            }
        }
        sender.scale = 1.0
    }*/
    
    @objc func digit0gesture(sender:UISwipeGestureRecognizer){
        if digit3flag == 0{
            appenddigittodisplay(0)//Double(counter))
            appenddigittocompute(0)
            displayinput(text_to_display)
            speaktext(String(0))
        }
        else{
            appenddigittodisplay(3)//Double(counter))
            appenddigittocompute(3)
            displayinput(text_to_display)
            speaktext(String(3))
            digit3flag = 0
        }
    }
    
    @objc func decimalgesture(sender: UILongPressGestureRecognizer){
        //firstgesture = sender
        if (sender.state == UIGestureRecognizer.State.ended) {
            text_to_display += "."
            textnumber += "."
            displayinput(text_to_display)
            speaktext("dot")
        }
    }
    
    @objc func digit6gesture(sender:UISwipeGestureRecognizer){
        if (sender.state == UIGestureRecognizer.State.ended) {
                digit6flag = 1
        }
    }
    
    //@objc func pinchgesture(sender: UIPinchGestureRecognizer){
    //}
    @objc func equalsigngesture(sender:UISwipeGestureRecognizer) {
        var result:Double?
        if (sender.state == UIGestureRecognizer.State.ended) {
            number2 = textnumber
            switch op {
            case "*":
                result = Double(number1)! * Double(number2)!
            case "/":
                result = Double(number1)! / Double(number2)!
            case "-":
                result = Double(number1)! - Double(number2)!
            case "+":
                result = Double(number1)! + Double(number2)!
            case "^":
                result = pow(Double(number1)!, Double(number2)!)
            default:
                result = 0.0
            }
            displayresult(String(result!))
            speaktext(String(result!))
            textnumber = ""
            op = ""
            number1 = ""
            number2 = ""
        }
    }
    
    @objc func deletegesture(sender:UISwipeGestureRecognizer) {
        if (sender.state == UIGestureRecognizer.State.ended) {
            if !text_to_display.isEmpty{
                if text_to_display.suffix(1) == op{
                    op = ""
                }
                else if textnumber.isEmpty{
                    number1.remove(at: number1.index(before: number1.endIndex))
                }
                else{
                    textnumber.remove(at: textnumber.index(before: textnumber.endIndex))
                }
                text_to_display.remove(at: text_to_display.index(before: text_to_display.endIndex))
                displayinput(text_to_display)
                //displayresult("")
            }
            speaktext("delete")
        }
    }
    
    @objc func cleargesture(sender:UISwipeGestureRecognizer) {
        if (sender.state == UIGestureRecognizer.State.ended) {
            textnumber = ""
            text_to_display = ""
            op = ""
            digit3flag = 0
            digit6flag = 0
            number1 = ""
            number2 = ""
            displayinput(text_to_display)
            displayresult("")
            speaktext("clear")
        }
    }
    
    @objc func plusgesture(sender:UISwipeGestureRecognizer){
        op = "+"
        number1 = number1 + textnumber
        textnumber = ""
        appendsymbol("+")
        displayinput(text_to_display)
        speaktext("plus")
    }
    
    @objc func multiplygesture(sender:UISwipeGestureRecognizer){
        if op == "*"{
            op = "^"
            text_to_display.remove(at: text_to_display.index(before: text_to_display.endIndex))
            appendsymbol("^")
            displayinput(text_to_display)
            speaktext("power")
        }
        else{
            op = "*"
            number1 = number1 + textnumber
            textnumber = ""
            appendsymbol("*")
            displayinput(text_to_display)
            speaktext("multiply")
        }
    }
    
    @objc func dividegesture(sender:UISwipeGestureRecognizer){
        op = "/"
        number1 = number1 + textnumber
        textnumber = ""
        appendsymbol("/")
        displayinput(text_to_display)
        speaktext("divide")
    }
    
    @objc func minusgesture(sender:UISwipeGestureRecognizer){
        if textnumber.isEmpty && !op.isEmpty {
            textnumber += "-"
        }
        else{
            op = "-"
            number1 = number1 + textnumber
            textnumber = ""
        }
        appendsymbol("-")
        displayinput(text_to_display)
        speaktext("minus")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        flag = 0
        //if touchbeganbutnotendedflag == 0{
        //    touchbeganbutnotendedflag = 1
        //}
        for touch in touches {
            counter = counter + 1
            flag = flag + 1
            createViewForTouch(touch: touch)
        }
        //flag = 1
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let view = viewForTouch(touch: touch)
            // Move the view to the new location.
            let newLocation = touch.location(in: self.view)
            view?.center = newLocation
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print("endfired")
        //touchbeganbutnotendedflag = 0
        for touch in touches {
            removeViewForTouch(touch: touch)
        }
        if touchViews.count == 0{//flag == 1 {
            if counter == 3 && digit3flag == 0 && digit6flag == 0{
                digit3flag = 1
            }
            else if digit3flag == 1 && digit6flag == 0{
                appenddigittodisplay(counter+3)
                appenddigittocompute(counter+3)
                displayinput(text_to_display)
                speaktext(String(counter+3))
                digit3flag = 0
            }
            else if digit6flag == 1 && digit3flag == 0{
                appenddigittodisplay(counter+6)
                appenddigittocompute(counter+6)
                displayinput(text_to_display)
                speaktext(String(counter+6))
                digit6flag = 0
            }
            else{
                appenddigittodisplay(counter)//Double(counter))
                appenddigittocompute(counter)
                displayinput(text_to_display)
                speaktext(String(counter))
            }
            counter = 0
            //flag = 0
        }
        //else if touchViews.count == 1 && flag == 1{
        //    appendsymbol("%")
        //    displayinput(text_to_display)
        //}
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        //touchbeganbutnotendedflag = 0
        counter = 0
        for touch in touches {
            removeViewForTouch(touch: touch)
        }
    }
    
    func appendsymbol(_ symbol: String){
        text_to_display += symbol
    }
    
    func appenddigittodisplay(_ number: Int){
        text_to_display += String(number)
    }
    func appenddigittocompute(_ number: Int){
        textnumber += String(number)
    }
    
    func displayinput(_ str: String){
        inputarea.text = "Input: "+str
    }
    func displayresult(_ str: String){
        resultarea.text = "Result: "+str
    }
    
    func speaktext(_ str: String){
        let utterance = AVSpeechUtterance(string: str)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
        //synthesizer.stopSpeaking(at: .word)
    }
    
    // Circle area (view creation)
    
    func createViewForTouch( touch : UITouch ) {
        let newView = TouchSpotView()
        newView.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        newView.center = touch.location(in: self.view)
        
        // Add the view and animate it to a new size.
        self.view.addSubview(newView)
        //UIView.animate(withDuration: 0.2) {
        //    newView.bounds.size = CGSize(width: 100, height: 100)
        //}
        
        // Save the views internally
        touchViews[touch] = newView
    }
    
    func viewForTouch (touch : UITouch) -> TouchSpotView? {
        return touchViews[touch]
    }
    
    func removeViewForTouch (touch : UITouch ) {
        if let view = touchViews[touch] {
            view.removeFromSuperview()
            touchViews.removeValue(forKey: touch)
        }
    }
}
