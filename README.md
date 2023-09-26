# SpriteSketch 

An internal tool to quickly sketch sprites with an Apple Pencil, and export them as PNGs with transparent backgrounds.

I adapted the [PencilKit](https://developer.apple.com/documentation/pencilkit) features from [Apple's source code](https://developer.apple.com/documentation/pencilkit/drawing_with_pencilkit).

### Requirements

* Xcode 11 Beta
* An iPad that supports the Apple Pencil
* An Apple Pencil

I haven't tried to test any Apple Pencil features in a simulator, but [others have](https://stackoverflow.com/questions/45451739/simulating-apple-pencil-in-the-simulator-seems-to-be-possible-somehow).

This app should work with any Apple Pencil, and doesn't use any [pencil interactions](https://developer.apple.com/documentation/uikit/pencil_interactions/) like double-tapping, which are exclusive to the second generation of the pencil.

## Initial Features

* A canvas view with a transparent background
* Draw using an Apple Pencil and all the capabilities of PencilKit
* Drag (with a finger, not the Apple Pencil) to select a rectangle for export
* Specify a name/number combination for the PNG file, and adjust the size

### Note: HIG Violation!

My use of a finger-only drag gesture to crop a section for export contradicts this part of Apple's Human Interface Guidelines for the Apple Pencil:

> **Provide a consistent Apple Pencil and finger experience.** People shouldn’t need to switch from Apple Pencil to their finger to interact with a control. If your app supports Apple Pencil for mark-making, your app’s controls should also respond to Apple Pencil. An unresponsive control causes confusion, and may give the impression of a malfunction or low battery. Likewise, drawing and writing should also work with a finger.

For my use case, it's much easier to use the pencil to draw and my finger to crop than it would be to have separate modes for drawing and editing. And I don't intend to release this app in the store. At any rate, be aware of this issue if you are using PencilKit for something similar in a consumer app.

## Roadmap

This is primarily a proof-of-concept app to take PencilKit for a spin, and scratch some of my own itches for a few unreleased projects. Given that, I hestiate to make too many promises.

Some possible features I may add, as needed:

* Handle @3x exports
* Load a template image under the canvas to trace
* Customize background and selection colors in the UI
* Save and reload raw drawing data
* Gallery to review saved images
* Group images into projects/tags
* Toggle background transparency
* Share directly from the app


## Additional Resources

* [WWDC 2019: Introducing PencilKit](https://developer.apple.com/wwdc19/221)
* The [Apple Pencil section](https://developer.apple.com/design/human-interface-guidelines/ios/user-interaction/apple-pencil/) of Apple's Human Interface Guidelines

## License

MIT