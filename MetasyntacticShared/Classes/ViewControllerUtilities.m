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

#import "ViewControllerUtilities.h"

@implementation ViewControllerUtilities

+ (UILabel*) viewControllerTitleLabel:(NSString*) text {
  UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];

  label.adjustsFontSizeToFitWidth = YES;
  label.opaque = NO;
  label.backgroundColor = [UIColor clearColor];
  label.textColor = [UIColor whiteColor];
  label.shadowColor = [UIColor darkGrayColor];
  label.font = [UIFont boldSystemFontOfSize:20];
  label.textAlignment = UITextAlignmentCenter;
  label.minimumFontSize = 12;
  label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  label.lineBreakMode = UILineBreakModeMiddleTruncation;
  label.text = text;

  return label;
}


+ (UILabel*) viewControllerTitleLabel {
  return [self viewControllerTitleLabel:@""];
}


+ (UILabel*) footerLabel:(NSString*) text {
  UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 25)] autorelease];
  label.backgroundColor = [UIColor clearColor];
  label.font = [UIFont systemFontOfSize:15];
  label.textColor = [UIColor colorWithRed:76.0 / 255.0 green:86.0 / 255.0 blue:107.0 / 255.0 alpha:1];
  label.shadowColor = [UIColor whiteColor];
  label.shadowOffset = CGSizeMake(0, 1);
  label.textAlignment = UITextAlignmentCenter;
  label.text = text;
  return label;
}


+ (UILabel*) footerLabel {
  return [self footerLabel:@""];
}

@end
