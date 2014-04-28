NoteDemo
========
An app that allows you to create, edit, and delete notes with syncing provided by iCloud.

### Architechture
There are two handlers that provide a majority of the data manipulation. These handlers are always retrieved from the NTEHandlerProvider. My thinking with this is that any one of the handler implementations can be switched out by only manipulating a few pieces of code. You could also return mock handlers for testing purposes. If iOS 8 comes with some cool new addition to core data that I want to provide in my app, I can create a new core data handler, return that from NTEHandlerProvider, and everything now uses the new handler with only minimal code change.
                    
### References
- https://devforums.apple.com/message/918284#918284 for auto scrolling text view
- http://www.objc.io/issue-10/icloud-core-data.html for iCloud and Core Data syncing
- note image used for app icon is from http://ionicons.com/

### Libraries 
- Mogenerator makes working with subclasses of NSManagedObject easier. I set up a scheme that, when built, will output updated subclasses whenever the data model is changed.
- Flurry mobile analytics to track app usage and note creation, edit, and deletion events (overkill for this demo but would be useful info had this gone into production)
- Cocoapods has been installed for the project but no libraries are being used. At the start I had originally planned to use https://github.com/iwasrobbed/RPFloatingPlaceholders but ended up not using 

### Possible Enhancements
- Handle the case when user switches between iCloud and local storage
- Allow user to turn on or off iCloud syncing from within the app
- Allow user to add media to notes
- Allow user to tag notes and search through these tags
- Allow user to search through the title or body of a note
- Much more...

