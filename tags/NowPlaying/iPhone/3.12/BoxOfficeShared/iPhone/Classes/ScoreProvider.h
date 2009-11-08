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

@protocol ScoreProvider<NSObject>
- (NSString*) providerName;
- (NSDictionary*) scores;
- (Score*) scoreForMovie:(Movie*) movie;
- (NSArray*) reviewsForMovie:(Movie*) movie;
- (void) updateWithNotifications;
- (void) updateWithoutNotifications;
- (void) processMovie:(Movie*) movie force:(BOOL) force;
@end