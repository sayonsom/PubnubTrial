//
//  ViewController.swift
//  PubnubTrial
//
//  Created by Sayonsom Chanda on 12/26/16.
//  Copyright © 2016 AilienSpace. All rights reserved.
//

import UIKit
import PubNub
import Foundation
import CoreLocation
//import SwiftyJSON


class ViewController: UIViewController, CLLocationManagerDelegate, PNObjectEventListener {
    
    
    var foodconfiguration = PNConfiguration(publishKey: "pub-c-8795f6ae-c14f-439b-b915-dcda27989140", subscribeKey: "sub-c-466a23f8-cc97-11e6-b045-02ee2ddab7fe")
    var coffeeconfiguration = PNConfiguration(publishKey: "pub-c-de36cb80-5683-43b0-acb4-90a58da01463", subscribeKey: "sub-c-97de0702-ccd5-11e6-bbe2-02ee2ddab7fe")
    var workconfiguration = PNConfiguration(publishKey: "pub-c-db618dd4-5b41-4b3d-8a9e-acd3691ac144", subscribeKey: "sub-c-a04fa3b4-ccd5-11e6-bbe2-02ee2ddab7fe")
    var lifeconfiguration = PNConfiguration(publishKey: "pub-c-2c903a2a-1cfe-4c23-9d74-8ac4a2edbf91", subscribeKey: "sub-c-ada5e2ee-ccd5-11e6-add0-02ee2ddab7fe")
    var bodyconfiguration = PNConfiguration(publishKey: "pub-c-328a0007-a7e8-4ecd-8c7b-bb6dd78e9286", subscribeKey: "sub-c-d7048450-ccd6-11e6-add0-02ee2ddab7fe")
    var summaryconfiguration = PNConfiguration(publishKey: "pub-c-4f10bf50-b2f4-4b50-b494-36d33a11dc4a", subscribeKey: "sub-c-bffbc09e-ccd5-11e6-b045-02ee2ddab7fe")
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var MealClient: PubNub!
    var CoffeeClient: PubNub!
    var WorkClient: PubNub!
    var LifeClient: PubNub!
    var BodyClient: PubNub!
    var SummaryClient: PubNub!
    
    @IBOutlet var hadMeal: UIButton!
    @IBOutlet var hadCoffee: UIButton!
    @IBOutlet var hadSnack: UIButton!
    @IBOutlet var hadSuccess: UIButton!
    @IBOutlet var hadDisappointment: UIButton!
    @IBOutlet var workInterestLevel: UISlider!
    @IBOutlet var freshnessLevel: UISlider!
    @IBOutlet var motivationLevel: UISlider!
    
    var SpeedTimer: Timer!
    var HungerTimer: Timer!
    var CaffeineTimer: Timer!
    var MoodTimer: Timer!
    var LastMealTime = 1482906764.0
    var LastCoffeeTime = 1482908000.0
    var TimeForPush : Double!
    var now = Date()
    
    @IBAction func hadMealAct(_ sender: Any) {
        
        var nowy = Date()
        LastMealTime = nowy.timeIntervalSince1970
        var fiveMinutesFromNow = Date(timeIntervalSinceNow: 2 * 60)
        let delegate = UIApplication.shared.delegate as? AppDelegate
        delegate?.scheduleNotification(at: fiveMinutesFromNow)

    }
    
    @IBAction func hadCoffeeAct(_ sender: Any) {
        
        let nowy = Date()
        LastCoffeeTime = nowy.timeIntervalSince1970
    }
    
    @IBAction func hadSnackAct(_ sender: Any) {
    }
    
    @IBAction func hadSuccessAct(_ sender: Any) {
    }
    
    
    @IBAction func hadDisappointment(_ sender: Any) {
    }
    
    @IBAction func workInterestLevelChange(_ sender: Any) {
        
    }
    
    @IBAction func freshnessLevelChange(_ sender: Any) {
    }
    
    @IBAction func motivationLevelChange(_ sender: Any) {
    }
    
    func fetch(_ completion: () -> Void) {
        
        completion()
    }
    
    func updateUI() {
        updateMyHunger()
        updateMyCoffee()
    }
    
    
    //let date = Date()
    //let calendar = Calendar.current
    
   
    
    var message : [String:AnyObject] = ["eon":3 as AnyObject]
    let manager = CLLocationManager()
    //var currentSpeed = 0.0
    
    
    
    @IBOutlet var pubText: UITextField!
    @IBOutlet var subText: UILabel!
    
    @IBAction func publishMessage(_ sender: Any) {
        print(self.pubText.text ?? "nothing")
        let weirdvar = Int(self.pubText.text!)!
        let mystuff = "{\"eon\": {\"Sayon\": \(weirdvar)}}"
        let message = JSONParseDictionary(string: mystuff)

        //appDelegate.client.publish(message, toChannel: "SayonIdiot", withCompletion: nil)
    }
    
