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
        SwipeLeft1.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(SwipeLeft1)
        
        let SwipeLeft2 = UISwipeGestureRecognizer(target: self, action: #selector(self.cleargesture))
        SwipeLeft2.direction = UISwipeGestureRecognizer.Direction.left
        SwipeLeft2.numberOfTouchesRequired = 2
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
    }

    var firstgesture : UIGestureRecognizer? = nil
    @IBOutlet weak var inputarea: UILabel!
    @IBOutlet weak var resultarea: UILabel!
    
    var digit3flag = 0
    var digit6flag = 0
    var textnumber = ""
    var text_to_display = ""
    var op = ""
    
    var counter = 0
    var flag : Int?
    var number1 : Double?
    var number2 : Double?
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
            number2 = Double(textnumber)
            switch op {
            case "*":
                result = number1! * number2!
            case "/":
                result = number1! / number2!
            case "-":
                result = number1! - number2!
            case "+":
                result = number1! + number2!
            default:
                result = 0.0
            }
            displayresult(String(result!))
            speaktext(String(result!))
            textnumber = ""
            op = ""
        }
    }
    
    @objc func deletegesture(sender:UISwipeGestureRecognizer) {
        if (sender.state == UIGestureRecognizer.State.ended) {
            text_to_display.remove(at: text_to_display.index(before: text_to_display.endIndex))
            displayinput(text_to_display)
            //displayresult("")
            if textnumber.isEmpty{
                //textnumber = "~"
            }
            else{
                textnumber.remove(at: textnumber.index(before: textnumber.endIndex))
            }
        }
    }
    
    @objc func cleargesture(sender:UISwipeGestureRecognizer) {
        if (sender.state == UIGestureRecognizer.State.ended) {
            textnumber = ""
            text_to_display = ""
            op = ""
            digit3flag = 0
            digit6flag = 0
            displayinput(text_to_display)
            displayresult("")
        }
    }
    
    @objc func plusgesture(sender:UISwipeGestureRecognizer){
        op = "+"
        number1 = Double(textnumber)
        textnumber = ""
        appendsymbol("+")
        displayinput(text_to_display)
        speaktext("plus")
    }
    
    @objc func multiplygesture(sender:UISwipeGestureRecognizer){
        op = "*"
        number1 = Double(textnumber)
        textnumber = ""
        appendsymbol("*")
        displayinput(text_to_display)
        speaktext("multiply")
    }
    
    @objc func dividegesture(sender:UISwipeGestureRecognizer){
        op = "/"
        number1 = Double(textnumber)
        textnumber = ""
        appendsymbol("/")
        displayinput(text_to_display)
        speaktext("divide")
    }
    
    @objc func minusgesture(sender:UISwipeGestureRecognizer){
        if textnumber.isEmpty{
            textnumber += "-"
        }
        else{
            op = "-"
            number1 = Double(textnumber)
            textnumber = ""
        }
        appendsymbol("-")
        displayinput(text_to_display)
        speaktext("minus")
    }
    
    /*@objc func SwipeGesture(sender:UIGestureRecognizer){
        if firstgesture == nil{
            firstgesture = sender
        }
        else{
            if let x = firstgesture as? UISwipeGestureRecognizer{
                if let y = sender as? UISwipeGestureRecognizer{
                    appendsymbol("$")
                    displayinput(text_to_display)
                }
            }
            else{
                if let y = sender as? UISwipeGestureRecognizer{
                    appendsymbol("&")
                    displayinput(text_to_display)
                }
            }
            firstgesture = nil
        }
        var temp_op: String = ""
        var text_op: String = ""
        if let SwipeGesture = sender as? UISwipeGestureRecognizer
        {
            switch SwipeGesture.direction
            {
            case UISwipeGestureRecognizer.Direction.right:
                //if downswipeflag == 1 {
                //    if Date().timeIntervalSinceReferenceDate - downswipetime! < 0.5{
                temp_op = "+"
                text_op = "plus"
            case UISwipeGestureRecognizer.Direction.left:
                temp_op = "-"
                text_op = "minus"
            case UISwipeGestureRecognizer.Direction.up:
                temp_op = "*"
                text_op = "multiply"
            case UISwipeGestureRecognizer.Direction.down:
                //downswipeflag = 1
                //downswipetime = Date().timeIntervalSinceReferenceDate
                //DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // change 2 to desired number of seconds
                //    if self.downswipeflag == 1{
                temp_op = "/"
                text_op = "divide"
            default:
                break
            }
            if textnumber.isEmpty{
                textnumber += temp_op
            }
            else{
                op = temp_op
                number1 = Double(textnumber)
                textnumber = ""
                speaktext(text_op)
            }
            appendsymbol(temp_op)
            displayinput(text_to_display)
        }
    }*/
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            counter = counter + 1
            createViewForTouch(touch: touch)
        }
        flag = 1
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
        for touch in touches {
            removeViewForTouch(touch: touch)
        }
        if flag == 1 {
            if counter == 3 && digit3flag == 0 && digit6flag == 0{
                digit3flag = 1
            }
            else if digit3flag == 1 && digit6flag == 0{
                appenddigittodisplay(counter+3)
                appenddigittocompute(counter+3)
                displayinput(text_to_display)
                speaktext(String(counter+3))
                counter = 0
                digit3flag = 0
            }
            else if digit6flag == 1 && digit3flag == 0{
                appenddigittodisplay(counter+6)
                appenddigittocompute(counter+6)
                displayinput(text_to_display)
                speaktext(String(counter+6))
                counter = 0
                digit6flag = 0
            }
            else{
                appenddigittodisplay(counter)//Double(counter))
                appenddigittocompute(counter)
                displayinput(text_to_display)
                speaktext(String(counter))
                counter = 0
            }
            flag = 0
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
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
