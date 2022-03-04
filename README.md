#  Time Tracker App

## How to launch
App doesn't have any dependencies. You can run on simulator right after opening project file with Xcode. To run on device, you'll need to change dev team and bundle id.
After stopping timer, there's a 2 second delay so you can edit comment.

## Structure
App consists of 3 layers:
1. View layer built on SwiftUI
2. ViewModel layer that prepares data for display and takes actions on user input.
3. Business logic layer built to satisfy single responsibility principle in order to ease unit testing.

Layers 2 and 3 are fully covered with unit tests. Dependency injection is done by means of simple Assembly classes.

