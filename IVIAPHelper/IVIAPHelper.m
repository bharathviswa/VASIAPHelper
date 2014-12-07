//
//  IVIAPHelper.m
//
//
//  Created by Igor Vasilenko on 06/12/14.
//  Copyright (c) 2014 Igor Vasilenko. All rights reserved.
//

#import "IVIAPHelper.h"
#import <StoreKit/StoreKit.h>

@interface IVIAPHelper() <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    SKProductsRequest* _productRequest;
    RequestProductsCompletionHandler _completionHandler;
    NSSet* _productsIdentifiers;
    NSMutableSet* _purchasedProductIdentifiers;
}

@end

@implementation IVIAPHelper

- (id) initWithProductIdentifiers:(NSSet *)productIdentifiers
{
    if ((self = [super init])) {
        
        _productsIdentifiers = productIdentifiers;
        _purchasedProductIdentifiers = [NSMutableSet set];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        for (NSString* productIdentifier in _productsIdentifiers)
        {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            
            if (productPurchased) {
                [_purchasedProductIdentifiers addObject:productIdentifier];
                NSLog(@"Previosly purchased: %@", productIdentifier);
            } else {
                
                NSLog(@"not purchased: %@", productIdentifier);
            }
        }
        
        }
    
    return self;
}

// request list products

- (void) requestProductWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler
{
    
    _completionHandler = [completionHandler copy];
    
    _productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productsIdentifiers];
    _productRequest.delegate = self;
    [_productRequest start];
    
}

#pragma mark - SKProductsRequestDelegate

// find all products

- (void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    
    NSLog(@"Loaded list products...");
    _productRequest = nil;
    
    NSArray* skProducts = response.products;
    for (SKProduct* skProduct in skProducts) {
        NSLog(@"Found product: %@ %@ %f", skProduct.productIdentifier, skProduct.localizedTitle, skProduct.price.floatValue);
    }
    
    _completionHandler(YES, skProducts);
    _completionHandler = nil;
}

// if fail, when you request list

- (void) request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"Failed to load list products.");
    _completionHandler = nil;
    
    _completionHandler (NO, nil);
    _completionHandler = nil;
    
}

#pragma mark - SKPaymentTransactionObserver

// product purchased (YES/NO)

- (BOOL) productPurchased: (NSString*) productIdentifier
{
    return [_purchasedProductIdentifiers containsObject:productIdentifier];
}

//*********** buy product **********//

- (void) buyProduct: (SKProduct*) product
{
    NSLog(@"Buying %@...", product.productIdentifier);
    SKPayment* payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

// payment queue

- (void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    
    for (SKPaymentTransaction* transaction in transactions) {
        
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction: transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction: transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction: transaction];
                break;
            default:
                break;
        }
    }
}

// if complete transaction

- (void) completeTransaction: (SKPaymentTransaction*) transaction
{
    NSLog(@"Complete transaction!");
    [self provideContentForProductIdentifier: transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

// if fail transaction

- (void) failedTransaction: (SKPaymentTransaction*) transaction
{
    NSLog(@"Failed transaction!");
    if (transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

// if we want restore product transaction

- (void) restoreTransaction: (SKPaymentTransaction*) transaction
{
    NSLog(@"Restore transaction!");
    
    [self provideContentForProductIdentifier: transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

// save our purchased products

- (void) provideContentForProductIdentifier: (NSString*) productIdentifier
{
    [_purchasedProductIdentifiers addObject:productIdentifier];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
}

@end
