//
//  ViewController.m
//  CalculatorApp
//
//  Created by Jamie Jyhyun Song on 7/11/16.
//  Copyright (c) 2016 JSONG. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

//create set and get methods for properties
@synthesize curValue;
@synthesize totalCurValue;
@synthesize curStatusCode;
@synthesize displayLabel;

//viewDidLoad is called when screen has loaded
- (void)viewDidLoad {
    [self ClearCalculation]; //reset calculator display
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

//Method to print the numbers at Display Label
-(void)DisplayInputValue:(NSString *)displayText
{
    NSString *CommaText;
    CommaText = [self ConvertComma:displayText];
    [displayLabel setText:CommaText];
}

//print the calculated result on display label
-(void)DisplayCalculationValue
{
    NSString *displayText;
    displayText = [NSString stringWithFormat:@"%g",totalCurValue];
    [self DisplayInputValue:displayText];
    curInputValue=@"";
}

//reset calculator
-(void) ClearCalculation
{
    curInputValue = @"";
    curValue=0;
    totalCurValue=0;
    
    [self DisplayInputValue:curInputValue];
    
    curStatusCode=STATUS_DEFAULT;
}

-(NSString *) ConvertComma:(NSString *)data
{
    if (data == nil) return nil;
    if ([data length]<=3) return data;
    
    NSString *integerString = nil;
    NSString *floatString = nil;
    NSString *minusString = nil;
    
    //look for where there should be decimal point
    NSRange pointRange = [data rangeOfString:@"."];
    if (pointRange.location == NSNotFound){
        //there is no decimal point
        integerString=data;
    }
    else {
        //look for where to put decimal point
        NSRange r;
        r.location = pointRange.location;
        r.length = [data length] - pointRange.location;
        [floatString = data substringWithRange:r];
        
        r.location = 0;
        r.length = pointRange.location;
        integerString = [data substringWithRange:r];
    }
    
    //look for negative sign
    NSRange minusRange = [integerString rangeOfString:@"-"];
    if (minusRange.location != NSNotFound) { //there is negative sign
        minusString = @"-";
        integerString = [integerString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    //add a comma after 3 letters
    NSMutableString *integerStringCommaInserted = [[NSMutableString alloc] init];
    NSUInteger integerStringLength = [integerString length];
    int idx = 0;
    while (idx < integerStringLength) {
        [integerStringCommaInserted appendFormat:@"%C",[integerString characterAtIndex:idx]];
        if ((integerStringLength - (idx+1))%3 == 0 && integerStringLength != (idx+1)) {
            [integerStringCommaInserted appendString:@","];
        }
        idx++;
    }
    
    NSMutableString *returnString = [[NSMutableString alloc] init];
    if (minusString != nil) [returnString appendString:minusString];
    if (integerStringCommaInserted != nil) [returnString appendString:integerStringCommaInserted];
    if (floatString != nil) [returnString appendString:floatString];
    
    return returnString;
}

- (IBAction) digitPressed:(UIButton *)sender
{
    NSString *numPoint = [[sender titleLabel] text];
    curInputValue = [curInputValue stringByAppendingFormat:numPoint];
    [self DisplayInputValue:curInputValue];
}


@end
