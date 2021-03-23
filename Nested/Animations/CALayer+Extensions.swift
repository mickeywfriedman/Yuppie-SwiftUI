//
//  CALayer+Extensions.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 29/09/1399 AP.
//

import QuartzCore

extension CALayer {
    public func addPulse(_ closure: ((Pulse) -> ())? = nil) -> PulseLayer {
        if self.masksToBounds == true {
            NSLog("Warning: CALayers with 'self.masksToBounds = true' might not show a pulse.")
        }
        
        let pulse = Pulse(self)
        if let closure = closure {
            closure(pulse)
        }
        
        let pulseLayer = PulseLayer(pulse: pulse)
        self.insertSublayer(pulseLayer, at:0)

        let animation = PulseLayer.pulseAnimation(from: pulse)
        animation.delegate = AnimationDelegate(pulseLayer: pulseLayer)
        pulseLayer.add(animation, forKey: PulseLayer.Constants.animationKey)
        
        self.pulseLayers.append(pulseLayer)

        return pulseLayer
    }
    
    public func removePulse(_ pulse: PulseLayer) {
        if let index = self.pulseLayers.firstIndex(where: { $0 === pulse }) {
            pulse.removeAllAnimations()
            pulse.removeFromSuperlayer()
            self.pulseLayers.remove(at: index)
        }
    }

    public func removePulses() {
        for pulseLayer in self.pulseLayers {
            pulseLayer.removeAllAnimations()
            pulseLayer.removeFromSuperlayer()
        }
        self.pulseLayers = []
    }
    
    var pulseLayers: [PulseLayer] {
        set {
            self.setValue(newValue, forKey: PulseLayer.Constants.layersKey)
        }
        get {
            return self.value(forKey: PulseLayer.Constants.layersKey) as? [PulseLayer] ?? []
        }
    }
}
