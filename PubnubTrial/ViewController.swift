//
//  ViewController.swift
//  PubnubTrial
//
//  Created by Sayonsom Chanda on 12/26/16.
//  Copyright © 2016 AilienSpace. All rights reserved.
//

import UIKit
import MapKit
import PubNub
import Foundation
import CoreLocation
//import SwiftyJSON


class ViewController: UIViewController, CLLocationManagerDelegate, PNObjectEventListener {
    
    //var circle =
    
    var Creative = 7.0
    var Happy = 5.0
    var Content = 4.0
    var Motivated = 2.0
    var NegativeFeelings = 1.0
    
    var Uneasy = 8.0
    var Excited = 15.0
    var Awkward = 6.0
    var Fatigue = 10.0
    var Indifferent = 2.0
    var Focused = 10.0
    var Stressed = 3.0
    
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
        updateMyHunger()
        
        Creative = Creative*0.9901
        Happy = Happy*0.8043
        Content = Content*0.9321
        Motivated = Motivated*1.0
        NegativeFeelings = NegativeFeelings*1.1102
        
        let lifestuff = "{\"eon\":{\"Creative\": \(Creative), \"Happy\": \(Happy), \"Content\": \(Content), \"Motivated\": \(Motivated),\"Indifferent\": \(NegativeFeelings)}}"
        let message2 = JSONParseDictionary(string: lifestuff)
        LifeClient.publish(message2, toChannel: "SayonLife", withCompletion: nil)
        

    }
    
    @IBAction func hadCoffeeAct(_ sender: Any) {
        
        let nowy = Date()
        LastCoffeeTime = nowy.timeIntervalSince1970
        Uneasy = 0.74*Uneasy
        Fatigue = 0.6*Fatigue;
        Focused = 1.2*Focused;
        Stressed = 0.55*Stressed;
        
        Creative = Creative*0.9901
        Happy = Happy*0.8043
        Content = Content*0.9321
        Motivated = Motivated*1.0
        NegativeFeelings = NegativeFeelings*1.1102
        
        let lifestuff = "{\"eon\":{\"Creative\": \(Creative), \"Happy\": \(Happy), \"Content\": \(Content), \"Motivated\": \(Motivated),\"Indifferent\": \(NegativeFeelings)}}"
        let message2 = JSONParseDictionary(string: lifestuff)
        LifeClient.publish(message2, toChannel: "SayonLife", withCompletion: nil)
        
        let mystuff = "{\"eon\":{\"Uneasy\": \(Uneasy), \"Excited\": \(Excited), \"Awkward\": \(Awkward), \"Fatigue\": \(Fatigue),\"Indifferent\": \(Indifferent),\"Focused\": \(Focused),\"Stressed\": \(Stressed)}}"
        let message = JSONParseDictionary(string: mystuff)
        print(message)
        BodyClient.publish(message, toChannel: "SayonBody", withCompletion: nil)
        
    }
    
    @IBAction func hadSnackAct(_ sender: Any) {
        print("having a snack")
        
        Fatigue = Fatigue*0.9
        Focused = Focused*0.9
        
        Creative = Creative*0.9901
        Happy = Happy*0.8043
        Content = Content*0.9321
        Motivated = Motivated*1.0
        NegativeFeelings = NegativeFeelings*1.1102
        
        let lifestuff = "{\"eon\":{\"Creative\": \(Creative), \"Happy\": \(Happy), \"Content\": \(Content), \"Motivated\": \(Motivated),\"Indifferent\": \(NegativeFeelings)}}"
        let message2 = JSONParseDictionary(string: lifestuff)
        LifeClient.publish(message2, toChannel: "SayonLife", withCompletion: nil)
        
        
        let mystuff = "{\"eon\":{\"Uneasy\": \(Uneasy), \"Excited\": \(Excited), \"Awkward\": \(Awkward), \"Fatigue\": \(Fatigue),\"Indifferent\": \(Indifferent),\"Focused\": \(Focused),\"Stressed\": \(Stressed)}}"
        let message = JSONParseDictionary(string: mystuff)
        print(message)
        BodyClient.publish(message, toChannel: "SayonBody", withCompletion: nil)
    }
    
    @IBAction func hadSuccessAct(_ sender: Any) {
        
        Uneasy = 0.2*Uneasy
        Awkward = 0.5*Awkward
        Excited = 1.4*Excited
        Fatigue = 0.4*Fatigue
        Indifferent = 0.1*Indifferent
        Focused = 0.88*Focused
        Stressed = 0.66*Stressed
        
        Creative = Creative*0.9901
        Happy = Happy*0.8043
        Content = Content*0.9321
        Motivated = Motivated*1.0
        NegativeFeelings = NegativeFeelings*1.1102
        
        let lifestuff = "{\"eon\":{\"Creative\": \(Creative), \"Happy\": \(Happy), \"Content\": \(Content), \"Motivated\": \(Motivated),\"Indifferent\": \(NegativeFeelings)}}"
        let message2 = JSONParseDictionary(string: lifestuff)
        LifeClient.publish(message2, toChannel: "SayonLife", withCompletion: nil)
        
        let mystuff = "{\"eon\":{\"Uneasy\": \(Uneasy), \"Excited\": \(Excited), \"Awkward\": \(Awkward), \"Fatigue\": \(Fatigue),\"Indifferent\": \(Indifferent),\"Focused\": \(Focused),\"Stressed\": \(Stressed)}}"
        let message = JSONParseDictionary(string: mystuff)
        print(message)
        BodyClient.publish(message, toChannel: "SayonBody", withCompletion: nil)
        
    }
    
    
    @IBAction func hadDisappointment(_ sender: Any) {
        
        Uneasy = 1.2*Uneasy
        Awkward = 1.5*Awkward
        Excited = 0.4*Excited
        Fatigue = 1.4*Fatigue
        Indifferent = 0.5*Indifferent
        Focused = 0.18*Focused
        Stressed = 1.66*Stressed
        
        Creative = Creative*0.9901
        Happy = Happy*0.8043
        Content = Content*0.9321
        Motivated = Motivated*1.0
        NegativeFeelings = NegativeFeelings*1.1102
        
        let lifestuff = "{\"eon\":{\"Creative\": \(Creative), \"Happy\": \(Happy), \"Content\": \(Content), \"Motivated\": \(Motivated),\"Indifferent\": \(NegativeFeelings)}}"
        let message2 = JSONParseDictionary(string: lifestuff)
        LifeClient.publish(message2, toChannel: "SayonLife", withCompletion: nil)
        
        let mystuff = "{\"eon\":{\"Uneasy\": \(Uneasy), \"Excited\": \(Excited), \"Awkward\": \(Awkward), \"Fatigue\": \(Fatigue),\"Indifferent\": \(Indifferent),\"Focused\": \(Focused),\"Stressed\": \(Stressed)}}"
        let message = JSONParseDictionary(string: mystuff)
        print(message)
        BodyClient.publish(message, toChannel: "SayonBody", withCompletion: nil)
    }
    
    @IBAction func workInterestLevelChange(_ sender: Any) {
        
        let x = Double(workInterestLevel.value)
        
        Uneasy = 0.2*Uneasy*(1/(0.9*x))
        Awkward = 0.5*Awkward*(1/(1.1*x))
        Excited = 1.4*Excited*1.4*x
        Fatigue = 0.4*Fatigue*(1/(2*x))
        Indifferent = 0.1*Indifferent*(1/(1.3*x))
        Focused = 0.88*Focused * 2.0 * x
        Stressed = 0.66*Stressed*(1/(1.3*x))
        
        
        Creative = Creative*0.9901
        Happy = Happy*0.8043
        Content = Content*0.9321
        Motivated = Motivated*1.0
        NegativeFeelings = NegativeFeelings*1.1102
        
        let lifestuff = "{\"eon\":{\"Creative\": \(Creative), \"Happy\": \(Happy), \"Content\": \(Content), \"Motivated\": \(Motivated),\"Indifferent\": \(NegativeFeelings)}}"
        let message2 = JSONParseDictionary(string: lifestuff)
        LifeClient.publish(message2, toChannel: "SayonLife", withCompletion: nil)
        
        let mystuff = "{\"eon\":{\"Uneasy\": \(Uneasy), \"Excited\": \(Excited), \"Awkward\": \(Awkward), \"Fatigue\": \(Fatigue),\"Indifferent\": \(Indifferent),\"Focused\": \(Focused),\"Stressed\": \(Stressed)}}"
        let message = JSONParseDictionary(string: mystuff)
        print(message)
        BodyClient.publish(message, toChannel: "SayonBody", withCompletion: nil)
        
    }
    
    @IBAction func freshnessLevelChange(_ sender: Any) {
        
        let x = Double(freshnessLevel.value)
        
        Uneasy = 0.2*Uneasy*(1/(0.9*x))
        Awkward = 0.5*Awkward*(1/(1.1*x))
        Excited = 1.4*Excited*1.4*x
        Fatigue = 0.4*Fatigue*(1/(2*x))
        Indifferent = 0.1*Indifferent*(1/(1.3*x))
        Focused = 0.88*Focused * 2.0 * x
        Stressed = 0.66*Stressed*(1/(1.3*x))
        
        Creative = Creative*0.9901
        Happy = Happy*0.8043
        Content = Content*0.9321
        Motivated = Motivated*1.0
        NegativeFeelings = NegativeFeelings*1.1102
        
        let lifestuff = "{\"eon\":{\"Creative\": \(Creative), \"Happy\": \(Happy), \"Content\": \(Content), \"Motivated\": \(Motivated),\"Indifferent\": \(NegativeFeelings)}}"
        let message2 = JSONParseDictionary(string: lifestuff)
        LifeClient.publish(message2, toChannel: "SayonLife", withCompletion: nil)
        
        let mystuff = "{\"eon\":{\"Uneasy\": \(Uneasy), \"Excited\": \(Excited), \"Awkward\": \(Awkward), \"Fatigue\": \(Fatigue),\"Indifferent\": \(Indifferent),\"Focused\": \(Focused),\"Stressed\": \(Stressed)}}"
        let message = JSONParseDictionary(string: mystuff)
        print(message)
        BodyClient.publish(message, toChannel: "SayonBody", withCompletion: nil)
    }
    
    @IBAction func motivationLevelChange(_ sender: Any) {
        
        let x = Double(freshnessLevel.value)
        
        Uneasy = 0.2*Uneasy*(1/(0.9*x))
        Awkward = 0.5*Awkward*(1/(1.1*x))
        Excited = 1.4*Excited*1.4*x
        Fatigue = 0.4*Fatigue*(1/(2*x))
        Indifferent = 0.1*Indifferent*(1/(1.3*x))
        Focused = 0.88*Focused * 2.0 * x
        Stressed = 0.66*Stressed*(1/(1.3*x))
        
        Creative = Creative*0.9901
        Happy = Happy*0.8043
        Content = Content*0.9321
        Motivated = Motivated*1.0
        NegativeFeelings = NegativeFeelings*1.1102
        
        let lifestuff = "{\"eon\":{\"Creative\": \(Creative), \"Happy\": \(Happy), \"Content\": \(Content), \"Motivated\": \(Motivated),\"Indifferent\": \(NegativeFeelings)}}"
        let message2 = JSONParseDictionary(string: lifestuff)
        LifeClient.publish(message2, toChannel: "SayonLife", withCompletion: nil)
        
        let mystuff = "{\"eon\":{\"Uneasy\": \(Uneasy), \"Excited\": \(Excited), \"Awkward\": \(Awkward), \"Fatigue\": \(Fatigue),\"Indifferent\": \(Indifferent),\"Focused\": \(Focused),\"Stressed\": \(Stressed)}}"
        let message = JSONParseDictionary(string: mystuff)
        print(message)
        BodyClient.publish(message, toChannel: "SayonBody", withCompletion: nil)
        
    }
    
    @IBOutlet var badSocialInteraction: UIButton!
    
    @IBAction func badSocialInteraction(_ sender: Any) {
        
        Uneasy = Uneasy*1.8
        Focused = Focused*0.75
        Awkward = Awkward*1.44
        Stressed = Stressed*1.25
        
        Creative = Creative*0.9901
        Happy = Happy*0.8043
        Content = Content*0.9321
        Motivated = Motivated*1.0
        NegativeFeelings = NegativeFeelings*1.1102
        
        let lifestuff = "{\"eon\":{\"Creative\": \(Creative), \"Happy\": \(Happy), \"Content\": \(Content), \"Motivated\": \(Motivated),\"Indifferent\": \(NegativeFeelings)}}"
         let message2 = JSONParseDictionary(string: lifestuff)
        LifeClient.publish(message2, toChannel: "SayonLife", withCompletion: nil)
        
        
        let mystuff = "{\"eon\":{\"Uneasy\": \(Uneasy), \"Excited\": \(Excited), \"Awkward\": \(Awkward), \"Fatigue\": \(Fatigue),\"Indifferent\": \(Indifferent),\"Focused\": \(Focused),\"Stressed\": \(Stressed)}}"
        let message = JSONParseDictionary(string: mystuff)
        print(message)
        BodyClient.publish(message, toChannel: "SayonBody", withCompletion: nil)
        
    }
    
    @IBAction func goodSocialInteraction(_ sender: Any) {
        
        Uneasy = Uneasy*0.25
        Focused = Focused*0.91
        Awkward = Awkward*0.44
        Stressed = Stressed*0.25
        
        let mystuff = "{\"eon\":{\"Uneasy\": \(Uneasy), \"Excited\": \(Excited), \"Awkward\": \(Awkward), \"Fatigue\": \(Fatigue),\"Indifferent\": \(Indifferent),\"Focused\": \(Focused),\"Stressed\": \(Stressed)}}"
        let message = JSONParseDictionary(string: mystuff)
        print(message)
        BodyClient.publish(message, toChannel: "SayonBody", withCompletion: nil)
        
    }
    
    @IBAction func workOut(_ sender: Any) {
        
        let mystuff = "{\"eon\":{\"Uneasy\": \(Uneasy), \"Excited\": \(Excited), \"Awkward\": \(Awkward), \"Fatigue\": \(Fatigue),\"Indifferent\": \(Indifferent),\"Focused\": \(Focused),\"Stressed\": \(Stressed)}}"
        let message = JSONParseDictionary(string: mystuff)
        print(message)
        BodyClient.publish(message, toChannel: "SayonBody", withCompletion: nil)
        
    }
    
    @IBAction func actOfKindness(_ sender: Any) {
        
        let mystuff = "{\"eon\":{\"Uneasy\": \(Uneasy), \"Excited\": \(Excited), \"Awkward\": \(Awkward), \"Fatigue\": \(Fatigue),\"Indifferent\": \(Indifferent),\"Focused\": \(Focused),\"Stressed\": \(Stressed)}}"
        let message = JSONParseDictionary(string: mystuff)
        print(message)
        BodyClient.publish(message, toChannel: "SayonBody", withCompletion: nil)
        
    }
    
    @IBOutlet var errandsValue: UIStepper!
    
    @IBAction func errandsChange(_ sender: Any) {
     var errandsCount = errandsValue.value
    
        
        let mystuff = "{\"Uneasy\": \(Uneasy), \"Excited\": \(Excited), \"Awkward\": \(Awkward), \"Fatigue\": \(Fatigue),\"Indifferent\": \(Indifferent),\"Focused\": \(Focused),\"Stressed\": \(Stressed)}"
        let message = JSONParseDictionary(string: mystuff)
        print(message)
        BodyClient.publish(message, toChannel: "SayonBody", withCompletion: nil)
        
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
        BodyClient = PubNub.client(with: bodyconfiguration)
        SummaryClient = PubNub.client(with: summaryconfiguration)
        WorkClient = PubNub.client(with: workconfiguration)
        LifeClient = PubNub.client(with: lifeconfiguration)
        
        manager.requestWhenInUseAuthorization()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        
       // Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateMyHunger), userInfo: nil, repeats: true)
       // Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateMyCoffee), userInfo: nil, repeats: true)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print("We are trying to get the speed here")
        
        let homecood = CLLocation(latitude: 46.732966, longitude: -117.150438)
       
        
        
        if (manager.location!.speed >= 0.0) {
           // print(manager.location!.distance(from: homecood))
           // print(manager.location!.course)
           // print(manager.location!.coordinate)
           // print(manager.location!.speed)
            let weirdvar = Int(manager.location!.speed)
            //let mystuff = "{\"Sayon\": \(weirdvar)}"
            //message = JSONParseDictionary(string: mystuff)
            //SpeedTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateMySpeed), userInfo: nil, repeats: true)
        }
        
        
    }
    
    func setupData() {
        // 1. check if system can monitor regions
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            
            // 2. region data
            let title = "Home"
            let coordinate = CLLocationCoordinate2DMake(46.732966, -117.150438)
            let regionRadius = 300.0
            
            // 3. setup region
            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude,
                                                                         longitude: coordinate.longitude), radius: regionRadius, identifier: title)
            manager.startMonitoring(for: region)
            
           
        }
        else {
            print("System can't track regions")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("enter \(region.identifier)")
    }
    
    // 2. user exit region
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("exit \(region.identifier)")
    }
    

    func updateMySpeed(){
        
        let currentLocation = CLLocation(latitude:  (manager.location?.coordinate.latitude)!, longitude: (manager.location?.coordinate.longitude)!)
        
        let geoCoder = CLGeocoder ()
       /* geoCoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in // this is the last line that is being called
            var placemark : CLPlacemark!
            placemark = placemarks?[0]
            var name = placemark.addressDictionary?["Name"] as! String
            var city = placemark.addressDictionary?["City"] as! String
            var dayType = "nice"
            var nextDayType = "busy"
            var activityName = "Sex"
            var currentFeelings = "tired"
            var newString = "I'm at " + name + ", in beautiful " + city + ". I am having a " + dayType + " day today, and tomorrow's looking " + nextDayType + ". Feeling " + currentFeelings + "."
            var placeDetails = "{\"HungerStat\": \" \(newString) \"}"
            print(placeDetails)
            var whee = self.JSONParseDictionary(string: placeDetails)
            print(whee)
            self.SummaryClient.publish(whee, toChannel: "SayonSummary", withCompletion: nil)
            
        }
        */
        
        //appDelegate.client.publish(message, toChannel: "SayonIdiot", withCompletion: nil)
    }
    
    func updateMyHunger(){
        let nowy = Date()
        //TimeForPush = nowy.timeIntervalSince1970
        //print("Update Hunger---",TimeForPush)
        var hungerAmount = 100
        let timeOfMeal = "{\"eon\": {\"Hungry\": \(hungerAmount)}}"
        let message = JSONParseDictionary(string: timeOfMeal)
        print(message)
        MealClient.publish(message, toChannel: "SayonFood", withCompletion: nil)
    }
    
    func updateMyCoffee(){
        let nowy = Date()
        //TimeForPush = nowy.timeIntervalSince1970
        print("Update Coffee---",TimeForPush)
        var coffeeAmount = 100
        let timeOfCoffee = "{\"eon\": {\"Coffee\": \(coffeeAmount)}}"
        let message = JSONParseDictionary(string: timeOfCoffee)
        print(message)
        CoffeeClient.publish(message, toChannel: "SayonCoffee", withCompletion: nil)
    
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}



