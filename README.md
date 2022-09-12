# iOS Assignment

You are probably familiar with the Spotify service. It's the biggest music streaming platform in the world and they have a nice and well documented API that you will be using in this assignment.

We ask you to implement an iOS application that performs login and search with Spotify and some further data.
The user can be yourself or a newly set up account. Please ask us if you need help setting this up.

The app should consist of the following parts:
- ✅ Login Screen -
- ✅  Search Screen - consisting of a search bar and a list of results 
- ✅ Artist or Track page - consisting of the name, image, and 2 or more interesting fields from either an artist or a track item (note: you don't have to support both types) 

### Third party libraries
-  ✅  You are encouraged to use the Spotify SDK.
    -- This not very well maintained, but it still works with some workarounds. I have used the SDK for the login, with an additional token call, because it's not up to date. 
-- You're free to use whatever libraries you wish to get the job done (e.g. Spotify SDK), however you should consider if it prevents us from being able assess the quality of your work.
    - ✅    Alamofire
    - ✅    Lottie
    - ✅    PopupView

API reference:
- [Search](https://beta.developer.spotify.com/documentation/web-api/reference/search/search/)
- [Tracks](https://beta.developer.spotify.com/documentation/web-api/reference/tracks/)
- [Artists](https://beta.developer.spotify.com/documentation/web-api/reference/artists/)

## Features
- ✅  App authenticates through the Spotify app
- ✅  USPs/reasons to connect are show on the Login page
- ✅  If Spotify is not installed goes via the AppStore. 
- ✅  Shows reasons to connect to Spotify. 
- ✅  User can search for songs. 
- ✅  On the track page, it features a Text to image drawing based on the song’s title that you just selected, using it as a prompt.
https://replicate.com/pixray/text2image
-- There is a version you can run locally. Docker is not liking the instructions, to keep time in hand I do a simulation for 3 songs based on actual predictions for the songs. 
-- For other song it shows under construction animation and you can easily navigate to the songs that are implemented from the track page.
    -- Even the App Icon was designed by the AI for the Spotify AI prompt.
    -- The assets are currently imported as assets, this is obviously not ideal, but for the sake of demonstration it will do.
- ✅ Optimized for both dark and light modes/appearences




### Networking
- ✅  The app must perform HTTP requests on at least one endpoints of the Spotify API

### Caching
- ✅ The app must perform some sort of caching of fetched API data, if a screen is reloaded we should expect to see the cached data before the refetched data
    --I have set up a simple way of caching, because it was required, but it's not really justified by the app. --The solution is not perfect, but it show the way of thinking well.
    ---The search endpoint returns enough data for the track page so those don't need to make a separate call, so it's not really necessary to cache anything.
    --The only place where it could be used is the search, but even there it doesn't make a horrible lot of sense. 

### Responsiveness
- The UI must be updated in real-time, according to the refresh rule explained above. 
✅   a) There should be some kind of loading indicator to tell the user that something is happening (but only if a network request is sent, as opposed to fetched from the cache, that should be instantaneous).
    --Loading indicators are set up at multiple places, soetimes with a simple ProgressView sometimes with a Lottie animation
    b) In no case the app should freeze (of course). // TODO: - Never say never

### Resilience
- ✅ - The user should be informed if an error occurred while fetching data.
--Right now there is a generic, but stylish error message displayed. This could be extended of course, first with one that informs the user about the lack of internet connection. It doesn't make sense on the other hand to show too many very specific messages because it is hard to interpret by the user.
- 🚧 - If no network is available when a request is due, the app should park the call and perform it as soon as network is back. 
    --I will explain the approach here, because i left it last, and I won't have time do do this nicely. 
    --I would at a Reachability observer on app start and listeners in the view models. 
    When the user is trying to make a call I would set a flag, the listener can in turn trigger the call when the connection is restored based on the flag.
    --I would also trigger a persistent popup with the listener, that informs the user about the (lack of) connection.
    --I have used the Reachability.swift package in the past for similar purposes, this package supports the way of thinking I explained.

### UI
- You can decide on your own how will the app look, if you need a guide, feel free to look at the TicketSwap app as an example.

## Submission
- ✅ Please provide a zip of the source code with which we can easily build locally and test out ourselves.

## General notes
- ✅  Write the solution in Swift.
- ✅ Pay attention to the quality of the code, and the overall design of your software.
- ✅ Some demonstrantration of testing would be nice. 
- ✅  We recommend you to test your solution on real hardware.
    -> Needs to be tested on physical device: Simulator doesn't have an AppStore or Spotify installed
- ✅ Document your API and classes where you think it is necessary.

You can make the assessment in your own time. We usually give around 1 week for it.

## Possible next steps
    - Use the real Pixray API or other more advanced service for drawing the song titles
    - Share feature with with a share sheet and the drawn image as attachment, possibly with a default text like "Look! I created this with the Foundation app"
    - Extend testing, Although the are existing tests set up, but many more things could be tested (not just the missing test cases), and some of the tests are failing because the mocks are not fully functional.
    - Save login
