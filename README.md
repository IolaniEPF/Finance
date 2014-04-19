#'Iolani Economics of Personal Finance
===
This project started as part of an effort to rework the existing Economics of Personal Finance curriculum at ['Iolani School](http://www.iolani.org/).  Currently, the app functions as a virtual checkbook and achievement system for students to easily make virtual payments while remaining easy for teacher(s) to manage balances, experience points, and other relevant student information.

##Getting Started
===
###Introduction
The Finance app is written in Objective-C, and was built using Apple's Xcode IDE.  Originally built for iOS 6 on Xcode 4, the app has been transitioned over to provide iOS 7 and Xcode 5 compatibility.  For centralized database management, we use [Parse](https://parse.com), since it provides pseudorelational database capabilities and push notifications through their API.
###Dependencies and Frameworks
To interface with Parse, we use the [Parse SDK](https://parse.com/).

For beta testing and remote error logging, we use TestFlight and the [TestFlight SDK](https://testflighapp.com/).  The TestFlight platform also allows us to distribute apps to both testers and EPF students quickly with minimal effort, and it provides an easy system for testers and users to submit feedback quickly.

For processing login data and integration with [Google+](https://plus.google.com/), the Google and Google+ SDKs allow us to create sign-in buttons on the app welcome screen.  This scheme allows us to take advantage of the fact that all 'Iolani students will have a Google account, reducing the need to deal with separate accounts, password management, etc. associated with a separate database structure. **NOTE: The Google SDKs have several dependencies on built-in iOS frameworks.  As the Google SDKs are updated, the list is subject to change at any time.  The updated list of frameworks to include can be found on [Google's Developer site](https://developer.google.com/).  Google's SDKs deep-linking are not enabled in the Finance app.  As such, the Google .framework files may need to be placed in an absolute path on your hard drive.  If you receive a Mach-O linking error that references any of Google's SDKs when attempting to build, copy any necessary frameworks to ```/Users/blaketsuzaki/Development/Finance```.**
###Setting up a development machine
1. If you're reading this on [GitHub](https://github.com/), it's a safe bet that you have a GitHub account.  If not, register for one [here]()
2. Register for an Apple Developer account through the [Apple Developer Portal](http://developer.apple.com).
3. On the Mac you plan to use for development, download and install [Xcode](https://itunes.apple.com/app/id?=) from the Mac App Store.
4. Once finished, open Xcode and sign in using the Apple ID that you created a developer account with.
5. Clone the repository into the location of your choosing on your hard drive.
6. You're finished!  You should now have the tools necessary to develop, build, and run the Finance app.

###Contributing to the project
If you are not a member of the IolaniEPF organization, please fork the project, make any changes you feel are necessary, and open a pull request that best describes the changes you are making and why you feel they are necessary.
#Project overview
===
##General data structure

###User data-holding objects
The Finance app uses several types of non-primitive objects in conjunction to store data about each student.  These include ```User```s, ```Avatar```s,```Transaction```s, ```XPTransaction```s, ```Badge```s, and ```Balance```s.

Each ```User``` object represents a student and has its own ```Avatar``` and ```Balance``` objects to store profile and account balance information.  An ```Avatar``` contains references to a student's profile and background images, while ```Balance``` objects store a student's available cash balance and experience points.

A ```Transaction``` represents a payment to or from a student and will either credit or debit their account balance accordingly.  Each ```XPTransaction``` holds points received from a teacher to a student for completing a "quest" or other class assignment, with the cumulative XP total being stored as part of a student's balance.

```Balance```s contain data fields for storing a students cash balance (determined by ```Transaction```s) and XP total (determined by ```XPTransaction```s).  A ```Transaction``` contains pointers about the sender and recipient of the data, representing a debit from the sender's account and a credit to the recipient's account.  ```Transaction```s also contain data about the transaction's creator, in the event that the transaction is challenged by the student, or to note who initiated a payment/deposit.

**NOTE: ```Transaction```s and ```XPTransaction```s should *never* be modified once created.  If the Parse database receives an updated transaction from the Finance app client, it will process it like a new transaction and re-add it to a student's balance.  Instead, if transactions need to be modified or otherwise corrected, the object should be destroyed and an identical object with corrected values should be sent to Parse instead.  This preserves the integrity of a student's balance.  *Work is underway to create a Cloud Code function to automatically recalculate balances if data integrity is disrupted.***

```Badge```s are used by the teacher to reward one or more students for special occasions, achievements, or innovative thinking.  To introduce students to badges, each student receives a badge at the start of the course for successfully installing and setting up the app.