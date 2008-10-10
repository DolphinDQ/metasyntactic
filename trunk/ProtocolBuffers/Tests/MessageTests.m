//
//  MessageTest.m
//  ProtocolBuffers
//
//  Created by Cyrus Najmabadi on 10/10/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MessageTests.h"

#import "Unittest.pb.h"

@implementation MessageTests

- (TestAllTypes*) mergeSource {
    return [[[[[[TestAllTypes_Builder builder]
                setOptionalInt32:1]
               setOptionalString:@"foo"]
              setOptionalForeignMessage:[ForeignMessage defaultInstance]]
             addRepeatedString:@"bar"]
            build];
}


- (TestAllTypes*) mergeDestination {
    return [[[[[[TestAllTypes_Builder builder]
                setOptionalInt64:2]
               setOptionalString:@"baz"]
              setOptionalForeignMessage:[[[ForeignMessage_Builder builder] setC:3] build]]
             addRepeatedString:@"qux"]
            build];
}


- (TestAllTypes*) mergeResult {
    return [[[[[[[[TestAllTypes_Builder builder]
                  setOptionalInt32:1]
                 setOptionalInt64:2]
                setOptionalString:@"foo"]
               setOptionalForeignMessage:[[[ForeignMessage_Builder builder] setC:3] build]]
              addRepeatedString:@"qux"]
             addRepeatedString:@"bar"]
            build];
}


- (void) testMergeFrom {
    TestAllTypes* result =
    [[[TestAllTypes_Builder builderWithPrototype:self.mergeDestination]
      mergeFromTestAllTypes:self.mergeSource] build];
    
    STAssertEqualObjects(result.toData, self.mergeResult.toData, @"");
}


/**
 * Test merging a DynamicMessage into a GeneratedMessage.  As long as they
 * have the same descriptor, this should work, but it is an entirely different
 * code path.
 */
- (void) testMergeFromDynamic {
    TestAllTypes* result = [[[TestAllTypes_Builder builderWithPrototype:self.mergeDestination]
                             mergeFromMessage:[[PBDynamicMessage builderWithMessage:self.mergeSource] build]]
                            build];
    
    STAssertEqualObjects(result.toData, self.mergeResult.toData, @"");
}


/** Test merging two DynamicMessages. */
- (void) testDynamicMergeFrom {
    PBDynamicMessage* result =
    [[[PBDynamicMessage builderWithMessage:self.mergeDestination]
      mergeFromMessage:[[PBDynamicMessage builderWithMessage:self.mergeSource] build]]
     build];
    
    STAssertEqualObjects(result.toData, self.mergeResult.toData, @"");
}

// =================================================================
// Required-field-related tests.

- (TestRequired*) testRequiredUninitialized {
    return [TestRequired defaultInstance];
}


- (TestRequired*) testRequiredInitialized {
    return [[[[[TestRequired_Builder builder] setA:1] setB:2] setC:3] build];
}


- (void) testRequired {
    TestRequired_Builder* builder = [TestRequired_Builder builder];
    
    STAssertFalse(builder.isInitialized, @"");
    [builder setA:1];
    STAssertFalse(builder.isInitialized, @"");
    [builder setB:1];
    STAssertFalse(builder.isInitialized, @"");
    [builder setC:1];
    STAssertTrue(builder.isInitialized, @"");
}


- (void) testRequiredForeign {
    TestRequiredForeign_Builder* builder = [TestRequiredForeign_Builder builder];
    
    STAssertTrue(builder.isInitialized, @"");
    
    [builder setOptionalMessage:self.testRequiredUninitialized];
    STAssertFalse(builder.isInitialized, @"");
    
    [builder setOptionalMessage:self.testRequiredInitialized];
    STAssertTrue(builder.isInitialized, @"");
    
    [builder addRepeatedMessage:self.testRequiredUninitialized];
    STAssertFalse(builder.isInitialized, @"");
    
    [builder replaceRepeatedMessageAtIndex:0 withRepeatedMessage:self.testRequiredInitialized];
    STAssertTrue(builder.isInitialized, @"");
}


- (void) testRequiredExtension {
    TestAllExtensions_Builder* builder = [TestAllExtensions_Builder builder];
    
    STAssertTrue(builder.isInitialized, @"");
    
    [builder setExtension:[TestRequired single] value:self.testRequiredUninitialized];
    STAssertFalse(builder.isInitialized, @"");
    
    [builder setExtension:[TestRequired single] value:self.testRequiredInitialized];
    STAssertTrue(builder.isInitialized, @"");
    
    [builder addExtension:[TestRequired multi] value:self.testRequiredUninitialized];
    STAssertFalse(builder.isInitialized, @"");
    
    [builder setExtension:[TestRequired multi] index:0 value:self.testRequiredInitialized];
    STAssertTrue(builder.isInitialized, @"");
}
     

