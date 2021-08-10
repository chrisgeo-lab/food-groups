# Food Groups 🥕
An app to help friends decide where to eat, developed with Flutter.

Have you and your friends ever spent hours and hours simply <i>deciding</i> what to eat? I know I surely have. That's where Food Groups comes in. Think of it as a match making service, but for you and your buddies dinner plans. Don't waste time figuring out where everybody <i>does</i> and <i>doesn't</i> want to eat - let Food Groups do taht for you.

## Current Progress
Currently, the app can manage sessions through a randomized four letter code. A session host presses "create", shares and shares the code with friends to join. When ready, the host can start the matchmaking process.

These interactions all take place in Firebase - each user sends and pulls data from the database when joining a session, and in the future, when selecting restaurants.

<p float="left">
  <img src="error-demo.gif" width="300"/>
  <img src="host-demo.gif" width="300"/>
</p>

The makes sure to check for errors.

<img src="user-demo.gif" width="300"/>

## Short-Term Goals
The next step is to integrate Google Places API so that <strong>real</strong> restaurants can populate in the app. I plan on using the unique identifier provided in Google Places API in order to record in Firebase how many "points" each restaurant has - once a restaurant has an equal number of points to users, the match will be announced!

## Long-Term Goals
In the future, I would like to add filters to help users with strong, general preferences (based on price, type, distance, etc.). Maybe Joey knows he only wants pizza!! 🍕

Feel free to use what I made to integrate "sessions" into your own projects!
