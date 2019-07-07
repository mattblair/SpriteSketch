//
//  ExportViewController.swift
//  SpriteSketch
//
//  Created by Matt Blair on 7/1/19.
//  Copyright © 2019 Elsewise. All rights reserved.
//

import UIKit


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
            
            dimensionsLabel.text = "\(exportSize.width) by \(exportSize.height) pts"
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
        
        nameField.becomeFirstResponder()
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
}
