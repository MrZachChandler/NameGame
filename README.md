# NameGame

# Dependencies

Unless there is an explicit reason for having `Spruce.framework` in the top
level, I'd put it in the Podfile and let them manage the framework to keep the
file structure and project navigator clean.

`AlamofireImage` and `SwiftyJSON` should have minimum versions specified in
the pod file.

# README

READMEs are always a good idea, if for no other reason to remind yourself how
to setup an old project when you come back to it later.

[iOS README Practices](https://github.com/futurice/ios-good-practices/blob/master/README.md)

[iOS README Boilerplate](https://gist.github.com/PurpleBooth/109311bb0361f32d87a2)

# File System

Although XCode kind of takes care of the filesystem with groups, I think
its better to mirror the XCode groups as filesystem directories so what you see in the
XCode navigator matches the folder structure and whats on GitHub.

## xibs

`.xib` files should be in the Base.lproj folder. This makes it easier to
localize applications to other languages.

I'd switch to storyboards instead of xibs for view controllers, they make it
much easier to build multiview apps and are the accepted standard these days
for view controllers.

I'd also look into [ibinspectable-ibdesignable](http://nshipster.com/ibinspectable-ibdesignable/).
It's hard to get it working fluidly, but once you do it makes building
reusable UI components much easier. I can share some code with you that I wrote
recelty for making IBDesignable classes with an associated Xib.

# Logic Tests

The NameGame class is pretty complex and doesn't have any logic tests. I
imagine they'll probably want to see you have some experience with XCTest or
some other testing framework for building models.

# UI Tests

Probably not a huge deal for this kind of project, but another one of those
things I bet they'd like to see is some UI tests with something like
[XCUITest](https://developer.apple.com/library/content/documentation/DeveloperTools/Conceptual/testing_with_xcode/chapters/09-ui_testing.html).

[Apple Docs on Testing](https://developer.apple.com/library/content/documentation/DeveloperTools/Conceptual/testing_with_xcode/chapters/04-writing_tests.html#//apple_ref/doc/uid/TP40014132-CH4-SW1)

# Documentation

I'd document all:
* functions
* instance variables
* classes
* structs

Another one of those if for no other reason so you can come back to some random
thing and know whats going on and where you left off.

XCode Quickhelp can autorender documentation too. If you open the left panel
and click the ? circle and then click a function name or variable it will
show the docs for it.

plus jazzy relies on that so if you end up publishing something, you'd never
have to do much to publish your docs too.

# Code

## Interfaces

implementing all protocols in the main body of classes makes them ugly, plus
moving all the `UICollectionViewDataSource` and
`UICollectionViewDelegateFlowLayout` code to their own extensions keeps stuff
organized.

```swift
class GameViewController: ChandlerViewController, UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout {
```

to

```swift
class GameViewController: ChandlerViewController {
  ...
}

// MARK: Collection View Data Source functions
extension GameViewController: UICollectionViewDataSource {
  ...
}

// MARK: Collection View Delegate functions
extension GameViewController: UICollectionViewDelegateFlowLayout {
  ...
}
```

## `ChandlerViewController`

The name of this class should probably be something more like
`AnimationViewController`

## `ChandlerNavigationController`

since you're just adding some functionality to `UINavigationController`, why
not just use and extension?

## MenuViewController

### Instance members

There are a lot of view instances owned by this controller, this is a good use
case for IBDesignables where you could put the buttons in their own xib/view
and same with the labels to then just have 3 subviews owned by the controller.

### IBActions

The IBActions all do the exact same thing. i'd refactor it to this:

```swift
func startGame (mode: Int) {
    let firstRound = NameGame.sharedInstance.loadNextRound(mode: mode)

    let gameVC = GameViewController(nibName: "GameViewController", bundle: nil,round: firstRound, animations: [.slide(.down, .severely), .fadeIn], mode: mode)
    let gameNav = ChandlerNavigationController(rootViewController: gameVC)

    self.view.window?.rootViewController = gameNav
}

@IBAction func NameGameNormal (_ sender: AnyObject) {
    startGame(mode: NORMAL)
}
```
