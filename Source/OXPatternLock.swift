//
//  OXPatternLock.swift
//  OXPatternLock
//
//  Created by Dmitriy Azarov on 11/01/2017.
//  Copyright © 2017 http://oxozle.com. All rights reserved.
//  https://github.com/oxozle/OXPatternLock
//
//

import Foundation
import UIKit

public protocol OXPatternLockDelegate: class {
    func didPatternInput(patterLock: OXPatternLock, track: [Int])
}

@IBDesignable
open class OXPatternLock: UIControl {
    public weak var delegate: OXPatternLockDelegate?
    
    @IBInspectable
    public var dot: UIImage?
    
    @IBInspectable
    public var dotSelected: UIImage?
    
    @IBInspectable
    public var lockSize: Int = 3
    
    @IBInspectable
    public var trackLineColor: UIColor = UIColor.white
    
    @IBInspectable
    public var trackLineThikness: CGFloat = 5
    
    private var lockTrack = [Int]()
    private var lockFrames = [CGRect]()
    
    
    //MARK: Draw
    open override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.clear
        
        guard let ctx = UIGraphicsGetCurrentContext() else {return}
        guard let dot = dot else {return}
        guard let dotSelected = dotSelected else {return}

        if !lockTrack.isEmpty {
            drawTrackPath(ctx: ctx)
        }
        
        let spacing = (rect.width - (CGFloat(lockSize) * dot.size.width)) / CGFloat(lockSize + 1)
        let iconSize = dot.size
        let lockFramesSizeShouldBe = lockSize * lockSize
        
        for y in 0..<lockSize {
            for x in 0..<lockSize {
                let point = CGPoint(x: spacing + CGFloat(x) * (iconSize.width + spacing), y: spacing + CGFloat(y) * (iconSize.width + spacing))
                let dotRect = CGRect(origin: point, size: iconSize)
                if lockFrames.count < lockFramesSizeShouldBe {
                    lockFrames.append(dotRect)
                }
                
                if lockTrack.contains(x + y * lockSize) {
                    dotSelected.draw(in: dotRect)
                } else {
                    dot.draw(in: dotRect)
                }
                
            }
        }
        
        
        #if !TARGET_INTERFACE_BUILDER
            // this code will run in the app itself
        #else
            // this code will execute only in IB
        #endif
    }
    
    private func drawTrackPath(ctx: CGContext) {
        let path = UIBezierPath()
        
        for i in 0..<lockTrack.count - 1 {
            let index = lockTrack[i]
            let indexTo = lockTrack[i+1]
            let rect = lockFrames[index]
            path.move(to: CGPoint(x: rect.midX, y: rect.midY))
            
            let rectTo = lockFrames[indexTo]
            path.addLine(to: CGPoint(x: rectTo.midX, y: rectTo.midY))
        }
        
        trackLineColor.set()
        ctx.setLineWidth(trackLineThikness)
        ctx.setLineCap(.round)
        ctx.setLineJoin(.round)
        ctx.addPath(path.cgPath)
        ctx.strokePath()
    }
    
    
    //MARK: Tracking
    
    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        lockTrack.removeAll()
        let point = touch.location(in: self)
        if hitTestInLockFrames(at: point) {
            setNeedsDisplay()
        }
        return super.beginTracking(touch, with: event)
    }
    
    open override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let point = touch.location(in: self)
        if hitTestInLockFrames(at: point) {
            setNeedsDisplay()
        }
        return super.continueTracking(touch, with: event)
    }
    
    open override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        if lockTrack.count >= 2 {
            delegate?.didPatternInput(patterLock: self, track: lockTrack)
        }
        lockTrack.removeAll()
        setNeedsDisplay()
        super.endTracking(touch, with: event)
    }
    
    private func hitTestInLockFrames(at point: CGPoint) -> Bool {
        for (index, rect) in lockFrames.enumerated() {
            if rect.contains(point) {
                if !lockTrack.contains(index) {
                    lockTrack.append(index)
                    print("current lock track: \(lockTrack)")
                }
                return true
            }
        }
        
        return false
    }
}

