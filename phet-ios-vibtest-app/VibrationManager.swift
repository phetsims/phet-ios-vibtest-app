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
    
    // CONSTANTS
    // a vibration can either be continuous or transient in the simulation request
    static let CONTINUOUS = "CONTINUOUS";
    static let TRANSIENT = "TRANSIENT";
    
    // Create an intensity parameter:
    let on_intensity = CHHapticEventParameter(parameterID: .hapticIntensity,
                                           value: 1.0)
    
    let off_intensity = CHHapticEventParameter(parameterID: .hapticIntensity,
                                            value: 0.0)

    // Create a sharpness parameter:
    let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness,
                                           value: 0.5)
    
    var engine: CHHapticEngine!
    var initialized = false;
    
    // the player while a vibration is active, if dynamic parameters are changed they are sent to this
    var activePlayer: CHHapticAdvancedPatternPlayer!
    
    var activeIntensity = 1.0;
    var activeSharpness = 1.0
    
    private func init_engine(){
        do {
            
            // only start the haptic engine once for the lifetime of the application
            if ( !initialized ) {
                initialized = true;
                engine = try CHHapticEngine()
            }
            try self.engine.start()
        } catch let error {
            fatalError("Engine Creation Error: \(error)")
        }
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
                    
                    timer.invalidate();
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
                    
                     timer.invalidate();
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
                    timer.invalidate();
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
        init_engine();
        
        // if atTime is 0 (or value less than player's time)
        // vibration stops immediately
        self.stopAndClearPlayer();
        
         let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness,
                                                value: 1.0)
        
         let continuousEvent = CHHapticEvent(eventType: .hapticContinuous,
                                             parameters: [on_intensity, sharpness],
                                             relativeTime: 0.0,
                                             duration: seconds )
         
         do {
             // Create a pattern from the continuous haptic event.
             let pattern = try CHHapticPattern(events: [continuousEvent], parameters: [])
             
             // Create a player from the continuous haptic pattern.
            self.activePlayer = try engine.makeAdvancedPlayer(with: pattern)
             
            self.activePlayer.loopEnabled = true
            try self.activePlayer.start(atTime: 0)
             
             Timer.scheduledTimer(withTimeInterval: seconds, repeats: true) { timer in
                 if !loopForever {
                    if ( self.activePlayer != nil ) {
                        self.activePlayer.loopEnabled = false
                        do {
                            try self.activePlayer.stop( atTime: 0 );
                            self.stop();
                            self.activePlayer = nil;
                        }
                        catch {
                            print( "player stop error" );
                        }
                    }
                    
                    // stop running this timer
                    timer.invalidate();
                 }
             }
             
         } catch let error {
             print("Pattern Player Creation Error: \(error)")
         }
     }
    
    // A single function that can trigger vibrations with provided parameters.
    // If duration is nil, we will vibrate forever.
    // If the vibrationPattern is an empty array, we will continuously vibrate with no off time
    // If the frequency is nil, we will will vibrate with full motor strength, no down time
    public func vibrateContinuous( duration: Double? = nil,
                               intensity: Double = 1.0,
                               sharpness: Double = 1.0,
                               frequency: Double? = nil,
                               vibrationPattern: [Double] = []
                              ) {
        init_engine();
        
        // if duration is nil, we will loop this pattern forever
        let loopForever = duration == nil;
        
        print( "starting vibration" );
        
        // parameters for the CHHapticEvent
        let sharpnessParameter = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(sharpness) );
        
        // setting a new vibration, set the relative intensity so that the intensity
        // changes relative to the intensity requested in this vibrateContinuous request
        self.activeIntensity = 1;
        self.activeSharpness = 1;
        let onIntensityParameter = CHHapticEventParameter(parameterID: .hapticIntensity,
                                                          value: Float(intensity) );
        
        if ( vibrationPattern.count > 0 ) {
            
            // there is some pattern specified so we will sequence the motor on/off
            let offIntensityParameter = CHHapticEventParameter(parameterID: .hapticIntensity,
                                                               value: 0.0 );
            
            // in seconds, time from the beginning of vibration for each CHHapticEvent in the
            // pattern sequence
            var relativeTime = 0.0;
            var hapticEvents: [CHHapticEvent] = [];
            
            for ( index, element ) in vibrationPattern.enumerated() {
                let isEven: Bool = index % 2 == 0;
                var intensityParameter: CHHapticEventParameter;
                if ( isEven ) {
                    intensityParameter = onIntensityParameter
                }
                else {
                    intensityParameter = offIntensityParameter;
                }
                hapticEvents.append( CHHapticEvent(
                                        eventType: .hapticContinuous,
                                        parameters: [intensityParameter, sharpnessParameter],
                                        relativeTime: relativeTime,
                                        duration: element
                ) );
                
                relativeTime += element;
            }
            
            var pattern: CHHapticPattern;
            do {
               pattern = try CHHapticPattern(events: hapticEvents, parameters: [])
                
                // Create a player from the continuous haptic pattern.
                self.activePlayer = try engine.makeAdvancedPlayer(with: pattern)
                
                self.activePlayer.loopEnabled = true
                try self.activePlayer.start(atTime: 0)
                
                // relativeTime is now the sum of vibrationPattern, and is the default interval
                // if we are looping forever
                let timerInterval = duration ?? relativeTime;
                
                Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { timer in
                    if !loopForever {
                        if ( self.activePlayer != nil ) {
                            self.activePlayer.loopEnabled = false
                            
                            do {
                                try self.activePlayer.stop( atTime: 0 );
                                self.stop();
                                self.activePlayer = nil;
                            }
                            catch {
                                print( "player stop error" );
                            }
                        }
                        
                        // stop this timer from further iterations
                        timer.invalidate();
                    }
                }
            }
            catch {
                print("Pattern Creation Error: \(error)")
            }
        }
        else {
            
            // no custom pattern, just vibrate continuously with the provided parameters
            do {
                
                let vibrationDuration = duration ?? 3;
                
                let vibrationEvent = CHHapticEvent(
                        eventType: .hapticContinuous,
                        parameters: [onIntensityParameter, sharpnessParameter],
                        relativeTime: 0.0,
                        duration: vibrationDuration
                )
                
                // Create a pattern from the continuous haptic event.
                let pattern = try CHHapticPattern(events: [vibrationEvent], parameters: []);
                
                // Create a player from the continuous haptic pattern.
                self.activePlayer = try engine.makeAdvancedPlayer(with: pattern)
                
                self.activePlayer.loopEnabled = true
                try self.activePlayer.start(atTime: 0)
                
                Timer.scheduledTimer(withTimeInterval: vibrationDuration, repeats: true) { timer in
                    if !loopForever {
                       if ( self.activePlayer != nil ) {
                           self.activePlayer.loopEnabled = false
                           do {
                               try self.activePlayer.stop( atTime: 0 );
                               self.stop();
                               self.activePlayer = nil;
                           }
                           catch {
                               print( "player stop error" );
                           }
                       }
                       
                       // stop running this timer
                       timer.invalidate();
                    }
                }
                
            } catch let error {
                print("Pattern Player Creation Error: \(error)")
            }
        }
    }
    
    public func vibrateTransient( intensity: Double = 1.0, sharpness: Double = 1.0 ) {
        init_engine();
        
        do {
            // parameters for the CHHapticEvent
            let sharpnessParameter = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(sharpness) );
            
            let onIntensityParameter = CHHapticEventParameter(parameterID: .hapticIntensity,
                                                              value: Float(intensity) );
        
            let vibrationEvent = CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [onIntensityParameter, sharpnessParameter],
                    relativeTime: 0.0
            )
            
            let pattern = try CHHapticPattern(events: [vibrationEvent], parameters: []);
            self.activePlayer = try engine.makeAdvancedPlayer(with: pattern)
            try self.activePlayer.start(atTime: 0)
        }
        catch {
            print("Transient haptic error: \(error)")
        }

    }
    
    public func vibrateAtFrequencyForever(frequency: Double, intensity: Double){
        vibrateAtFrequency(frequency: frequency, seconds: 300, loopForever: true, intensity: intensity)
     }
     
    public func vibrateAtFrequency(seconds: Double, frequency: Double, intensity: Double){
        vibrateAtFrequency(frequency: frequency, seconds: seconds, loopForever: false, intensity: intensity)
     }
    
    public func vibrateAtFrequency(frequency: Double, seconds: Double, loopForever: Bool, intensity: Double){
         
        init_engine()
        
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness,
                                               value: 1.0)
        self.activeIntensity = self.clampIntensity(intensity: 1);
        let intensityParam = CHHapticEventParameter( parameterID: .hapticIntensity, value: Float(self.activeIntensity))
        
        var c1: CHHapticEvent
        var c2: CHHapticEvent
        var pattern: CHHapticPattern
        
        c1 = CHHapticEvent(eventType: .hapticTransient,
        parameters: [intensityParam, sharpness],
        relativeTime: 0.0,
        duration: 1/frequency)
    
        pattern = try! CHHapticPattern(events: [c1], parameters: [])
            
        if frequency <= 15 {
            
            c1 = CHHapticEvent(eventType: .hapticContinuous,
                                             parameters: [intensityParam, sharpness],
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
            self.activePlayer = try engine.makeAdvancedPlayer(with: pattern)
             
            self.activePlayer.loopEnabled = true
            try self.activePlayer.start(atTime: 0)
             
             Timer.scheduledTimer(withTimeInterval: seconds, repeats: true) { timer in
                 if !loopForever {
                    self.activePlayer.loopEnabled = false
                    
                    // stop this timer from running any more iterations
                    timer.invalidate();
                 }
             }
             
         } catch let error {
             print("Pattern Player Creation Error: \(error)")
         }
    }
    
    /**
     * Make sure that the intensity is between (0, 1] - it must be greater than zero because dynamic intensity parameters multiply when setting new
     * value, and so we cannot divide by zero when calculating new resultant intensity. Intensity of 0.001 is not detectable.
     */
    private func clampIntensity( intensity: Double ) -> Double {
        return min( max( intensity, 0.0001 ), 1 );
    }
    
    public func vibrateWithCustomPattern( vibrationPattern: [Double], seconds: Double, loopForever: Bool ){
        
        init_engine()
        
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)

        var relativeTime = 0.0; // in seconds
        var hapticEvents: [CHHapticEvent] = [];
        
        for ( index, element ) in vibrationPattern.enumerated() {
            let isEven: Bool = index % 2 == 0;
            var intensity: CHHapticEventParameter;
            if ( isEven ) {
                intensity = on_intensity
            }
            else {
                intensity = off_intensity;
            }
            hapticEvents.append( CHHapticEvent(  eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: relativeTime, duration: element ) );
            
            relativeTime += element;
        }
        
        var pattern: CHHapticPattern;
        do {
           pattern = try CHHapticPattern(events: hapticEvents, parameters: [])
            
            // Create a player from the continuous haptic pattern.
            self.activePlayer = try engine.makeAdvancedPlayer(with: pattern)
            
            self.activePlayer.loopEnabled = true
            try self.activePlayer.start(atTime: 0)
            
            Timer.scheduledTimer(withTimeInterval: seconds, repeats: true) { timer in
                if !loopForever {
                    if ( self.activePlayer != nil ) {
                        self.activePlayer.loopEnabled = false
                        
                        do {
                            try self.activePlayer.stop( atTime: 0 );
                            self.stop();
                            self.activePlayer = nil;
                        }
                        catch {
                            print( "player stop error" );
                        }
                    }
                    
                    // stop this timer from further iterations
                    timer.invalidate();
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
    
    // Sets the intensity of vibration for the active player
    public func setVibrationIntensity( intensity: Double ) {
        let proposedIntensity = self.clampIntensity(intensity: intensity);
        
        // the resultant intensity for the pattern is the MULTIPLE of the original value (when first created) and
        // new value - we want to set the absolute intensity from 0 to 1 for our API, so this
        // is the intensity required to have the resultant intensity equal to the value provided
        let intensityValue = proposedIntensity / self.activeIntensity;
        
        print( "value: \(self.activeIntensity * intensityValue)" )
        
        
        let intensityParameter = CHHapticDynamicParameter( parameterID: .hapticIntensityControl, value: Float(intensityValue), relativeTime: 0)
        
        if ( self.activePlayer != nil ) {
            do {
                print( "intensity: \(self.activeIntensity)" );
                try self.activePlayer.sendParameters( [ intensityParameter ], atTime: 0 );
                print( "value: \(proposedIntensity)" )
            }
            catch let error {
                print( "Error setting dynamic intensity: \(error)")
            }
        }
    }
    
    public func setVibrationSharpness( sharpness: Double ) {
        
        // Sending a dynamic parameter for sharpness will ADD the dynamic value to the
        // value of the ORIGINAL pattern! Note, that is not the current pattern, but the
        // pattern requested on initial vibration
        let valueToSend = sharpness - self.activeSharpness;
        
        let sharpnessParameter = CHHapticDynamicParameter( parameterID: .hapticSharpnessControl, value: Float(valueToSend), relativeTime: 0)
        
        if ( self.activePlayer != nil ) {
            do {
                print( "sharpness: \(sharpness)" );
                try self.activePlayer.sendParameters( [ sharpnessParameter ], atTime: 0 );
            }
            catch let error {
                print( "Error setting dynamic sharpnes: \(error)")
            }
        }
    }
    
    public func stop() {
        if engine != nil{
            engine.stop()
        }
        
    }
    
    // Try to stop the activePlayer vibration immediately. I don't
    // fully understand why this the above would work while this
    // is what is needed - no op if the activePlayer isn't defined
    public func stopAndClearPlayer() {
        if ( self.activePlayer != nil ) {
            do {
                // stopping at time = 0 will stop the play immediately
                try self.activePlayer.stop( atTime: 0 );
                //self.stop();
                self.activePlayer = nil;
            }
            catch {
                print( "player stop error" );
            }
        }
    }
}
