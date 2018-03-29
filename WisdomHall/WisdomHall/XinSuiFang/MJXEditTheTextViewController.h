//
//  MJXEditTheTextViewController.h
//  XinSuiFang
//
//  Created by majinxing on 16/9/13.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReturnTextBlock)(NSString *returnText);
@interface MJXEditTheTextViewController : UIViewController
@property (nonatomic,strong)NSString *titleStr;
@property (nonatomic, copy) ReturnTextBlock returnTextBlock;
- (void)returnText:(ReturnTextBlock)block;
@end
