# Name Game Example #

My version of the Name Game. This is an example application to view my style of software development. I tried to include examples of some major programming/iOS practices like: Recursion , Inheritance, Extensions, Protocols, Views From Nib, Multi-Threading, Singletons, Core Data, Classes, Structures, CocoaPods, Linked Frameworks (Spruce), Constants, Pass-By-Value, Pass-By-Reference, URL Sessions, Object Oriented Programming. I do admit that it was rather challenging implementing this in under 8 hours. I took a couple hours longer to refactor and write this README. 

![Login View](img/ScreenShot.png)


## Getting Started

### Dependency Management

#### CocoaPods

sudo gem install cocoapods

to install the libraries and include them as part of a workspace which also holds your own project. I  [committed the installed dependencies to my repo][committing-pods], instead having each developer running `pod install` after a fresh checkout.

Note, you'll need to open the `.xcworkspace` file instead of `.xcproject`, or your code will not compile.

'pod update'

will update all pods to the newest versions permitted by the Podfile.

##### Alamofire
I used Alamofire to complete the inital http request to access your backend service. Although, for image loading I used URLSession.shared.dataTask to show I am competent using third-party dependencies or included resources from Swift.

##### SwiftyJSON
This is used as an easy way to parse the JSON returned by my Alamofire request. It greatly increases readability within my request.


#### Carthage
I recently built an app out of hope that someone at WillowTreeApps would notice, I had added Spruce to my Carthage file before that project and when I was linking the frankwork I copied the framework to my project. This makes the Spruce package appear in Xcode, this is not the correct way to add it, but due to time I left it in the project. Consequently, it impacts my built time becauce it has to create the binary. Luckily, Spruce is already light weight.

##### Spruce
I used the Spruce example project to create an AnimationViewController, which is inherited by my GameViewCrontrller. This spruces up the transition between rounds and gives a better experience that user is progressing forward in the game even through they are staying on the same screen.

## Project Structure

![Login View](img/NameGameModel.png)

### MVVM/MVC

I used a MVVM Design Pattern in mind when constructing this project. Although, my GameViewController does not technically own my NameGame class(the ViewModel). The NameGame class is a Singleton becuase it supplies not only GameViewController, but MenuViewController with the neccessary information to update the view. This helps decouple my codebase. I still manipulate Rounds within my GameViewController. I add the current round's Statistics, taps and time. That model manipulation is typically a MVC standard, but it has no effect on the view. At the end of each round, I append the round to the shared instance of NameGame.  

At the start of each round, I load the next round from FaceGame to prepare. My original idea was to start loading the images for the next in the background during the current round so each round would be preloaded and ready to view. I did not implement this feature due to time, but would be a great way to increase user experience.

#### Modes

Modes are global constants used to translate the game type when loading rounds from NameGame and creating the view in GameViewController
*   NORMAL = 1
*   MATT = 2
*   REVERSE = 3
*   TEAM = 4
*   HINT = 5
*   FIFTY = 6
    * This mode is used for my own idea for a game type, where you have one guess and a 50/50 chance.

#### NameGame

##### Instance Variables

*   static sharedInstance = NameGame()
    *   Creation of the Singleton object
*   people: [Person] = []
    *   Source of all the people in the company with valid information: loaded from Alamofire request
*   matt: [Person] = []
    *   Source of all the people in the company with Mat(t) in their first name: loaded from Alamofire request
*   team: [Person] = []
    *   Source of all the people in the company with valid job title: loaded from Alamofire request
*   rounds: [Round] = []
    * List of the rounds during a current game, destroyed at the end of the game to create statistics
*   completedLoad = false
    * Boolean value used to determine when the data from server has finished loading
*   statistics = Statistics()
    * The NameGame's lifetime running statistics of the player

##### Functions
*   fileprivate override init()
    * calls super for NSObject and calls getDataFromCoreData()
*   func getGameData(completion: @escaping (_ result: Bool) -> Void)
    * Returns: bool based off of success of the request.
    * Uses Alamofire to load the data from the Willow Tree API 
*   func addRound(round:Round)
    * appends a round to the array of Rounds
*   func loadNextRound(mode: Int) -> Round
    * Param: MODE
    * Returns: The next round for the view
    * Uses MODE to determine the source of people for the round, then chooses random people from the source and calls func noDuplicatePeople(indexArray, testIndex ,source)
*   func noDuplicatePeople(indexArray: [Int], testIndex:Int ,source:[Person])->Int
    * Param: indexArray to be tested, the int to be tested, and source of people to find the count
    * Returns: an int that is unique
    * This is a recursive function that if the testIndex equals another element in the indexArray, it makes a recursive call on a subArray of the indexArray. The subArray is created by every loop iteration it adds a new element from the indexArray that has been checked already. If a match occurs the subArray is used so that the function that made the nested call does not reiterate over already checked elements. In case the newTestInt matches elements of the subArray further nested calls are made. Each nested call shrinks the problem size down so that upon the return it only has the remaining members of the indexArray to check.  












