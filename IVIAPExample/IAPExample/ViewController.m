//
//  ViewController.m
//  IAPExample
//
//  Created by Igor Vasilenko on 07/12/14.
//  Copyright (c) 2014 Igor Vasilenko. All rights reserved.
//

#import "ViewController.h"
#import "IVRageIAPHelper.h"

@interface ViewController ()
{
    NSArray* _products;
}

@end

@implementation ViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _products = nil;
        [[IVRageIAPHelper sharedInstance] requestProductWithCompletionHandler:^(BOOL success, NSArray *products) {
                
        if (success) {
            NSLog(@"List products: %@", products);
            _products = products;
        }
            
        }];
            
}
    
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    SKProduct* product = _products[productOne]; // get product with index, that we need;
    NSLog(@"Product: %@", product.productIdentifier);
    [[IVRageIAPHelper sharedInstance] buyProduct:product];
    
    /**** THAT'S ALL ****/
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