- (void) testRequiredDynamic {
    PBDescriptor* descriptor = [TestRequired descriptor];
    PBDynamicMessage_Builder* builder = [PBDynamicMessage_Builder builderWithType:descriptor];
    
    STAssertFalse(builder.isInitialized, @"");
    [builder setField:[descriptor findFieldByName:@"a"] value:[NSNumber numberWithInt:1]];
    STAssertFalse(builder.isInitialized, @"");
    [builder setField:[descriptor findFieldByName:@"b"] value:[NSNumber numberWithInt:1]];
    STAssertFalse(builder.isInitialized, @"");
    [builder setField:[descriptor findFieldByName:@"c"] value:[NSNumber numberWithInt:1]];
    STAssertTrue(builder.isInitialized, @"");
}
     

- (void) testRequiredDynamicForeign {
    PBDescriptor* descriptor = [TestRequiredForeign descriptor];
    PBDynamicMessage_Builder* builder = [PBDynamicMessage_Builder builderWithType:descriptor];
    
    STAssertTrue(builder.isInitialized, @"");
    
    [builder setField:[descriptor findFieldByName:@"optional_message"]
                value:self.testRequiredUninitialized];
    STAssertFalse(builder.isInitialized, @"");
    
    [builder setField:[descriptor findFieldByName:@"optional_message"]
                value:self.testRequiredInitialized];
    STAssertTrue(builder.isInitialized, @"");
    
    [builder addRepeatedField:[descriptor findFieldByName:@"repeated_message"]
                        value:self.testRequiredUninitialized];
    STAssertFalse(builder.isInitialized, @"");
    
    [builder setRepeatedField:[descriptor findFieldByName:@"repeated_message"]
                        index:0
                        value:self.testRequiredInitialized];
    STAssertTrue(builder.isInitialized, @"");
}

     
- (void) testUninitializedException {
    STAssertThrows([[TestRequired_Builder builder] build], @"");
}


- (void) testBuildPartial {
    // We're mostly testing that no exception is thrown.
    TestRequired* message = [[TestRequired_Builder builder] buildPartial];
    STAssertFalse(message.isInitialized, @"");
}


- (void) testNestedUninitializedException {
    STAssertThrows([[[[[TestRequiredForeign_Builder builder]
                       setOptionalMessage:self.testRequiredUninitialized]
                      addRepeatedMessage:self.testRequiredUninitialized]
                     addRepeatedMessage:self.testRequiredUninitialized]
                    build], @"");
}


- (void) testBuildNestedPartial {
    // We're mostly testing that no exception is thrown.
    
    TestRequiredForeign* message = 
    [[[[[TestRequiredForeign_Builder builder]
        setOptionalMessage:self.testRequiredUninitialized]
       addRepeatedMessage:self.testRequiredUninitialized]
      addRepeatedMessage:self.testRequiredUninitialized]
     buildPartial];
    
    STAssertFalse(message.isInitialized, @"");
}


- (void) testParseUnititialized {
    STAssertThrows([TestRequired parseFromData:[NSData data]], @"");
}


- (void) testParseNestedUnititialized {
    TestRequiredForeign* message = 
    [[[[[TestRequiredForeign_Builder builder]
        setOptionalMessage:self.testRequiredUninitialized]
       addRepeatedMessage:self.testRequiredUninitialized]
      addRepeatedMessage:self.testRequiredUninitialized]
     buildPartial];
    
    NSData* data = message.toData;
    
    STAssertThrows([TestRequiredForeign parseFromData:data], @"");
}

#if 0
public void testDynamicUninitializedException() throws Exception {
    try {
        DynamicMessage.newBuilder(TestRequired.getDescriptor()).build();
        fail("Should have thrown an exception.");
    } catch (UninitializedMessageException e) {
        assertEquals("Message missing required fields: a, b, c", e.getMessage());
    }
}

public void testDynamicBuildPartial() throws Exception {
    // We're mostly testing that no exception is thrown.
    DynamicMessage message =
    DynamicMessage.newBuilder(TestRequired.getDescriptor())
    .buildPartial();
    assertFalse(message.isInitialized());
}

public void testDynamicParseUnititialized() throws Exception {
    try {
        Descriptors.Descriptor descriptor = TestRequired.getDescriptor();
        DynamicMessage.parseFrom(descriptor, ByteString.EMPTY);
        fail("Should have thrown an exception.");
    } catch (InvalidProtocolBufferException e) {
        assertEquals("Message missing required fields: a, b, c", e.getMessage());
    }
}
#endif

@end