    func JSONParseDictionary(string: String) -> [String: AnyObject]{
        
        
        if let data = string.data(using: String.Encoding.utf8){
            
            do{
                if let dictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: AnyObject]{
                    
                    return dictionary
                    
                }
            }catch {
                
                print("error")
            }
        }
        return [String: AnyObject]()
    }


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let hour = calendar.component(.hour, from: date)
        //let minutes = calendar.component(.minute, from: date)
        //let seconds = calendar.component(.second, from: date)
        //print("hours = \(hour):\(minutes):\(seconds)")
        
        
        // Do any additional setup after loading the view, typically from a nib.
        print("OK!")
        appDelegate.client.add(self)
        
        foodconfiguration = PNConfiguration(publishKey: "pub-c-8795f6ae-c14f-439b-b915-dcda27989140", subscribeKey: "sub-c-466a23f8-cc97-11e6-b045-02ee2ddab7fe")
        MealClient = PubNub.client(with: foodconfiguration)
        CoffeeClient = PubNub.client(with: coffeeconfiguration)
        
        
        manager.requestWhenInUseAuthorization()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        
        Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateMyHunger), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateMyCoffee), userInfo: nil, repeats: true)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("We are trying to get the speed here")
        print(manager.location!.speed)
        
        let weirdvar = Int(manager.location!.speed)
        let mystuff = "{\"eon\": {\"Sayon\": \(weirdvar)}}"
        message = JSONParseDictionary(string: mystuff)
        //SpeedTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(updateMySpeed), userInfo: nil, repeats: true)
        
    }

    func updateMySpeed(){
        //appDelegate.client.publish(message, toChannel: "SayonIdiot", withCompletion: nil)
    }
    
    func updateMyHunger(){
        let nowy = Date()
        TimeForPush = nowy.timeIntervalSince1970
        print("Update Hunger---",TimeForPush)
        var hungerAmount = (100.0-((TimeForPush - LastMealTime)/3600)*22.1)
        let timeOfMeal = "{\"eon\": {\"Hungry\": \(hungerAmount)}}"
        let message = JSONParseDictionary(string: timeOfMeal)
        print(message)
        MealClient.publish(message, toChannel: "SayonFood", withCompletion: nil)
    }
    
    func updateMyCoffee(){
        let nowy = Date()
        TimeForPush = nowy.timeIntervalSince1970
        print("Update Coffee---",TimeForPush)
        var coffeeAmount = (100.0-((TimeForPush - LastCoffeeTime)/3600)*33.1)
        let timeOfCoffee = "{\"eon\": {\"Coffee\": \(coffeeAmount)}}"
        let message = JSONParseDictionary(string: timeOfCoffee)
        print(message)
        CoffeeClient.publish(message, toChannel: "SayonCoffee", withCompletion: nil)
    
    }
    
    func updateMyLife(){
        let nowy = Date()
        TimeForPush = nowy.timeIntervalSince1970
        print("Update Hunger---",TimeForPush)
        var hungerAmount = ((TimeForPush - LastMealTime)/3600)*33.1
        let timeOfMeal = "{\"eon\": {\"Hungry\": \(hungerAmount)}}"
        let message = JSONParseDictionary(string: timeOfMeal)
        LifeClient.publish(message, toChannel: "SayonLife", withCompletion: nil)
        
    }
    
    func updateMyWork(){
        let nowy = Date()
        TimeForPush = nowy.timeIntervalSince1970
        print("Update Hunger---",TimeForPush)
        var hungerAmount = ((TimeForPush - LastMealTime)/3600)*33.1
        let timeOfMeal = "{\"eon\": {\"Hungry\": \(hungerAmount)}}"
        let message = JSONParseDictionary(string: timeOfMeal)
        WorkClient.publish(message, toChannel: "SayonWork", withCompletion: nil)
        
    }
    
    func updateMyBody(){
        let nowy = Date()
        TimeForPush = nowy.timeIntervalSince1970
        print("Update Hunger---",TimeForPush)
        var hungerAmount = ((TimeForPush - LastMealTime)/3600)*33.1
        let timeOfMeal = "{\"eon\": {\"Hungry\": \(hungerAmount)}}"
        let message = JSONParseDictionary(string: timeOfMeal)
        BodyClient.publish(message, toChannel: "SayonBody", withCompletion: nil)
        
    }
    
    func updateMySummary(){
        let nowy = Date()
        TimeForPush = nowy.timeIntervalSince1970
        print("Update Hunger---",TimeForPush)
        var hungerAmount = ((TimeForPush - LastMealTime)/3600)*33.1
        let timeOfMeal = "{\"eon\": {\"Hungry\": \(hungerAmount)}}"
        let message = JSONParseDictionary(string: timeOfMeal)
        SummaryClient.publish(message, toChannel: "SayonSummary", withCompletion: nil)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

