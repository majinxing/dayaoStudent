//
//  MJXAddQuickReplyViewController.h
//  XinSuiFang
//
//  Created by majinxing on 16/11/4.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnTextBlock)(NSString *returnText);

@interface MJXAddQuickReplyViewController : UIViewController
@property (nonatomic, copy) ReturnTextBlock returnTextBlock;

- (void)returnText:(ReturnTextBlock)block;
@end
