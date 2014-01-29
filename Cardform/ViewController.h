//
//  ViewController.h
//  Cardform
//
//  Created by Issa Araj on 1/28/14.
//  Copyright (c) 2014 Issa Araj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *ccNumber;
@property (weak, nonatomic) IBOutlet UIImageView *ccImage;
@property (weak, nonatomic) IBOutlet UITextField *expMonth;
@property (weak, nonatomic) IBOutlet UITextField *expYear;
@property (weak, nonatomic) IBOutlet UITextField *cvvNumber;
@property (weak, nonatomic) IBOutlet UIImageView *cvvImage;

- (IBAction)submitData:(id)sender;

@end
