//#-hidden-code
//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  The Swift file containing the source code edited by the user of this playground book.
//
//#-end-hidden-code

/*:
 # Can you keep the balance?
 
 So below you can set mass for both weights and their distance from the pivot. The positions of weights have to be between 1 and 5, because of the finite length of the lever.
 Then you can click run code and check if there is a balance or not.
 
 Please input integer values.
 If you don't remember how to check balance, you can go back to [the previous page](@previous).
 
*/

let leftMass = /*#-editable-code*/ 2 /*#-end-editable-code*/
let leftPosition = /*#-editable-code*/ 1 /*#-end-editable-code*/
let rightMass = /*#-editable-code*/ 1 /*#-end-editable-code*/
let rightPosition = /*#-editable-code*/ 4 /*#-end-editable-code*/


//#-hidden-code
import PlaygroundSupport
import Foundation

class MessageHandler: PlaygroundRemoteLiveViewProxyDelegate {
    func remoteLiveViewProxy(
        _ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy,
        received message: PlaygroundValue
        ) {
        print("Received a message from the always-on live view", message)
    }
    
    func remoteLiveViewProxyConnectionClosed(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy) {}
}

guard let remoteView = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy else {
    fatalError("Always-on live view not configured in this page's LiveView.swift.")
}

remoteView.delegate = MessageHandler()
if leftPosition < 6 && rightPosition < 6 {
    let value = [PlaygroundValue.integer(
        leftMass
        ), .integer(
            leftPosition
        ), .integer(
            rightMass
        ), .integer(
            rightPosition
        )]
    
    remoteView.send(.array(value))
}

//#-end-hidden-code
