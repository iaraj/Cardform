//
//  ViewController.h
//  Cardform
//
//  Created by Issa Araj on 1/28/14.
//  Copyright (c) 2014 Issa Araj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UITextField *ccNumber;
@property (weak, nonatomic) IBOutlet UIImageView *ccImage;
@property (weak, nonatomic) IBOutlet UITextField *expMonth;
@property (weak, nonatomic) IBOutlet UITextField *expYear;
@property (weak, nonatomic) IBOutlet UITextField *cvvNumber;
@property (weak, nonatomic) IBOutlet UIImageView *cvvImage;

@property (weak, nonatomic) IBOutlet UILabel *errorCCnum;
@property (weak, nonatomic) IBOutlet UILabel *errorDate;
@property (weak, nonatomic) IBOutlet UILabel *errorCVV;

- (IBAction)submitData:(id)sender;
//- (BOOL)performCardCheck:(NSString*) currString;

@end
