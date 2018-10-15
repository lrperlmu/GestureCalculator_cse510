//
//  ViewController.swift
//  GestureCalculator
//
//  Created by Bindita Chaudhuri on 10/13/18.
//  Copyright © 2018 Bindita Chaudhuri. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let SwipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.SwipeGesture))
        SwipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(SwipeRight)
        
        let SwipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.SwipeGesture))
        SwipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(SwipeLeft)
        
        let SwipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.SwipeGesture))
        SwipeUp.direction = UISwipeGestureRecognizer.Direction.up
        self.view.addGestureRecognizer(SwipeUp)
        
        let SwipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.SwipeGesture))
        SwipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(SwipeDown)
        
        // equal sign
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchgesture))
        self.view.addGestureRecognizer(pinch)
        
        // clear view
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(self.longpressgesture))
        self.view.addGestureRecognizer(longpress)
    }
    
   @objc func pinchgesture(sender: UIPinchGestureRecognizer){
        var result:Double?
        if sender.state == .began || sender.state == .changed {
        }
        else{
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
            //speaktext(String(result!))
            textnumber = ""
        }
    }
 
     @objc func longpressgesture(){
     text_to_display = ""
     displayinput(text_to_display)
     displayresult("")
     }
    
    @objc func SwipeGesture(sender:UIGestureRecognizer){
        if let SwipeGesture = sender as? UISwipeGestureRecognizer
        {
            switch SwipeGesture.direction
            {
            case UISwipeGestureRecognizer.Direction.right:
                op = "+"
            case UISwipeGestureRecognizer.Direction.left:
                op = "-"
            case UISwipeGestureRecognizer.Direction.up:
                op = "*"
            case UISwipeGestureRecognizer.Direction.down:
                op = "/"
            default:
                break
            }
            number1 = Double(textnumber)
            textnumber = ""
            appendsymbol(op)
            displayinput(text_to_display)
            //speaktext(op)
        }
    }
    
    @IBOutlet weak var resultview: UILabel!
    @IBOutlet weak var taplabel: UILabel!
    //@IBOutlet weak var tapview: TouchableView!
    var number1 : Double?
    var number2 : Double?
    var textnumber = ""
    var text_to_display = ""
    var op = ""
    
    var touchViews = [UITouch:TouchSpotView]()
    var counter = 0
    var flag : Int?
    let synthesizer = AVSpeechSynthesizer()
    
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
            appenddigittodisplay(counter)//Double(counter))
            appenddigittocompute(counter)
            displayinput(text_to_display)
            speaktext(String(counter))
            counter = 0
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
        taplabel.text = "Input: "+str
    }
    func displayresult(_ str: String){
        resultview.text = "Result: "+str
    }
    
    func speaktext(_ str: String){
        let utterance = AVSpeechUtterance(string: str)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
        synthesizer.stopSpeaking(at: .word)
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
/*
class TouchableView: UIView {
    var touchViews = [UITouch:TouchSpotView]()
    //var taplabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isMultipleTouchEnabled = true
        let taplabel = UILabel()
        taplabel.text = "#touches: 0"
        taplabel.font = UIFont.systemFont(ofSize: 25)
        taplabel.sizeToFit()
        taplabel.center = CGPoint(x:0,y:50)
        taplabel.textColor = UIColor.white
        addSubview(taplabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isMultipleTouchEnabled = true
    }
 }
*/
class TouchSpotView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //isMultipleTouchEnabled = true
        //fatalError("init(coder:) has not been implemented")
    }
    
    // Update the corner radius when the bounds change.
    override var bounds: CGRect {
        get { return super.bounds }
        set(newBounds) {
            super.bounds = newBounds
            layer.cornerRadius = newBounds.size.width / 2.0
        }
    }
}

