# GotBeerApp

GotBeerApp is an app that uses the [Punk API](https://punkapi.com/) to help the users find the best beer for their food.

## User Stories

The following **required** functionality is completed:

- [X] As a user, I want to type in the food I am having now, so that I get a list of the best beers to
pair with my food, sorted by increasing ABV (Alcohol By Volume, %).
Each beer entry should show, at least, the following information: beer name, tagline,
description, image, and ABV (Alcohol By Volume, %).
- [X] As a user, I want to reverse the sorting of the list of beers, so I can see the highest ABV
beers at the top.
Without launching another REST request, sort the current list of beers in reverse order
(decreasing ABV).
- [X] As a user, if I type in any food that I have previously searched for, I want to immediately see
the same search results as before, so I can decide which beer to have faster.
For every search request, check first if there is a search result on disk already, and return it
if that's the case. If not, send a request to the REST API, and store the response on disk, in
whatever format you prefer, so the next time the same search term is submitted, the app
could retrieve the search result from disk.

The following **optional** features are implemented:

- [ ] Unit tests
- [ ] Functional reactive programming (RxSwift...)
- [ ] Some animations 

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='https://github.com/Libranner/GotBeerApp/blob/master/walkthrough.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

For this I used **RxSwift and MVVM**. For the local database I've used **Core Data** and for the HTTP Request **Alamofire**.

I choosed to use Alamofire just because it is almost a standard in the iOS development industry, but I can easily use the default SDK apis, for this requeriment.

## License

    Copyright 2019 Libranner L. Santos Espinal

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
