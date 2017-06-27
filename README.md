# Name Game Example #

My version of the Name Game. This is an example application to view my style of software development. I tried to include examples of some major programming/iOS practices like: Recursion , Inheritance, Extensions, Protocols, Views From Nib, Multi-Threading, Singletons, Core Data, Classes, Structures, CocoaPods, Linked Frameworks (Spruce), Constants, Pass-By-Value, Pass-By-Reference. I do admit that it was rather challenging implementing this in under 8 hours. I took a couple hours longer to refactor and tidy up some code. The rushed timely implicitly degrades the code quality, but regardless with proper planning and experience it should not impact the code greatly. 

![Login View](img/ScreenShot.png)


## Getting Started

### Dependency Management

#### CocoaPods

If you're planning on including external dependencies (e.g. third-party libraries) in your project, [CocoaPods][cocoapods] offers easy and fast integration. Install it like so:

sudo gem install cocoapods

To get started, move inside your iOS project folder and run

pod init

This creates a Podfile, which will hold all your dependencies in one place. After adding your dependencies to the Podfile, you run

pod install

to install the libraries and include them as part of a workspace which also holds your own project. It is generally [recommended to commit the installed dependencies to your own repo][committing-pods], instead of relying on having each developer running `pod install` after a fresh checkout.

Note that from now on, you'll need to open the `.xcworkspace` file instead of `.xcproject`, or your code will not compile. The command

pod update

will update all pods to the newest versions permitted by the Podfile. You can use a wealth of [operators][cocoapods-pod-syntax] to specify your exact version requirements.

[cocoapods]: https://cocoapods.org/
[cocoapods-pod-syntax]: http://guides.cocoapods.org/syntax/podfile.html#pod
[committing-pods]: https://www.dzombak.com/blog/2014/03/including-pods-in-source-control.html

### Project Structure

![Login View](img/NameGameModel.png)


