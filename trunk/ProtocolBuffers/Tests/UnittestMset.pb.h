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

#import <ProtocolBuffers/ProtocolBuffers.h>

@class PBDescriptor;
@class PBEnumDescriptor;
@class PBEnumValueDescriptor;
@class PBFieldAccessorTable;
@class PBFileDescriptor;
@class PBGeneratedMessage_Builder;
@class RawMessageSet;
@class RawMessageSet_Builder;
@class RawMessageSet_Item;
@class RawMessageSet_Item_Builder;
@class TestMessageSet;
@class TestMessageSetContainer;
@class TestMessageSetContainer_Builder;
@class TestMessageSetExtension1;
@class TestMessageSetExtension1_Builder;
@class TestMessageSetExtension2;
@class TestMessageSetExtension2_Builder;
@class TestMessageSet_Builder;

@interface UnittestMsetRoot : NSObject {
}
+ (PBFileDescriptor*) descriptor;
+ (PBFileDescriptor*) buildDescriptor;
@end

@interface TestMessageSet : PBExtendableMessage {
  @private
}

+ (PBDescriptor*) descriptor;
- (PBDescriptor*) descriptor;
+ (TestMessageSet*) defaultInstance;
- (TestMessageSet*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (TestMessageSet_Builder*) builder;
+ (TestMessageSet_Builder*) builder;
+ (TestMessageSet_Builder*) builderWithPrototype:(TestMessageSet*) prototype;

+ (TestMessageSet*) parseFromData:(NSData*) data;
+ (TestMessageSet*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (TestMessageSet*) parseFromInputStream:(NSInputStream*) input;
+ (TestMessageSet*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (TestMessageSet*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (TestMessageSet*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface TestMessageSet_Builder : PBExtendableBuilder {
  @private
  TestMessageSet* result;
}

- (PBDescriptor*) descriptor;
- (TestMessageSet*) defaultInstance;

- (TestMessageSet_Builder*) clear;
- (TestMessageSet_Builder*) clone;

- (TestMessageSet*) build;
- (TestMessageSet*) buildPartial;

- (TestMessageSet_Builder*) mergeFromMessage:(id<PBMessage>) other;
- (TestMessageSet_Builder*) mergeFromTestMessageSet:(TestMessageSet*) other;
- (TestMessageSet_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (TestMessageSet_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface TestMessageSetContainer : PBGeneratedMessage {
  @private
  BOOL hasMessageSet:1;
  TestMessageSet* messageSet;
}
- (BOOL) hasMessageSet;
@property (retain, readonly) TestMessageSet* messageSet;

+ (PBDescriptor*) descriptor;
- (PBDescriptor*) descriptor;
+ (TestMessageSetContainer*) defaultInstance;
- (TestMessageSetContainer*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (TestMessageSetContainer_Builder*) builder;
+ (TestMessageSetContainer_Builder*) builder;
+ (TestMessageSetContainer_Builder*) builderWithPrototype:(TestMessageSetContainer*) prototype;

+ (TestMessageSetContainer*) parseFromData:(NSData*) data;
+ (TestMessageSetContainer*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (TestMessageSetContainer*) parseFromInputStream:(NSInputStream*) input;
+ (TestMessageSetContainer*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (TestMessageSetContainer*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (TestMessageSetContainer*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface TestMessageSetContainer_Builder : PBGeneratedMessage_Builder {
  @private
  TestMessageSetContainer* result;
}

- (PBDescriptor*) descriptor;
- (TestMessageSetContainer*) defaultInstance;

- (TestMessageSetContainer_Builder*) clear;
- (TestMessageSetContainer_Builder*) clone;

- (TestMessageSetContainer*) build;
- (TestMessageSetContainer*) buildPartial;

- (TestMessageSetContainer_Builder*) mergeFromMessage:(id<PBMessage>) other;
- (TestMessageSetContainer_Builder*) mergeFromTestMessageSetContainer:(TestMessageSetContainer*) other;
- (TestMessageSetContainer_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (TestMessageSetContainer_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasMessageSet;
- (TestMessageSet*) messageSet;
- (TestMessageSetContainer_Builder*) setMessageSet:(TestMessageSet*) value;
- (TestMessageSetContainer_Builder*) setMessageSetBuilder:(TestMessageSet_Builder*) builderForValue;
- (TestMessageSetContainer_Builder*) mergeMessageSet:(TestMessageSet*) value;
- (TestMessageSetContainer_Builder*) clearMessageSet;
@end

@interface TestMessageSetExtension1 : PBGeneratedMessage {
  @private
  BOOL hasI:1;
  int32_t i;
}
- (BOOL) hasI;
@property (readonly) int32_t i;

+ (PBDescriptor*) descriptor;
- (PBDescriptor*) descriptor;
+ (TestMessageSetExtension1*) defaultInstance;
- (TestMessageSetExtension1*) defaultInstance;

+ (PBGeneratedExtension*) messageSetExtension;
- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (TestMessageSetExtension1_Builder*) builder;
+ (TestMessageSetExtension1_Builder*) builder;
+ (TestMessageSetExtension1_Builder*) builderWithPrototype:(TestMessageSetExtension1*) prototype;

+ (TestMessageSetExtension1*) parseFromData:(NSData*) data;
+ (TestMessageSetExtension1*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (TestMessageSetExtension1*) parseFromInputStream:(NSInputStream*) input;
+ (TestMessageSetExtension1*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (TestMessageSetExtension1*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (TestMessageSetExtension1*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface TestMessageSetExtension1_Builder : PBGeneratedMessage_Builder {
  @private
  TestMessageSetExtension1* result;
}

- (PBDescriptor*) descriptor;
- (TestMessageSetExtension1*) defaultInstance;

- (TestMessageSetExtension1_Builder*) clear;
- (TestMessageSetExtension1_Builder*) clone;

- (TestMessageSetExtension1*) build;
- (TestMessageSetExtension1*) buildPartial;

- (TestMessageSetExtension1_Builder*) mergeFromMessage:(id<PBMessage>) other;
- (TestMessageSetExtension1_Builder*) mergeFromTestMessageSetExtension1:(TestMessageSetExtension1*) other;
- (TestMessageSetExtension1_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (TestMessageSetExtension1_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasI;
- (int32_t) i;
- (TestMessageSetExtension1_Builder*) setI:(int32_t) value;
- (TestMessageSetExtension1_Builder*) clearI;
@end

@interface TestMessageSetExtension2 : PBGeneratedMessage {
  @private
  BOOL hasStr:1;
  NSString* str;
}
- (BOOL) hasStr;
@property (retain, readonly) NSString* str;

+ (PBDescriptor*) descriptor;
- (PBDescriptor*) descriptor;
+ (TestMessageSetExtension2*) defaultInstance;
- (TestMessageSetExtension2*) defaultInstance;

+ (PBGeneratedExtension*) messageSetExtension;
- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (TestMessageSetExtension2_Builder*) builder;
+ (TestMessageSetExtension2_Builder*) builder;
+ (TestMessageSetExtension2_Builder*) builderWithPrototype:(TestMessageSetExtension2*) prototype;

+ (TestMessageSetExtension2*) parseFromData:(NSData*) data;
+ (TestMessageSetExtension2*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (TestMessageSetExtension2*) parseFromInputStream:(NSInputStream*) input;
+ (TestMessageSetExtension2*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (TestMessageSetExtension2*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (TestMessageSetExtension2*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface TestMessageSetExtension2_Builder : PBGeneratedMessage_Builder {
  @private
  TestMessageSetExtension2* result;
}

- (PBDescriptor*) descriptor;
- (TestMessageSetExtension2*) defaultInstance;

- (TestMessageSetExtension2_Builder*) clear;
- (TestMessageSetExtension2_Builder*) clone;

- (TestMessageSetExtension2*) build;
- (TestMessageSetExtension2*) buildPartial;

- (TestMessageSetExtension2_Builder*) mergeFromMessage:(id<PBMessage>) other;
- (TestMessageSetExtension2_Builder*) mergeFromTestMessageSetExtension2:(TestMessageSetExtension2*) other;
- (TestMessageSetExtension2_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (TestMessageSetExtension2_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasStr;
- (NSString*) str;
- (TestMessageSetExtension2_Builder*) setStr:(NSString*) value;
- (TestMessageSetExtension2_Builder*) clearStr;
@end

@interface RawMessageSet : PBGeneratedMessage {
  @private
  NSMutableArray* mutableItemList;
}
- (NSArray*) itemList;
- (RawMessageSet_Item*) itemAtIndex:(int32_t) index;

+ (PBDescriptor*) descriptor;
- (PBDescriptor*) descriptor;
+ (RawMessageSet*) defaultInstance;
- (RawMessageSet*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (RawMessageSet_Builder*) builder;
+ (RawMessageSet_Builder*) builder;
+ (RawMessageSet_Builder*) builderWithPrototype:(RawMessageSet*) prototype;

+ (RawMessageSet*) parseFromData:(NSData*) data;
+ (RawMessageSet*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (RawMessageSet*) parseFromInputStream:(NSInputStream*) input;
+ (RawMessageSet*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (RawMessageSet*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (RawMessageSet*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface RawMessageSet_Item : PBGeneratedMessage {
  @private
  BOOL hasTypeId:1;
  BOOL hasMessage:1;
  int32_t typeId;
  NSData* message;
}
- (BOOL) hasTypeId;
- (BOOL) hasMessage;
@property (readonly) int32_t typeId;
@property (retain, readonly) NSData* message;

+ (PBDescriptor*) descriptor;
- (PBDescriptor*) descriptor;
+ (RawMessageSet_Item*) defaultInstance;
- (RawMessageSet_Item*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (RawMessageSet_Item_Builder*) builder;
+ (RawMessageSet_Item_Builder*) builder;
+ (RawMessageSet_Item_Builder*) builderWithPrototype:(RawMessageSet_Item*) prototype;

+ (RawMessageSet_Item*) parseFromData:(NSData*) data;
+ (RawMessageSet_Item*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (RawMessageSet_Item*) parseFromInputStream:(NSInputStream*) input;
+ (RawMessageSet_Item*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (RawMessageSet_Item*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (RawMessageSet_Item*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface RawMessageSet_Item_Builder : PBGeneratedMessage_Builder {
  @private
  RawMessageSet_Item* result;
}

- (PBDescriptor*) descriptor;
- (RawMessageSet_Item*) defaultInstance;

- (RawMessageSet_Item_Builder*) clear;
- (RawMessageSet_Item_Builder*) clone;

- (RawMessageSet_Item*) build;
- (RawMessageSet_Item*) buildPartial;

- (RawMessageSet_Item_Builder*) mergeFromMessage:(id<PBMessage>) other;
- (RawMessageSet_Item_Builder*) mergeFromRawMessageSet_Item:(RawMessageSet_Item*) other;
- (RawMessageSet_Item_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (RawMessageSet_Item_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasTypeId;
- (int32_t) typeId;
- (RawMessageSet_Item_Builder*) setTypeId:(int32_t) value;
- (RawMessageSet_Item_Builder*) clearTypeId;

- (BOOL) hasMessage;
- (NSData*) message;
- (RawMessageSet_Item_Builder*) setMessage:(NSData*) value;
- (RawMessageSet_Item_Builder*) clearMessage;
@end

@interface RawMessageSet_Builder : PBGeneratedMessage_Builder {
  @private
  RawMessageSet* result;
}

- (PBDescriptor*) descriptor;
- (RawMessageSet*) defaultInstance;

- (RawMessageSet_Builder*) clear;
- (RawMessageSet_Builder*) clone;

- (RawMessageSet*) build;
- (RawMessageSet*) buildPartial;

- (RawMessageSet_Builder*) mergeFromMessage:(id<PBMessage>) other;
- (RawMessageSet_Builder*) mergeFromRawMessageSet:(RawMessageSet*) other;
- (RawMessageSet_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (RawMessageSet_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (NSArray*) itemList;
- (RawMessageSet_Item*) itemAtIndex:(int32_t) index;
- (RawMessageSet_Builder*) replaceItemAtIndex:(int32_t) index with:(RawMessageSet_Item*) value;
- (RawMessageSet_Builder*) addItem:(RawMessageSet_Item*) value;
- (RawMessageSet_Builder*) addAllItem:(NSArray*) values;
- (RawMessageSet_Builder*) clearItemList;
@end