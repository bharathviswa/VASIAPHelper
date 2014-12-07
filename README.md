IVIAPHelper
=======================================================================================================

Little lib that help you to implement In-App Purchases in your apps!

====================  How use ==================

1. Create In-App Purchase product ID in your account iTunes Connect
2. Drag library IVIAPHelper in your project
3. Open IVRageIAPHelper and add in NSSet your product identidiers
4. In IVRageIAPHelper add your tag list products with indexes
5. Import StoreKit framework in your project 

In your buy class implement this:

1. Add array in @interface
=========
@interface ViewController () {
    NSArray* _products;
}

2. Init list products in array
=========
        _products = nil;
        [[IVRageIAPHelper sharedInstance] requestProductWithCompletionHandler:^(BOOL success, NSArray *products) {
                
        if (success) {
            NSLog(@"List products: %@", products);
            _products = products;
        }
            
        }];
        
3. Buy product:
============
    SKProduct* product = _products[productOne]; // get product with index, that we need;
    NSLog(@"Product: %@", product.productIdentifier);
    [[IVRageIAPHelper sharedInstance] buyProduct:product];
