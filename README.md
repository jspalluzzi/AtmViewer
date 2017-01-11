# AtmViewer
ATM/Branch Locator using Chase Bank Public API

## Synopsis

1. Create a browser or native-app based application to serve as a basic ATM/branch locator.

  -- Created a native iOS application --
  
2. Map page:

  1. Query the JPMC location service.
  
      -- Used Alamofire to make API request --
      
  2. Passed coordinates should be obtained from the browser's geolocation API (current actual
location).

      -- Used LocationManager and Google Maps API for user's current location --
      
  3. Results should be presented as markers (pins) on an interactive Google map.
  
      -- Displayed custom markers on the MapView --
      
  4. Clicking a marker should navigate the user to the details page. 
  
      -- Clicking a marker brings up a bottom view; tapping the bottom view navigates you to detail view --
  
3. Details page:
  1. Display name and full set of details for a selected ATM or branch.
  
      -- Displays Name and details of selected ATM or Branch --
      
  2. The API response is mostly self-explanatory, but you can ignore any data that doesn't make sense.

4. Extra:
    -- Added unit tests to the AtmDeailsViewController class

## Dependanciess
Alamofire - For the async API Calls

SwiftyJSON - For the JSON parsing

GoogleMaps - For the map and street view


##Time

Total Time Spent: 8 hours

If I had more time:
    I would of made the Pop Transition more clean, the views get squished. Looks funny.
    I would of use Core Text and Attribute the Text
    There are some issues with switching the opaqueness
    Worked out more of the constraint issues in Storyboard
