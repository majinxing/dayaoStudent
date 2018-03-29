//
//  MJXWordProcessingViewController.h
//  XinSuiFang
//
//  Created by majinxing on 16/9/7.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnTextBlock)(NSString *returnText);

@interface MJXWordProcessingViewController : UIViewController
@property (nonatomic,copy) NSString *titleStr;
@property (nonatomic, copy) ReturnTextBlock returnTextBlock;
- (void)returnText:(ReturnTextBlock)block;
@end





