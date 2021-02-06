//
//  AnimationDelegate.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 29/09/1399 AP.
//

import QuartzCore
import UIKit

internal class AnimationDelegate: NSObject {
    let pulseLayer: PulseLayer
    let startBlock: Pulse.StartClosure? = nil
    let stopBlock: Pulse.StopClosure? = nil
    
    init(pulseLayer: PulseLayer) {
        self.pulseLayer = pulseLayer
    }
}

extension AnimationDelegate: CAAnimationDelegate {
    func animationDidStart(_ animation: CAAnimation) {
        if let startBlock = self.startBlock {
            startBlock(animation.duration)
        }
    }
    
    func animationDidStop(_ animation: CAAnimation, finished: Bool) {
        guard var pulseLayers = self.pulseLayer.superlayer?.pulseLayers else {
            return
        }
        if let index = pulseLayers.firstIndex(of: self.pulseLayer) {
            pulseLayers.remove(at: index)
            self.pulseLayer.removeFromSuperlayer()
            if let stopBlock = self.stopBlock {
                stopBlock(finished)
            }
        }
    }
}
