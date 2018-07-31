//
//  PJPButton.swift
//  Burmese Test Swift
//
//  Created by Phil on 31/08/2014.
//  Copyright (c) 2014 Phil. All rights reserved.
//

import Cocoa

enum PJPButtonState: Int
{
    // MARK: 
    
    case up // 0
    case down // 1
    case disabled // 2
    case hover // 3
    case hoverOn // 4
    case hoverOff // 5
    case on // 6
    case off // 7
    case none // 8
}

extension PJPButton {
    override open var intrinsicContentSize: CGSize {
        if let cell = self.cell as? PJPAutoWrapButtonCell {
            if let style = cell.buttonStyle {
                switch style {
                case .toggle:
                    var newHeight = 50
                    var newWidth = 200
                    return CGSize(width: newWidth, height: newHeight)
                default:
                    break
                }
            }
        }
        return CGSize(width: 0, height: 0)
    }
}

@IBDesignable public class PJPButton: NSButton {
    
    var oldState : PJPButtonState?
    var enteredCount : Int = 0
    
    func createTrackingArea() {
        let focusTrackingAreaOptions : NSTrackingArea.Options = [NSTrackingArea.Options.activeInActiveApp,
             NSTrackingArea.Options.mouseEnteredAndExited,
             //NSTrackingArea.Options.assumeInside,
             NSTrackingArea.Options.inVisibleRect]
        let focusTrackingArea = NSTrackingArea(rect: NSZeroRect, options: focusTrackingAreaOptions, owner: self, userInfo: nil)
        self.addTrackingArea(focusTrackingArea)
    }

    override init(frame frameRect: NSRect)
    {
        super.init(frame: frameRect)
        self.createTrackingArea()
        self.draw(CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.height))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override public func awakeFromNib() {
        self.createTrackingArea()
        if let cell = self.cell as? NSButtonCell
        {
            Swift.print("cell is: \(cell)")
        }
    }
    
    func removeTrackingAreas()
    {
        for trackingArea in self.trackingAreas
        {
            self.removeTrackingArea(trackingArea as NSTrackingArea)
        }
    }
    
    override public func draw(_ dirtyRect: NSRect)
    {
        super.draw(dirtyRect)

        // Drawing code here.
    }
 
    override public func mouseMoved(with event: NSEvent) {
        Swift.print("mouseMoved")
        
        if self.isEnabled {
            if  let cell = self.cell as? PJPAutoWrapButtonCell,
                let buttonState = cell.buttonState {
                switch buttonState {
                case .disabled:
                    return
                default:
                    break
                }
                cell.buttonState = .hover
                self.setNeedsDisplay()
            }
        }
        super.mouseMoved(with: event)
    }
    
    override public func mouseDown(with event: NSEvent)
    {
        Swift.print("mouseDown")
        
        if self.isEnabled {
            if  let cell = self.cell as? PJPAutoWrapButtonCell,
                let buttonState = cell.buttonState,
                let buttonStyle = cell.buttonStyle {
                switch buttonState
                {
                case .on:
                    switch buttonStyle
                    {
                    case .glassy:
                        cell.buttonState = .down
                    case .toggle:
                        cell.buttonState = .hoverOn
                    default:
                        break
                    }
                case .off:
                    switch buttonStyle
                    {
                    case .glassy:
                        cell.buttonState = .down
                    case .toggle:
                        cell.buttonState = .hoverOn
                    default:
                        break
                    }
                case .hover:
                    switch buttonStyle
                    {
                    case .glassy:
                        cell.buttonState = .down
                    case .toggle:
                        break
                    case .simple:
                        cell.buttonState = .down
                    default:
                        break
                    }
                case .up:
                    switch buttonStyle {
                    case .simple:
                        cell.buttonState = .down
                        
                    default:
                        break
                    }
                case .disabled:
                    return
                default:
                    break
                }
                self.setNeedsDisplay()
            }
        }
        super.mouseDown(with: event)
        self.mouseUp(with: event)
    }
    
    override public func mouseUp(with event: NSEvent)
    {
        Swift.print("mouseUp")
        if self.isEnabled
        {
            if  let cell = self.cell as? PJPAutoWrapButtonCell,
                let buttonState = cell.buttonState
            {
                switch buttonState {
                case .disabled:
                    return
                default:
                    break
                }
                if buttonState == .on
                {
                    cell.buttonState = .off
                }
                else if buttonState == .down
                {
                    cell.buttonState = .hover
                }
                self.setNeedsDisplay()
            }
        }
        super.mouseUp(with: event)
    }

