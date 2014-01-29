//
//  Luhn.h
//  Cardform
//
//  Created by Issa Araj on 1/28/14.
//  Copyright (c) 2014 Issa Araj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Luhn : NSObject

+ (BOOL) validateString:(NSString *) ccString;

@end