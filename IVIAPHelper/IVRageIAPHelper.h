//
//  IVRageIAPHelper.h
//
//
//  Created by Igor Vasilenko on 06/12/14.
//  Copyright (c) 2014 Igor Vasilenko. All rights reserved.
//

#import "IVIAPHelper.h"

// type products list with index
#define productOne 0 // comment product
#define productTwo 1 // comment product
#define productThree 2 // comment product
#define productFour 3 // comment product
// add more....

@interface IVRageIAPHelper : IVIAPHelper

+ (IVRageIAPHelper*) sharedInstance;

@end
