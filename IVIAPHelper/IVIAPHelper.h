//
//  IVIAPHelper.h
//
//
//  Created by Igor Vasilenko on 06/12/14.
//  Copyright (c) 2014 Igor Vasilenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray* products);
UIKIT_EXTERN NSString* const IAPHelperProductPurchasedNotification;

@interface IVIAPHelper : NSObject

- (id) initWithProductIdentifiers: (NSSet*) productIdentifiers;
- (void) requestProductWithCompletionHandler: (RequestProductsCompletionHandler) completionHandler;

- (void) buyProduct: (SKProduct*) product;
- (BOOL) productPurchased: (NSString*) productIdentifier;

@end
