//
//  Luhn.m
//  Cardform
//
//  Created by Issa Araj on 1/28/14.
//  Copyright (c) 2014 Issa Araj. All rights reserved.
//

#import "Luhn.h"

@implementation Luhn

+ (BOOL) validateString:(NSString *) _string {
    
    NSMutableString *reversedString = [NSMutableString stringWithCapacity:[_string length]];
    
    [_string enumerateSubstringsInRange:NSMakeRange(0, [_string length]) options:(NSStringEnumerationReverse |NSStringEnumerationByComposedCharacterSequences) usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [reversedString appendString:substring];
    }];
    
    unsigned int odd_sum = 0, even_sum = 0;
    
    for (int i = 0; i < [reversedString length]; i++) {
        
        NSInteger digit = [[NSString stringWithFormat:@"%C", [reversedString characterAtIndex:i]] integerValue];
        
        if (i % 2 == 0) {
            odd_sum += digit;
            
        }
        
        else {
            
            even_sum += digit / 5 + ( 2 * digit) % 10;
        }
        
    }
    
    return (odd_sum + even_sum) % 10 == 0;
    
}

@end