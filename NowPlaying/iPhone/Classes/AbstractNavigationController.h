// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

@interface AbstractNavigationController : UINavigationController {
@private
    ApplicationTabBarController* applicationTabBarController_;
    PostersViewController* postersViewController_;
    BOOL viewLoaded_;
    BOOL visible_;
}

- (id) initWithTabBarController:(ApplicationTabBarController*) tabBarController;

- (void) majorRefresh;
- (void) minorRefresh;

- (void) pushTicketsView:(Movie*) movie
                 theater:(Theater*) theater
                   title:(NSString*) title
                animated:(BOOL) animated;

- (void) pushTheaterDetails:(Theater*) theater animated:(BOOL) animated;
- (void) pushMovieDetails:(Movie*) movie animated:(BOOL) animated;
- (void) pushReviews:(Movie*) movie animated:(BOOL) animated;
- (void) pushBrowser:(NSString*) address animated:(BOOL) animated;
- (void) pushBrowser:(NSString*) address showSafariButton:(BOOL) showSafariButton animated:(BOOL) animated;

- (void) pushInfoControllerAnimated:(BOOL) animated;

- (void) navigateToLastViewedPage;

- (void) showPostersView:(Movie*) movie posterCount:(NSInteger) posterCount;
- (void) hidePostersView;

// @protected
- (ApplicationTabBarController*) applicationTabBarController;
- (BOOL) visible;
- (Movie*) movieForTitle:(NSString*) canonicalTitle;

@end