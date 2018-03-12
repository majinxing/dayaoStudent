//
//  SGQRCodeScanningVC.h
//  SGQRCodeExample
//
//  Created by kingsic on 17/3/20.
//  Copyright © 2017年 kingsic. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnTextBlock)(NSDictionary *returnText);

@interface SGQRCodeScanningVC : UIViewController
@property (nonatomic, copy) ReturnTextBlock returnTextBlock;
- (void)returnText:(ReturnTextBlock)block;
@end
