//
//  ViewController.swift
//  GestureCalculator
//
//  Created by Bindita Chaudhuri on 10/13/18.
//  Copyright © 2018 Bindita Chaudhuri. All rights reserved.
//

import UIKit
import AVFoundation
import UIKit.UIGestureRecognizerSubclass

class ViewController: UIViewController, UIGestureRecognizerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        MultiStrokeGestureRecognizer.enableMultipleStrokes = true
        MultiStrokeGestureRecognizer.allowedTimeBetweenMultipleStrokes = 0.6
        MultiStrokeGestureRecognizer.cancelsTouchesInView = false
        //MultiStrokeGestureRecognizer.addTarget(self, action: #selector(didRecognize(_:)))
        //self.view.addGestureRecognizer(MultiStrokeGestureRecognizer)
        
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
        
        /*let customtap = UICustomGestureRecognizer(target: self, action: #selector(self.singletap))
        customtap.delegate = self
        //customtap.cancelsTouchesInView = true
        //customtap.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(customtap)
        
        let customdtap = UICustomDoubleGestureRecognizer()
        customdtap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(customdtap)
        customtap.require(toFail: customdtap)*/
        
        let digit0 = UITapGestureRecognizer(target: self, action: #selector(self.digit0gesture))
        //dtap.delegate = self
        digit0.numberOfTapsRequired = 2
        digit0.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(digit0)
        
        let decimal = UITapGestureRecognizer(target: self, action: #selector(self.decimalgesture))
        decimal.numberOfTapsRequired = 2
        decimal.numberOfTouchesRequired = 2
        self.view.addGestureRecognizer(decimal)
        
        // equal sign
        let equalgesture = UILongPressGestureRecognizer(target: self, action: #selector(self.equal))
        equalgesture.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(equalgesture)
        //let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchgesture))
        //self.view.addGestureRecognizer(pinch)
        
        // backspace
        let backspacegesture = UILongPressGestureRecognizer(target: self, action: #selector(self.backspace))
        backspacegesture.numberOfTouchesRequired = 2
        self.view.addGestureRecognizer(backspacegesture)
        
        //clear view
        let clearallgesture = UILongPressGestureRecognizer(target: self, action: #selector(self.clearall))
        clearallgesture.numberOfTouchesRequired = 3
        self.view.addGestureRecognizer(clearallgesture)
    }
    
    @IBOutlet weak var resultview: UILabel!
    @IBOutlet weak var taplabel: UILabel!
    fileprivate let MultiStrokeGestureRecognizer = MultiStrokeRecognizer()
    
    var tap1 = 0
    var tap1time: Double?
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
    
    /*
    @objc func didRecognize(_ multigesturerecognizer: MultiStrokeRecognizer) {
        switch multigesturerecognizer.state {
        case .ended, .cancelled, .failed:
            updateRecognizerResult()
        default: break
        }
    }    
    private func updateRecognizerResult() {
        guard let (template, similarity) = MultiStrokeGestureRecognizer.result else {
            //recognizerResultLabel.text = "Could not recognize."
            return
        }
        let similarityString = String(format: "%.2f", similarity)
        //recognizerResultLabel.text = "Template: \(template.id), Similarity: \(similarityString)"
    }*/
    
    @objc func digit0gesture(sender:UITapGestureRecognizer){
        if (sender.state == UIGestureRecognizer.State.ended) {
            appenddigittodisplay(0)
            appenddigittocompute(0)
            displayinput(text_to_display)
            speaktext("0")
        }
    }
    
    @objc func decimalgesture(sender: UITapGestureRecognizer){
        if (sender.state == UIGestureRecognizer.State.ended) {
            text_to_display += "."
            textnumber += "."
            displayinput(text_to_display)
            //speaktext(".")
        }
    }
    
    //@objc func pinchgesture(sender: UIPinchGestureRecognizer){
    //}
    @objc func equal(sender:UILongPressGestureRecognizer) {
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
    
    @objc func backspace(sender:UILongPressGestureRecognizer) {
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
        
    @objc func clearall(sender:UILongPressGestureRecognizer) {
        if (sender.state == UIGestureRecognizer.State.ended) {
            text_to_display = ""
            displayinput(text_to_display)
            displayresult("")
        }
    }
    
    @objc func SwipeGesture(sender:UIGestureRecognizer){
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
                //    }
                //    downswipeflag = 0
                //}
                //else{
                //    op = "^"
                //}
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
                //        self.downswipeflag = 0
                //    }
                //    else{
                //        self.op = ""
                //    }
                //}
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
    }
    
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
/*
class UICustomGestureRecognizer : UITapGestureRecognizer{
    var flag : Int?
    var toPrint: Int?
    var counter = 0
    var touchViews = [UITouch:TouchSpotView]()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            counter = counter + 1
            createViewForTouch(touch: touch)
        }
        //super.touchesBegan(touches, with: event!)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let view = viewForTouch(touch: touch)
            // Move the view to the new location.
            let newLocation = touch.location(in: self.view)
            view?.center = newLocation
        }
        //super.touchesMoved(touches, with: event!)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        //taplabel.text = "Input: " + String(counter)
        for touch in touches {
            removeViewForTouch(touch: touch)
        }
        print("hello"+String(counter))
        counter = 0
        //super.touchesEnded(touches, with: event!)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            removeViewForTouch(touch: touch)
        }
        counter = 0
        //super.touchesCancelled(touches, with: event!)
    }
    
    override func reset() {
        //super.reset()
    }
    
    // Circle area (view creation)
    func createViewForTouch( touch : UITouch ) {
        let newView = TouchSpotView()
        newView.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        newView.center = touch.location(in: self.view)
        
        // Add the view and animate it to a new size.
        self.view?.addSubview(newView)
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


class UICustomDoubleGestureRecognizer : UITapGestureRecognizer{
    var flag = 0
    var counter = 0
    var touchViews = [UITouch:TouchSpotView]()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            counter = counter + 1
            createViewForTouch(touch: touch)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let view = viewForTouch(touch: touch)
            // Move the view to the new location.
            let newLocation = touch.location(in: self.view)
            view?.center = newLocation
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        //taplabel.text = "Input: " + String(counter)
        for touch in touches {
            removeViewForTouch(touch: touch)
        }
        print(String(counter))
        counter = 0
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            removeViewForTouch(touch: touch)
        }
    }
    
    // Circle area (view creation)
    func createViewForTouch( touch : UITouch ) {
        let newView = TouchSpotView()
        newView.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
        newView.center = touch.location(in: self.view)
        
        // Add the view and animate it to a new size.
        self.view?.addSubview(newView)
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
*/
