//
//  ViewController.h
//  CalculatorApp
//
//  Created by Jamie Jyhyun Song on 7/11/16.
//  Copyright (c) 2016 JSONG. All rights reserved.
//

#import <UIKit/UIKit.h>

//Declare enumeration of current status
typedef enum {
    STATUS_DEFAULT=0,
    STATUS_DIVISION,
    STATUS_MULTIPLY,
    STATUS_MINUS,
    STATUS_PLUS,
    STATUS_RETURN
}  kStatusCode;

@interface ViewController : UIViewController {
    double curValue; //property to save currently inputted value
    double totalCurValue; //property to save final calculated value
    NSString *curInputValue; //property to save currrent input numbers
    kStatusCode curStatusCode;
}

//method to take care of event when number button is clicked
- (IBAction) digitPressed:(UIButton *) sender;

//method to take care of event when function button is clicked
- (IBAction) operationPressed:(UIButton *)sender;

@property Float64 curValue; //declare current input value as property
@property Float64 totalCurValue; //declare total calculated value as property
@property kStatusCode curStatusCode; //declare current status as property

//declare an outlet for display label
@property (weak,nonatomic) IBOutlet UILabel *displayLabel;

@end

