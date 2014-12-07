//
//  IVRageIAPHelper.m
//
//
//  Created by Igor Vasilenko on 06/12/14.
//  Copyright (c) 2014 Igor Vasilenko. All rights reserved.
//

#import "IVRageIAPHelper.h"

@implementation IVRageIAPHelper

+ (IVRageIAPHelper*) sharedInstance
{
    
    static dispatch_once_t once;
    static IVRageIAPHelper* sharedInstance;
    
    dispatch_once(&once, ^{
        
        NSSet* productIdentifiers = [NSSet setWithObjects:@"",@"",@"",@"",nil]; // here your ID products, that you create in iTunes Connect.
        
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
        
    });
    
    return sharedInstance;
}

@end
