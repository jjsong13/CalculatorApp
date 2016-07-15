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

-(void)DisplayInputValue:(NSString *)displayText
{
    NSLog(@"*DisplayInputValue method called.");

    NSString *CommaText;
    CommaText = [self ConvertComma:displayText];
    [displayLabel setText:CommaText];
}

-(void)DisplayCalculationValue
{
    NSLog(@"*DisplayCalculationValue method called.");

    NSString *displayText;
    displayText = [NSString stringWithFormat:@"%g",totalCurValue];
    [self DisplayInputValue:displayText];
    curInputValue=@"";
    NSLog(@"totalCurValue is " @"%f" @" and curStatusCode is " @"%u", totalCurValue, curStatusCode);
    
}

//reset calculator
-(void) ClearCalculation
{
    NSLog(@"*ClearCalculation method called.");
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

//method called when number or decimal point is pressed
- (IBAction) digitPressed:(UIButton *)sender
{
    NSLog(@"*digitPressed method called.");
    NSString *numPoint = [[sender titleLabel] text];
    if (numPoint != nil) {
        curInputValue = [curInputValue stringByAppendingFormat:numPoint];
        
    }
    [self DisplayInputValue:curInputValue];

}

//method called when function button is pressed
- (IBAction) operationPressed:(UIButton *)sender
{

    NSLog(@"*operationPressed method called and curInputValue is " @"%@", curInputValue);

    NSString *operationText = [[sender titleLabel] text];
    
    if ([curInputValue  isEqual: @""]) {
        NSString *myString = [NSString stringWithFormat:@"%f", totalCurValue];
        curInputValue = myString;
    }
    
    if([@"+"isEqualToString:operationText])
    {
        NSLog(@"STATUS_PLUS is set");
        [self Calculation:curStatusCode CurStatusCode:STATUS_PLUS];
    }
    else if([@"-"isEqualToString:operationText])
    {
        NSLog(@"STATUS_MINUS is set");
        [self Calculation:curStatusCode CurStatusCode:STATUS_MINUS];
    }
    else if([@"x"isEqualToString:operationText])
    {
        NSLog(@"STATUS_MULTIPLY is set");
        [self Calculation:curStatusCode CurStatusCode:STATUS_MULTIPLY];
    }
    else if([@"/"isEqualToString:operationText])
    {
        NSLog(@"STATUS_DIVISION is set");
        [self Calculation:curStatusCode CurStatusCode:STATUS_DIVISION];
    }
    else if([@"c"isEqualToString:operationText])
    {
        NSLog(@"c is set");
        [self ClearCalculation];
    }
    else if([@"="isEqualToString:operationText])
    {
        NSLog(@"STATUS_RETURN is set");
        [self Calculation:curStatusCode CurStatusCode:STATUS_RETURN];
    }
    
}
//method to solve current status
//Calculation method
//first StatusCode shows the method to call and cStatusCode shows the status code after the calculation is completed.
-(void) Calculation:(kStatusCode)StatusCode CurStatusCode:(kStatusCode)cStatusCode;
{
    switch(StatusCode)
    {
        case STATUS_DEFAULT:
            [self DefaultCalculation];
            break;
        case STATUS_DIVISION:
            [self DivisionCalculation];
            break;
        case STATUS_MULTIPLY:
            [self MultiplyCalculation];
            break;
        case STATUS_MINUS:
            [self MinusCalculation];
            break;
        case STATUS_PLUS:
            [self PlusCalculation];
            break;
        case STATUS_RETURN:
            [self DefaultCalculation];
            break;
    }
    curStatusCode = cStatusCode;
}

-(void) DefaultCalculation
{
    NSLog(@"DefaultCalculation method is called. curInputValue is "  @"%@" @" and totalCurValue is " @"%f",curInputValue, totalCurValue);
    curValue = [curInputValue doubleValue];
    totalCurValue = curValue;
    [self DisplayCalculationValue];
    
}

-(void) PlusCalculation
{
    NSLog(@"PlusCalculation method is called. curInputValue is "  @"%@" @" and totalCurValue is " @"%f",curInputValue, totalCurValue);
    curValue = [curInputValue doubleValue];
    totalCurValue = totalCurValue + curValue;
    [self DisplayCalculationValue];
}

-(void) MinusCalculation
{
    NSLog(@"MinusCalculation method is called");
    
    curValue = [curInputValue doubleValue];
    totalCurValue = totalCurValue - curValue;
    [self DisplayCalculationValue];
}


-(void) MultiplyCalculation
{
    NSLog(@"MultiplyCalculation method is called");
    curValue = [curInputValue doubleValue];
    totalCurValue = totalCurValue * curValue;
    [self DisplayCalculationValue];
}


-(void) DivisionCalculation
{
    NSLog(@"DivisionCalculation method is called");
    curValue = [curInputValue doubleValue];
    totalCurValue = totalCurValue / curValue;
    [self DisplayCalculationValue];
}

@end
