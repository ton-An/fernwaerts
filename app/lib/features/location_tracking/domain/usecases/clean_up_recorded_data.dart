// Cleans up the recorded data (needed when app comes from background). 
// Includes: 
// - Querying the database for recorded data since last time the clean up was called
// - Creating movement segments in the database
//     - This includes an algorithm deciding the start and end points
// - ... probably more