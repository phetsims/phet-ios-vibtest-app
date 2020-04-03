//
//  VibrationManager.swift
//  vibrationAPI
//
//  Created by John Pasquesi on 10/11/19.
//  Copyright © 2019 John Pasquesi. All rights reserved.
//

import Foundation
import CoreHaptics

public class VibrationManager {
    
    // Create an intensity parameter:
    let on_intensity = CHHapticEventParameter(parameterID: .hapticIntensity,
                                           value: 1.0)
    
    let off_intensity = CHHapticEventParameter(parameterID: .hapticIntensity,
                                            value: 0.0)

    // Create a sharpness parameter:
    let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness,
                                           value: 0.5)
    
    var engine: CHHapticEngine!
    
    private func init_engine(){
        do {
            engine = try CHHapticEngine()
            try self.engine.start()
        } catch let error {
            fatalError("Engine Creation Error: \(error)")
        }
    }
    
    init(){
        
    }
    
    public func quickPulse(seconds: Double){
        quickPulse(seconds: seconds, loopForever: false)
    }
    
    public func quickPulseForever(){
        quickPulse(seconds: 300, loopForever: true)
    }
   
    private func quickPulse(seconds: Double, loopForever: Bool){
        
        init_engine()
        let continuousEvent = CHHapticEvent(eventType: .hapticContinuous,
                                            parameters: [on_intensity, sharpness],
                                            relativeTime: 0.001,
                                            duration: 0.075)
        let continuousEvent2 = CHHapticEvent(eventType: .hapticContinuous,
                                             parameters: [off_intensity, sharpness],
                                             relativeTime: 0.076,
            duration: 0.025)
        
        do {
            // Create a pattern from the continuous haptic event.
            let pattern = try CHHapticPattern(events: [continuousEvent, continuousEvent2], parameters: [])
            
            // Create a player from the continuous haptic pattern.
            let continuousPlayer = try engine.makeAdvancedPlayer(with: pattern)
            
            continuousPlayer.loopEnabled = true
            try continuousPlayer.start(atTime: 0)
            
            Timer.scheduledTimer(withTimeInterval: seconds, repeats: true) { timer in
                if !loopForever {
                    continuousPlayer.loopEnabled = false
                }
            }
            
        } catch let error {
            print("Pattern Player Creation Error: \(error)")
        }
    }
    
    
     public func slowPulse(seconds: Double){
         slowPulse(seconds: seconds, loopForever: false)
     }
     
     public func slowPulseForever(){
         slowPulse(seconds: 300, loopForever: true)
     }
    
     private func slowPulse(seconds: Double, loopForever: Bool){
         
         init_engine()
         let continuousEvent = CHHapticEvent(eventType: .hapticContinuous,
                                             parameters: [on_intensity, sharpness],
                                             relativeTime: 0.001,
                                             duration: 0.050)
         let continuousEvent2 = CHHapticEvent(eventType: .hapticContinuous,
                                              parameters: [off_intensity, sharpness],
                                              relativeTime: 0.051,
             duration: 0.100)
         
         do {
             // Create a pattern from the continuous haptic event.
             let pattern = try CHHapticPattern(events: [continuousEvent, continuousEvent2], parameters: [])
             
             // Create a player from the continuous haptic pattern.
             let continuousPlayer = try engine.makeAdvancedPlayer(with: pattern)
             
             continuousPlayer.loopEnabled = true
             try continuousPlayer.start(atTime: 0)
             
             Timer.scheduledTimer(withTimeInterval: seconds, repeats: true) { timer in
                 if !loopForever {
                     continuousPlayer.loopEnabled = false
                 }
             }
             
         } catch let error {
             print("Pattern Player Creation Error: \(error)")
         }
     }
 
    
     public func rumble(seconds: Double){
         rumble(seconds: seconds, loopForever: false)
     }
     
     public func rumbleForever(){
         rumble(seconds: 300, loopForever: true)
     }
    
     private func rumble(seconds: Double, loopForever: Bool){
         
         init_engine()
        
        let rumble_sharpness = CHHapticEventParameter(parameterID: .hapticSharpness,
        value: 0.01)
        
         let continuousEvent = CHHapticEvent(eventType: .hapticContinuous,
                                             parameters: [on_intensity, rumble_sharpness],
                                             relativeTime: 0.001,
                                             duration: 0.007)
         let continuousEvent2 = CHHapticEvent(eventType: .hapticContinuous,
                                              parameters: [off_intensity, rumble_sharpness],
                                              relativeTime: 0.008,
             duration: 0.009)
         
         do {
             // Create a pattern from the continuous haptic event.
             let pattern = try CHHapticPattern(events: [continuousEvent, continuousEvent2], parameters: [])
             
             // Create a player from the continuous haptic pattern.
             let continuousPlayer = try engine.makeAdvancedPlayer(with: pattern)
             
             continuousPlayer.loopEnabled = true
             try continuousPlayer.start(atTime: 0)
             
             Timer.scheduledTimer(withTimeInterval: seconds, repeats: true) { timer in
                 if !loopForever {
                     continuousPlayer.loopEnabled = false
                 }
             }
             
         } catch let error {
             print("Pattern Player Creation Error: \(error)")
         }
     }
    
     public func knock(repetitions: Int){
         knock(repetitions: repetitions, loopForever: false)
     }
     
     public func knockOnce(){
         knock(repetitions: 1, loopForever: false)
     }
    
     public func knockForever(){
         knock(repetitions: 100, loopForever: true)
     }
    
     private func knock(repetitions: Int, loopForever: Bool){
         
         init_engine()
        
        let knock_sharpness = CHHapticEventParameter(parameterID: .hapticSharpness,
                                                     value: 1.0)
        
        let c1 = CHHapticEvent(eventType: .hapticContinuous,
                                             parameters: [off_intensity, knock_sharpness],
                                             relativeTime: 0.0,
                                             duration: 0.025)
        let c2 = CHHapticEvent(eventType: .hapticContinuous,
                                              parameters: [on_intensity, knock_sharpness],
                                              relativeTime: 0.025,
             duration: 0.075)
        let c3 = CHHapticEvent(eventType: .hapticContinuous,
                                         parameters: [off_intensity, knock_sharpness],
                                         relativeTime: 0.100,
        duration: 0.025)
        let c4 = CHHapticEvent(eventType: .hapticContinuous,
                                         parameters: [on_intensity, knock_sharpness],
                                         relativeTime: 0.125,
                                         duration: 0.075)
        let c5 = CHHapticEvent(eventType: .hapticContinuous,
                                         parameters: [off_intensity, knock_sharpness],
                                         relativeTime: 0.200,
                                         duration: 0.400)
        let c6 = CHHapticEvent(eventType: .hapticContinuous,
                                         parameters: [on_intensity, knock_sharpness],
                                         relativeTime: 0.600,
                                         duration: 0.050)
        let c7 = CHHapticEvent(eventType: .hapticContinuous,
                                         parameters: [off_intensity, knock_sharpness],
                                         relativeTime: 0.650,
                                         duration: 0.600)
        
         
         do {
             // Create a pattern from the continuous haptic event.
             let pattern = try CHHapticPattern(events: [c1, c2, c3, c4, c5, c6, c7], parameters: [])
             
             // Create a player from the continuous haptic pattern.
             let continuousPlayer = try engine.makeAdvancedPlayer(with: pattern)
             
             continuousPlayer.loopEnabled = true
             try continuousPlayer.start(atTime: 0)
             
            var times_completed = 0
            Timer.scheduledTimer(withTimeInterval: 1.250, repeats: true) { timer in
                    
                times_completed += 1
                
                if !loopForever && times_completed >= repetitions {
                        continuousPlayer.loopEnabled = false
                 }
                
                
             }
             
         } catch let error {
             print("Pattern Player Creation Error: \(error)")
         }
     }
    
     public func vibrate(seconds: Double){
        
         vibrate(seconds: seconds, loopForever: false)
     }
     
     public func vibrateForever(){
         vibrate(seconds: 2, loopForever: true)
     }
    
     public func vibrate(seconds: Double, loopForever: Bool){
         
         init_engine()
        
         let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness,
         value: 0.5)
        
         let continuousEvent = CHHapticEvent(eventType: .hapticContinuous,
                                             parameters: [on_intensity, sharpness],
                                             relativeTime: 0.0,
                                             duration: 2 )
         
         do {
             // Create a pattern from the continuous haptic event.
             let pattern = try CHHapticPattern(events: [continuousEvent], parameters: [])
             
             // Create a player from the continuous haptic pattern.
             let continuousPlayer = try engine.makeAdvancedPlayer(with: pattern)
             
             continuousPlayer.loopEnabled = true
             try continuousPlayer.start(atTime: 0)
             
             Timer.scheduledTimer(withTimeInterval: seconds, repeats: true) { timer in
                 if !loopForever {
                    continuousPlayer.loopEnabled = false
                    
                    
                    do {
                        try continuousPlayer.stop( atTime: 0 );
                        self.stop();
                    }
                    catch {
                        print( "player stop error" );
                    }
                 }
             }
             
         } catch let error {
             print("Pattern Player Creation Error: \(error)")
         }
     }
    
     public func vibrateAtFrequencyForever(frequency: Double){
        vibrateAtFrequency(frequency: frequency, seconds: 300, loopForever: true)
     }
     
    public func vibrateAtFrequency(seconds: Double, frequency: Double){
        vibrateAtFrequency(frequency: frequency, seconds: seconds, loopForever: false)
     }
    
    public func vibrateAtFrequency(frequency: Double, seconds: Double, loopForever: Bool){
         
         init_engine()
        
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness,
                                               value: 1.0)
        
        var c1: CHHapticEvent
        var c2: CHHapticEvent
        var pattern: CHHapticPattern
        
        c1 = CHHapticEvent(eventType: .hapticTransient,
        parameters: [on_intensity, sharpness],
        relativeTime: 0.0,
        duration: 1/frequency)
        
        
    
        pattern = try! CHHapticPattern(events: [c1], parameters: [])
            
        if frequency <= 15 {
            
            c1 = CHHapticEvent(eventType: .hapticContinuous,
                                             parameters: [on_intensity, sharpness],
                                             relativeTime: 0.0,
                                             duration: 0.5/frequency)
            c2 = CHHapticEvent(eventType: .hapticContinuous,
                               parameters: [off_intensity, sharpness],
                               relativeTime: 0.5/frequency,
                               duration: 0.5/frequency)
            
            do{
                pattern = try CHHapticPattern(events: [c1, c2], parameters: [])
            }
            catch let error{
                print("Pattern Error: \(error)")
            }
        }
         
         do {
             
             // Create a player from the continuous haptic pattern.
             let continuousPlayer = try engine.makeAdvancedPlayer(with: pattern)
             
             continuousPlayer.loopEnabled = true
             try continuousPlayer.start(atTime: 0)
             
             Timer.scheduledTimer(withTimeInterval: seconds, repeats: true) { timer in
                 if !loopForever {
                     continuousPlayer.loopEnabled = false
                 }
             }
             
         } catch let error {
             print("Pattern Player Creation Error: \(error)")
         }
    }
    
    public func vibrateWithCustomPattern( vibrationPattern: [Double], seconds: Double, loopForever: Bool ){
        
        init_engine()
        
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)

        var relativeTime = 0.0;
        var hapticEvents: [CHHapticEvent] = [];
        for element in vibrationPattern {
            let index: Int! = vibrationPattern.firstIndex(of: element );
            
            let isEven: Bool = index % 2 == 0;
            var intensity: CHHapticEventParameter;
            if ( isEven ) {
                intensity = on_intensity
            }
            else {
                intensity = off_intensity;
            }
            hapticEvents.append( CHHapticEvent(  eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: relativeTime, duration: element / 1000 ) );
            
            relativeTime += element / 1000;
        }
        
        var pattern: CHHapticPattern;
        do {
           pattern = try CHHapticPattern(events: hapticEvents, parameters: [])
            
            // Create a player from the continuous haptic pattern.
            let continuousPlayer = try engine.makeAdvancedPlayer(with: pattern)
            
            continuousPlayer.loopEnabled = true
            try continuousPlayer.start(atTime: 0)
            
            Timer.scheduledTimer(withTimeInterval: seconds, repeats: true) { timer in
                if !loopForever {
                   continuousPlayer.loopEnabled = false
                }
            }
        }
        catch {
            print("Pattern Creation Error: \(error)")
        }
    }
    
    func vibrateWithCustomPattern( vibrationPattern: [Double], seconds: Double ) {
        vibrateWithCustomPattern( vibrationPattern: vibrationPattern, seconds: seconds, loopForever: false );
    }
    
    func vibrateWithCustomPatternForever( vibrationPattern: [Double] ) {
        vibrateWithCustomPattern( vibrationPattern: vibrationPattern, seconds: 300, loopForever: true );
    }
    
    public func stop() {
        if engine != nil{
            engine.stop()
        }
        
    }
}
