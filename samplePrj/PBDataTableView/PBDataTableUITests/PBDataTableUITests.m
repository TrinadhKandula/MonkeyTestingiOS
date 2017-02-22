//
//  PBDataTableUITests.m
//  PBDataTableUITests
//
//  Created by Kandula, Sandeep on 22/02/17.
//  Copyright © 2017 Praveen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface PBDataTableUITests : XCTestCase
@property (strong, nonatomic) NSArray *acceptedElements;

@property (assign, nonatomic) NSUInteger numberOFEvents;
@property (assign, nonatomic) NSUInteger minutesToRun;
@property (assign, nonatomic) BOOL checkTime;
@property (assign, nonatomic) NSUInteger checkTimeEvery;
@property (assign, nonatomic) CFTimeInterval startTime, endTime;
@property (strong, nonatomic) XCUIApplication *app;
@property (assign, nonatomic) BOOL triggerRandomEvent;
@property (assign, nonatomic) NSUInteger triggerRandomEventEvery;
@property (assign, nonatomic) XCUIElement *checkElement;
@end

@implementation PBDataTableUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = YES;
    
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    //[[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    
    
    _acceptedElements = [NSArray new];
    _acceptedElements = @[@(XCUIElementTypeButton),
                          @(XCUIElementTypeCell),
                          @(XCUIElementTypeTab),
                          @(XCUIElementTypeTextField),
                          @(XCUIElementTypeAlert),
                          @(XCUIElementTypeDialog),
                          @(XCUIElementTypeTextView),
                          @(XCUIElementTypeStatusBar)];
    
    //_numberOFEvents = 1000; // Run Loop for 1000 times
    _minutesToRun = 60 * 2; //Run tests for 2 hours
    
    _triggerRandomEvent = NO; //Trigger an Random Event
    _triggerRandomEventEvery = 10; //Trigger Random Event for every |10| steps
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDoMonkeyTesting {
    
    
    _app = [[XCUIApplication alloc] init];
    [_app launch];
    
    //check for any anchor element before triggering the monkey tests
    //Replace the "loginButton" with any required element you want to check on.
    //This is to handle the launching time of the app.
    XCUIElement *expectElement = _checkElement = _app.buttons[@"loginButton"];
    NSPredicate *existsPredicate = [NSPredicate predicateWithFormat:@"exists == 1"];
    
    [self expectationForPredicate:existsPredicate evaluatedWithObject:expectElement handler:nil];
    [self waitForExpectationsWithTimeout:3000 handler:^(NSError *error) {
        //Handle the Error
    }];
    
    if(_numberOFEvents && _minutesToRun){
        NSAssert(false, @"invalid configuration. You cannot define both minutesToRun and numberOFEvents");
    }
    
    if(_minutesToRun){
        _checkTime = true;
        _numberOFEvents = 2000000000;
        _checkTimeEvery = 60;
        _startTime = CACurrentMediaTime();
    }
    
    XCUIElementQuery *commonQuery = [_app descendantsMatchingType:XCUIElementTypeAny];
    
    for( int i=0; i<_numberOFEvents; i++){
        
        if(_checkTime && (i % _checkTimeEvery == 0)){
            
            CFTimeInterval elapsedTime = CACurrentMediaTime() - _startTime;
            if(elapsedTime >= _minutesToRun){
                NSAssert(true, @"Ending monkey after %f minutes run time.",elapsedTime);
            }
        }
        
        if(_triggerRandomEvent && (i % _triggerRandomEventEvery == 0)){
            [self triggerRandomEvent:(arc4random() % 10)];
        }
        
        XCUIElement *element = [commonQuery elementBoundByIndex:(arc4random() % commonQuery.count)];
        
        /*&& [_acceptedElements containsObject:@(element.elementType)]*/
        XCUIElement *window = [_app.windows elementBoundByIndex:0];
        if(element.isHittable && element.exists && CGRectContainsRect(window.frame, element.frame)){
            
            [self actAccordingToElementType:element.elementType andElement:element];
            
        }
    }
}


- (void)actAccordingToElementType:(XCUIElementType)elementType andElement:(XCUIElement *)element {
    
    
    switch (element.elementType) {
            
        case XCUIElementTypeTextField:
            [element tap];
            sleep(1);
            [element typeText:@"randomtext"];
            break;
            
        case XCUIElementTypeButton: {
            //XCUIElement *finraElement = _app.buttons[@"FINRA’s BrokerCheck website"];
            if([_checkElement.label isEqualToString:element.label])
                return;
            else
                [element tap];
            break;
        }
            
        case XCUIElementTypeTable:
            [element swipeDown];
            break;
            
        default:
            [element tap];
            break;
            
    }
    
}

//TODO : check for better approach.
//Probably list all methods in string array & call with |performSelector|
- (void)triggerRandomEvent:(NSUInteger)randomMethod {
    
    switch (randomMethod) {
        case 0:
            [_app doubleTap];
            break;
            
        case 1:
            [_app twoFingerTap];
            break;
            
        case 2:
            [_app pressForDuration:5];
            break;
            
        case 3:
            [_app tapWithNumberOfTaps:2 numberOfTouches:3];
            break;
            
        case 4:
            [_app swipeUp];
            break;
            
        case 5:
            [_app swipeDown];
            break;
            
        case 6:
            [_app swipeRight];
            break;
            
        case 7:
            [_app swipeLeft];
            break;
            
        case 8:
            [_app pinchWithScale:3.5 velocity:9.0];
            break;
            
        case 9:
#if !(TARGET_OS_SIMULATOR)
            [[XCUIDevice sharedDevice] pressButton:XCUIDeviceButtonVolumeUp];
#endif
            break;
            
        case 10:
#if !(TARGET_OS_SIMULATOR)
            [[XCUIDevice sharedDevice] pressButton:XCUIDeviceButtonVolumeDown];
#endif
            break;
            
        default:
            break;
    }
    
    
}


@end

