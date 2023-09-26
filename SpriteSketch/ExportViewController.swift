//
//  ExportViewController.swift
//  SpriteSketch
//
//  Created by Matt Blair on 7/1/19.
//  Copyright © 2019 Elsewise. All rights reserved.
//

import UIKit
import Combine


protocol ExportViewControllerDelegate: AnyObject {
    
    func exportViewController(_ exportVC: ExportViewController, didFinish: Bool, withName name: String?, size: CGSize?)
}

// TODO: move this to its own file
enum KeysForUserDefaults: String {
    
    case lastNameKey = "lastNameExported"
    
    static func counterKeyFor(name: String) -> String {
        return "\(name)CounterKey"
    }
}


class ExportViewController: UIViewController {
    
    weak var delegate: ExportViewControllerDelegate?
    var originalSize: CGSize?
    
    // Commenting these until Combine stabilizes...
    //@Published var isValidToExport: Bool = false
    //@Published var exportWidth: CGFloat = 0.0
    //@Published var exportHeight: CGFloat = 0.0
    
    var isValidToExport: Bool = false
    var exportWidth: CGFloat = 0.0
    var exportHeight: CGFloat = 0.0
    
    // TODO: but how do you know which one changed to update the calculation?
    /*
    var exportSize: AnyPublisher<CGSize?, Never> {
        return Publishers.CombineLatest($exportWidth, $exportHeight) {
            
            // TODO: guard that the aspect ratio is still correct here?
            // And that it's smaller than the original
            return nil
        }
        //.map( ) to check aspect ratio?
        .eraseToAnyPublisher()
    }
    */
    
    private var exportSubscriber: AnyCancellable?
    private var widthSubscriber: AnyCancellable?
    private var heightSubscriber: AnyCancellable?
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var exportButton: UIButton!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var counterField: UITextField!
    
    @IBOutlet weak var dimensionsLabel: UILabel!
    @IBOutlet weak var widthField: UITextField!
    @IBOutlet weak var heightField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameField.autocorrectionType = .no
        counterField.keyboardType = .numberPad
        widthField.keyboardType = .decimalPad
        heightField.keyboardType = .decimalPad
        
        if let exportSize = originalSize {
            
            //exportWidth = exportSize.width
            //exportHeight = exportSize.height
            
            // TODO: Bind to a transform, triggered by updating size?
            dimensionsLabel.text = "\(exportSize.width) by \(exportSize.height) pts"
            
            // Instead of binding these to the published vars below?
            widthField.text = "\(exportSize.width)"
            heightField.text = "\(exportSize.height)"
        }
        
        if let previousName = UserDefaults.standard.string(forKey: KeysForUserDefaults.lastNameKey.rawValue) {
            
            nameField.text = previousName
            
            // TODO: cache this value, in case the user makes an unexpected change?
            
            let key = KeysForUserDefaults.counterKeyFor(name: previousName)
            
            // defaults to 0 if it doesn't exist
            let nextCounter = UserDefaults.standard.integer(forKey:key)
            counterField.text = String(format: "%04d", nextCounter)
        }
        
        // set up bindings
        // Commenting until Combine stabilizes...
        //exportSubscriber = $isValidToExport.receive(on: DispatchQueue.main).assign(to: \.isEnabled, on: exportButton)
        
        // TODO: better way to transform from CGFloat to an optional string
        /*
        widthSubscriber = $exportWidth.receive(on: DispatchQueue.main)
            .map { (widthValue) -> String? in
                return "\(widthValue)"
            }
            .assign(to: \.text, on: widthField)
        
        heightSubscriber = $exportHeight.receive(on: DispatchQueue.main)
            .map { (heightValue) -> String? in
                return "\(heightValue)"
            }
            .assign(to: \.text, on: heightField)
        */
        
        // TODO: bind dimension label, too
        
        validateForm()
        
        nameField.becomeFirstResponder()
    }
    
    
    // MARK: - Combine Stuff
    
    func validateForm() {
        
        var nameExists: Bool = false
        var widthIsValid: Bool = false
        var heightIsValid: Bool = false
        var aspectRatioValid: Bool = true // mabye we don't need this?
        
        if let name = nameField.text, !name.isEmpty {
            nameExists = true
        }
        
        if let originalWidth = originalSize?.width, exportWidth <= originalWidth, exportWidth > 0 {
            widthIsValid = true
        }
        
        if let originalHeight = originalSize?.height, exportHeight <= originalHeight, exportHeight > 0 {
            heightIsValid = true
        }
        
        isValidToExport = nameExists && widthIsValid && heightIsValid && aspectRatioValid
        
        // TODO: show error label?
    }
    
    func updateHeightFor(width: CGFloat) {
        
        // TODO: how do you reset width without creating a loop?
        
        exportWidth = width
        
        if let oSize = originalSize {
            exportHeight = floor(width * ( oSize.height / oSize.width ))
            heightField.text = "\(exportHeight)"
        }
    }
    
    func updateWidthFor(height: CGFloat) {
        
        // how do you get the value back from the text field to the published var?
        exportHeight = height
        
        if let oSize = originalSize {
            exportWidth = floor(height * (oSize.width / oSize.height))
            // then update UI here? Can't we make UI subscribe to this?
            
            widthField.text = "\(exportWidth)"
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func handleCancel(_ sender: UIButton) {
        
        delegate?.exportViewController(self,
                                       didFinish: false,
                                       withName: nil,
                                       size: nil)
    }
    
    @IBAction func handleExport(_ sender: UIButton) {
        
        guard let name = nameField.text,
            let specifiedWidth = CGFloat(string: widthField.text),
            let specifiedHeight = CGFloat(string: heightField.text),
            let maxSize = originalSize else { return }
        
        // TODO: Validate that the aspect ratio is the same as the original rect
        
        // limit export size to original
        let exportWidth: CGFloat = min(specifiedWidth, maxSize.width)
        let exportHeight: CGFloat = min(specifiedHeight, maxSize.width)
        
        let exportSize = CGSize(width: exportWidth, height: exportHeight)
        
        UserDefaults.standard.set(name, forKey: KeysForUserDefaults.lastNameKey.rawValue)
        
        if let counterString = counterField.text,
            let counterInt = Int(counterString) {
            
            UserDefaults.standard.set(counterInt + 1,
                                      forKey: KeysForUserDefaults.counterKeyFor(name: name))
        }
        
        let imageName = "\(name)-\(counterField.text ?? "0000")"
        
        delegate?.exportViewController(self,
                                       didFinish: true,
                                       withName: imageName,
                                       size: exportSize)
    }
    
    @IBAction func handleNameChange(_ sender: UITextField) {
        validateForm()
    }
    
    @IBAction func handleWidthChange(_ sender: UITextField) {
        
        if let updatedWidth = CGFloat(string: sender.text) {
            
            //print("exportWidth: \($exportWidth)")
            exportWidth = updatedWidth
            //print("exportWidth: \($exportWidth)")
            
            updateHeightFor(width: updatedWidth)
            validateForm()
        }
    }
    
    @IBAction func handleHeightChange(_ sender: UITextField) {
        
        if let updatedHeight = CGFloat(string: sender.text) {
            updateWidthFor(height: updatedHeight)
            validateForm()
        }
    }
    
}
