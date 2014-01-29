//
//  ViewController.m
//  Cardform
//
//  Created by Issa Araj on 1/28/14.
//  Copyright (c) 2014 Issa Araj. All rights reserved.
//

#import "ViewController.h"
#import "Luhn.h"

@interface ViewController ()
{
    int AMEX, DINERS, DISCOVER, JCB, MSTR, VISA, GENERIC;
    int cardType;
    int currentYear;
    int maxExpYears;
}
@end

@implementation ViewController

@synthesize ccImage, ccNumber, expMonth, expYear, cvvImage, cvvNumber, errorDate, errorCVV, errorCCnum;


- (void)initializeVars {
    AMEX = 1, DINERS = 2, DISCOVER = 3, JCB = 4, MSTR = 5, VISA = 6, GENERIC = 7;
    cardType = 0;
    currentYear = 14;
    maxExpYears = 30;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Cardform";
    [self initializeVars];
    self.ccNumber.delegate = self;
    self.expYear.delegate = self;
    self.expMonth.delegate = self;
    self.cvvNumber.delegate = self;
    
    self.ccNumber.tag = 0;
    
    [self.ccNumber setReturnKeyType:UIReturnKeyNext];
    [self.expMonth setReturnKeyType:UIReturnKeyNext];
    [self.expYear setReturnKeyType:UIReturnKeyNext];
    [self.cvvNumber setReturnKeyType:UIReturnKeyDone];
    
    [self.errorCCnum setHidden:YES];
    [self.errorCVV setHidden:YES];
    [self.errorDate setHidden:YES];
    self.ccImage.image = [UIImage imageNamed:@"VDKGenericCard"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - Data entry editing

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* currString;
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    
    // If the cursor is in the credit card number area:
    if (textField == ccNumber) {
        
        currString = [[NSString alloc] initWithFormat:@"%@%@", textField.text, string];
       // NSLog(@"TEXT FIELD: %@",textField.text);
       // NSLog(@"STRANG: %@", string);
        if (currString.length == 6) {
            if ([self performCardCheck:currString]) {
                NSLog(@"Valid cc number");
                textField.layer.masksToBounds=YES;
                textField.layer.borderColor=[[UIColor blackColor]CGColor];
                [self.errorCCnum setHidden:YES];
                return YES;
            }
            else {
                NSLog(@"Invalid cc number");
                textField.layer.masksToBounds=YES;
                textField.layer.borderColor=[[UIColor redColor]CGColor];
                textField.layer.borderWidth= 1.0f;
                [self.errorCCnum setHidden:NO];
                return NO;
            }
        }
        
        // If the user manually clears an invalid number, revert to original view
        if (currString.length == 1) {
            textField.layer.masksToBounds=YES;
            textField.layer.borderColor=[[UIColor blackColor]CGColor];
            [self.errorCCnum setHidden:YES];
        }
        
        // Set a maximum length on CC # (15 for AMEX, 16 for else)
        newLength = [textField.text length] + [string length] - range.length;
        if (cardType == AMEX) {
            return (newLength > 15) ? NO : YES;
        }
        return (newLength > 16) ? NO : YES;
    }
    // If the cursor is in the expiration month area:
    else if(textField == expMonth)
    {
        currString = [[NSString alloc] initWithFormat:@"%@%@", textField.text, string];
        
        // Month must be between Jan-Dec (1-12)
        if (currString.length == 2) {
            int substring = [[currString substringToIndex:2] integerValue];
            if (substring < 1 || substring > 12)
            {
                NSLog(@"Invalid month: %d", substring);
                textField.layer.masksToBounds=YES;
                textField.layer.borderColor=[[UIColor redColor]CGColor];
                textField.layer.borderWidth= 1.0f;
                [self.errorDate setHidden:NO];
                return NO;
            }
            else {
                textField.layer.masksToBounds=YES;
                textField.layer.borderColor=[[UIColor blackColor]CGColor];
                textField.layer.borderWidth= 1.0f;
                [self.errorDate setHidden:YES];
                return YES;
            }
        }
        
        // If the user manually clears an invalid month, revert to original view
        if (currString.length == 1) {
            textField.layer.masksToBounds=YES;
            textField.layer.borderColor=[[UIColor blackColor]CGColor];
            [self.errorDate setHidden:YES];
        }
        
        // Set max length to 2
        newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 2) ? NO : YES;
    }
    // If the cursor is in the expiration year area:
    else if(textField == expYear)
    {
        currString = [[NSString alloc] initWithFormat:@"%@%@", textField.text, string];
        
        if (currString.length == 2) {
            int substring = [[currString substringToIndex:2] integerValue];
            int maxYear = currentYear + maxExpYears;
            // Year must be between this year and this year + max expiration years (30 for now)
            if (substring < currentYear || substring > maxYear)
            {
                NSLog(@"Invalid year");
                textField.layer.masksToBounds=YES;
                textField.layer.borderColor=[[UIColor redColor]CGColor];
                textField.layer.borderWidth= 1.0f;
                [self.errorDate setHidden:NO];
                return NO;
            }
            else {
                textField.layer.masksToBounds=YES;
                textField.layer.borderColor=[[UIColor blackColor]CGColor];
                textField.layer.borderWidth= 1.0f;
                [self.errorDate setHidden:YES];
                return YES;
            }
        }
        
        // If the user manually clears an invalid year, revert to original view
        if (currString.length == 1) {
            textField.layer.masksToBounds=YES;
            textField.layer.borderColor=[[UIColor blackColor]CGColor];
            [self.errorDate setHidden:YES];
        }
        
        // Set max length to 2
        newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 2) ? NO : YES;
    }
    // If the cursor is in the CVV area:
    else if(textField == cvvNumber)
    {
        newLength = [textField.text length] + [string length] - range.length;
        if (cardType == AMEX) {
            self.cvvImage.image = [UIImage imageNamed:@"VDKAmexCVV"];
            return (newLength > 4) ? NO : YES;
        }
        self.cvvImage.image = [UIImage imageNamed:@"VDKCVV"];
        
        if (currString.length == 1) {
            textField.layer.masksToBounds=YES;
            textField.layer.borderColor=[[UIColor blackColor]CGColor];
            [self.errorCVV setHidden:YES];
        }
        
        return (newLength > 3) ? NO : YES;
    }

    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    // Clears card image if user clears number & reverts textbox border color
    if (textField == ccNumber) {
        self.ccImage.image = [UIImage imageNamed:@"VDKGenericCard"];
        textField.layer.masksToBounds=YES;
        textField.layer.borderColor=[[UIColor blackColor]CGColor];
        [self.errorCCnum setHidden:YES];
    }
    // Reverts textbox border color
    else if (textField == expMonth || textField == expMonth) {
        textField.layer.masksToBounds=YES;
        textField.layer.borderColor=[[UIColor blackColor]CGColor];
        [self.errorDate setHidden:YES];
    }
    // Reverts textbox border color
    else if (textField == cvvNumber) {
        textField.layer.masksToBounds=YES;
        textField.layer.borderColor=[[UIColor blackColor]CGColor];
        [self.errorCVV setHidden:YES];

    }
    return YES;
}

