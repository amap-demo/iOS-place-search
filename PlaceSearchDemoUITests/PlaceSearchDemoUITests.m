//
//  PlaceSearchDemoUITests.m
//  PlaceSearchDemoUITests
//
//  Created by hanxiaoming on 16/12/30.
//  Copyright © 2016年 AutoNavi. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface PlaceSearchDemoUITests : XCTestCase

@end

@implementation PlaceSearchDemoUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    sleep(1);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    XCUIApplication *app = [[XCUIApplication alloc] init];

    [app.navigationBars[@"View"].searchFields[@"\u8bf7\u8f93\u5165\u5173\u952e\u5b57"] tap];
    
    XCUIElement *element = [[[[app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1];
    [element tap];
    
    XCUIElement *textField = [[app searchFields] element];
    [textField typeText:@"望京\n"];
    
    sleep(1);

    XCUIElement *cell = app.tables.staticTexts[@"\u671b\u4eacSOHO"];
    
    if (cell.exists) {
        if (cell.isHittable) {
            [cell tap];
        }
        else {
            XCUICoordinate *coor = [cell coordinateWithNormalizedOffset:CGVectorMake(0.1, 0.1)];
            [coor tap];
        }
    }
    else {
        [self recordFailureWithDescription:@"no search result" inFile:@__FILE__ atLine:__LINE__ expected:NO];
    }

    // wait
    XCTestExpectation *e = [self expectationWithDescription:@"empty wait"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [e fulfill];
    });
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        
    }];
}

@end
