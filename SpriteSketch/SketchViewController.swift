//
//  SketchViewController.swift
//  SpriteSketch
//
//  Created by Matt Blair on 6/28/19.
//  Copyright © 2019 Elsewise. All rights reserved.
//

import UIKit
import PencilKit


class SketchViewController: UIViewController, PKCanvasViewDelegate, PKToolPickerObserver {
    
    @IBOutlet weak var canvasView: PKCanvasView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var exportButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        canvasView.delegate = self
        canvasView.allowsFingerDrawing = true
        
        // Make the background transparent
        canvasView.isOpaque = false
        canvasView.backgroundColor = .clear
        
        // TODO: initialize from last drawing made
        canvasView.drawing = PKDrawing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Adapted from PencilKitDraw sample code's viewWillAppear
        
        if let window = view?.window, let toolPicker = PKToolPicker.shared(for: window) {
            toolPicker.setVisible(true, forFirstResponder: canvasView)
            toolPicker.addObserver(canvasView)
            toolPicker.addObserver(self)
            
            canvasView.becomeFirstResponder()
        }
    }
    
    
    // MARK: - Actions
    
    /// Save the raw drawing data for reloading
    @IBAction func handleSaveTapped(_ sender: UIButton) {
        
        print("Save Tapped")
    }
    
    /// Export the canvas to PNG
    ///
    /// This will be supplemented by a drag gesture to export a sub-rect of the canvas
    @IBAction func handleExportTapped(_ sender: UIButton) {
        
        // TODO: customize this name by prompting for a name, and adding a timestamp
        export(rect: canvasView.bounds, filename: UUID().uuidString)
    }
    
    /// Export the specified rect to a PNG file
    func export(rect: CGRect, filename: String) {
        
        let drawingImage = canvasView.drawing.image(from: rect, scale: UIScreen.main.scale)
        
        // TODO: Add the option to save elsewhere?
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let filePath = paths.first!.appendingPathComponent("\(filename).png")
        
        if let data = drawingImage.pngData() {
            do {
                try data.write(to: filePath)
            } catch {
                print("Failed to save: \(error)")
            }
        }
    }
    
    
    // MARK: - PKCanvasViewDelegate
    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        //hasModifiedDrawing = true
        print("Drawing Changed")
    }
    
    // MARK: - PKToolPickerObserver
    
    func toolPickerFramesObscuredDidChange(_ toolPicker: PKToolPicker) {
        print("Frame obscured by tools changed")
    }
    
    /// Delegate method: Note that the tool picker has become visible or hidden.
    func toolPickerVisibilityDidChange(_ toolPicker: PKToolPicker) {
        print("Tool visibility changed")
    }
}

