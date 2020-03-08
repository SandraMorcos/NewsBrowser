# NewsBrowser

Simple news app, featuring recent news articles from newsAPI.com

## Features

- Browse Articles from favorite Country
- Search articles by keyword and filter the search by different sources
- Read full articles on Safari
- Bookmark articles to read later

## Design Choices
- Using MVVM design pattern with added repositories to map models into view models
- Using a static variable to access previously fetched sources to eliminate the need for other data requests.
- Creating a request struct to handle different types of requests through an enum because all endpoints have things in common.
- Creating one data model for both requests because the squeletons of both models are the same even though there are some slight differences.
- Creating a constants file to make it easier to change data that reflects in several places across the app
- Using helpers to maintain consistency


## Future improvements

- Reusing the tableView that displays the articles in Headlines and Favorites view controller by implementing either a common parent for both viewControllers, or for the tableview and using it inside each view controller.
- Moving all strings to a strings file instead of hard-coding them.

#### Assets Credits
All icons used in this project were downloaded from [icons8.com](http://icons8.com)