# pragma mark - Keyboard twitching (no standard "Next"and "Done" for numberpads

// Navigate through text fields
//-(BOOL)textFieldShouldReturn:(UITextField*)textField
//{
//    BOOL didResign = [textField resignFirstResponder];
//    if (!didResign) return NO;
//    
//    if ([textField isKindOfClass:[SOTextField class]])
//        dispatch_async(dispatch_get_current_queue(),
//                       ^ { [[(SOTextField *)textField nextField] becomeFirstResponder]; });
//    
//return YES;
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//}
//
//-(void)doneWithNumberPad{
//    NSString *numberFromTheKeyboard = numberTextField.text;
//    [numberTextField resignFirstResponder];
//}

//- (IBAction)dismissKeyboard:(id)sender;
//{
//    [ccNumber becomeFirstResponder];
//    [ccNumber resignFirstResponder];
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [ccNumber resignFirstResponder];
    [expYear resignFirstResponder];
    [expMonth resignFirstResponder];
    [cvvNumber resignFirstResponder];
}

# pragma mark - first 6 number CC number validity

// Method to check if the credit card number the user entered is correct.
// - Checks while entering to see if character set is valid9
- (BOOL)performCardCheck:(NSString*) currString
{
    // Check for VISA type (since it's only 1 digit)
    int substring = [[currString substringToIndex:1] integerValue];
    if([currString characterAtIndex:0] == '4')
    {
        cardType = VISA;
        self.ccImage.image = [UIImage imageNamed:@"VDKVisa"];
        return YES;
    }

    // Check for Mastercard, Discover, Diners, or Amex
    substring = [[currString substringToIndex:2] integerValue];
    if (substring == 34 || substring == 37)
    {
        self->cardType = self->AMEX;
        self.ccImage.image = [UIImage imageNamed:@"VDKAmex"];
        return YES;
    }
    else if (substring == 65)
    {
        self->cardType = self->DISCOVER;
        self.ccImage.image = [UIImage imageNamed:@"VDKDiscover"];
        return YES;
    }
    else if(substring >= 50 && substring <= 53)
    {
        self->cardType = self->MSTR;
        self.ccImage.image = [UIImage imageNamed:@"VDKMastercard"];
        return YES;
    }
    else if(substring == 54 || substring == 55)
    {
        // TRICKY: Could be either Mastercard or Diners. Return generic.
        cardType = GENERIC;
        self.ccImage.image = [UIImage imageNamed:@"VDKGenericCard"];
        return YES;
    }
    
    // check if first three digits are in range for DISCOVER
    substring = [[currString substringToIndex:3] integerValue];
    if (substring >= 644 && substring <=649) {
        cardType = DISCOVER;
        self.ccImage.image = [UIImage imageNamed:@"VDKDiscover"];
        return YES;
    }
    
    // check if first four digits are in range for DISCOVER
    substring = [[currString substringToIndex:4] integerValue];
    if (substring == 6011) {
        cardType = DISCOVER;
        self.ccImage.image = [UIImage imageNamed:@"VDKDiscover"];
        return YES;
    }
    else if(substring >= 3528 && substring <= 3589)
    {
        cardType = JCB;
        self.ccImage.image = [UIImage imageNamed:@"VDKJCB"];
        return YES;
    }
    
    // Check for Discover range again
    substring = [[currString substringToIndex:6] integerValue];
    if (substring >= 622126 && substring <= 622925)
    {
        cardType = DISCOVER;
        self.ccImage.image = [UIImage imageNamed:@"VDKDiscover"];
        return YES;
    }
    
    // Otherwise, the user has entered an invalid number.
    return NO;
}


#pragma mark - Perform Luhn algorithm and submit

- (IBAction)submitData:(id)sender
{
    UIAlertView* alert;
    if (cvvNumber.text.length == 4 && cardType != AMEX) {
        alert = [[UIAlertView alloc] initWithTitle: @"Result"
                                           message: @"Invalid CVV. Only 3 digits."
                                          delegate: nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    }
    else if(cvvNumber.text.length == 3 && cardType == AMEX) {
        alert = [[UIAlertView alloc] initWithTitle: @"Result"
                                           message: @"Invalid CVV. 4 Digits required for AMEX"
                                          delegate: nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    }
    
    BOOL isValid = [Luhn validateString:[self.ccNumber.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    if (isValid) {
        alert = [[UIAlertView alloc] initWithTitle: @"Result"
                                           message: @"Success!"
                                          delegate: nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    }
    else {
        alert = [[UIAlertView alloc] initWithTitle: @"Result"
                                           message: @"Invalid credit card number. Please fix."
                                          delegate: nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    }
    
    [alert show];
}
@end
