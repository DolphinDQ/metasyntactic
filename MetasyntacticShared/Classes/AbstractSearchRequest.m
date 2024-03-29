// Copyright 2010 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "AbstractSearchRequest.h"

#import "StringUtilities.h"

@interface AbstractSearchRequest()
@property NSInteger requestId;
@property (copy) NSString* value;
@property (copy) NSString* lowercaseValue;
@end


@implementation AbstractSearchRequest

@synthesize requestId;
@synthesize value;
@synthesize lowercaseValue;

- (void) dealloc {
  self.requestId = 0;
  self.value = nil;
  self.lowercaseValue = nil;

  [super dealloc];
}


- (id) initWithId:(NSInteger) requestId_
            value:(NSString*) value_ {
  if ((self = [super init])) {
    self.requestId = requestId_;
    self.value = value_;
    self.lowercaseValue = [[StringUtilities asciiString:value_] lowercaseString];
  }

  return self;
}

@end