    override public func mouseEntered(with event: NSEvent)
    {
        Swift.print("entered")
        if self.isEnabled
        {
            if  let cell = self.cell as? PJPAutoWrapButtonCell,
                let buttonState = cell.buttonState,
                let buttonStyle = cell.buttonStyle
            {
                switch buttonState {
                case .disabled:
                    return
                default:
                    break
                }
                switch self.enteredCount
                {
                case 0:
                    self.oldState = buttonState
                    switch buttonState
                    {
                    case .off:
                        Swift.print("Off")
                        switch buttonStyle
                        {
                        case .glassy:
                            cell.buttonState = .hover
                        case .toggle:
                            cell.buttonState = .hoverOff
                        default:
                            cell.buttonState = .hoverOff
                        }
                    case .on:
                        Swift.print("On")
                        switch buttonStyle
                        {
                        case .glassy:
                            cell.buttonState = .hover
                        case .toggle:
                            cell.buttonState = .hoverOn
                        case .simple:
                            cell.buttonState = .hover
                        default:
                            cell.buttonState = .hoverOn
                        }
                    case .hoverOn:
                        Swift.print("hoverOn")
                    case .hoverOff:
                        Swift.print("hoverOff")
                    case .up:
                        Swift.print("up")
                        switch buttonStyle
                        {
                        case .glassy:
                            cell.buttonState = .hover
                        case .toggle:
                            cell.buttonState = .hoverOff
                        default:
                            cell.buttonState = .hover
                        }
                    case .down:
                        Swift.print("down")
                    default:
                        switch buttonStyle
                        {
                        case .glassy:
                            cell.buttonState = .hover
                        case .toggle:
                            break
                        default:
                            break
                        }
                    }
                    self.enteredCount = 1
                default:
                    self.enteredCount = 0
                    switch buttonState
                    {
                    case .off:
                        switch buttonStyle
                        {
                        case .glassy:
                            cell.buttonState = .hover
                        case .toggle:
                            cell.buttonState = .hoverOff
                        default:
                            cell.buttonState = .hoverOff
                        }
                    case .on:
                        switch buttonStyle
                        {
                        case .glassy:
                            cell.buttonState = .hover
                        case .toggle:
                            cell.buttonState = .hoverOn
                        default:
                            cell.buttonState = .hoverOn
                        }
                    default:
                        switch buttonStyle
                        {
                        case .glassy:
                            cell.buttonState = .hover
                        case .toggle:
                            cell.buttonState = .hoverOn
                        case .simple:
                            cell.buttonState = .hover
                        default:
                            cell.buttonState = .hoverOn
                        }
                    }
                }
                
                self.setNeedsDisplay()
            }
        }
        super.mouseEntered(with:event)
    }
    
    override public func mouseExited(with event: NSEvent)
    {
        Swift.print("exited")
        if self.isEnabled
        {
            if let cell = self.cell as? PJPAutoWrapButtonCell,
                let buttonState = cell.buttonState,
                let buttonStyle = cell.buttonStyle
            {
                switch buttonState {
                case .disabled:
                    return
                default:
                    break
                }
                switch buttonState
                {
                case .on:
                    switch buttonStyle
                    {
                    case .glassy:
                        cell.buttonState = .down
                    case .toggle:
                        cell.buttonState = .on
                    default:
                        break
                    }
                case .off:
                    switch buttonStyle
                    {
                    case .glassy:
                        cell.buttonState = .down
                    case .toggle:
                        cell.buttonState = .off
                    default:
                        break
                    }
                case .hover, .hoverOff:
                    switch buttonStyle
                    {
                    case .glassy:
                        cell.buttonState = .up
                    case .toggle:
                        cell.buttonState = .off
                    case .simple:
                        cell.buttonState = .up
                    default:
                        break
                    }
                case .hoverOn:
                    switch buttonStyle
                    {
                    case .glassy:
                        cell.buttonState = .up
                    case .toggle:
                        cell.buttonState = .on
                    default:
                        break
                    }
                default:
                    break
                }
                self.setNeedsDisplay()
            }
            super.mouseExited(with:event)
        }
    }
    
    override public func prepareForInterfaceBuilder() {
        super .prepareForInterfaceBuilder()
    }
    
}
