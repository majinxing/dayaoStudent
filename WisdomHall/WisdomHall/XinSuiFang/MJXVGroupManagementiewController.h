//
//  MJXVGroupManagementiewController.h
//  XinSuiFang
//
//  Created by majinxing on 16/9/8.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnTextBlock)(NSString *returnText);

@interface MJXVGroupManagementiewController : UIViewController
@property (nonatomic,strong)NSMutableArray *array;
@property (nonatomic,strong)NSString *NN;//判断是否是选择分组可以跳转
@property (nonatomic,strong)NSString *choose;

@property (nonatomic, copy) ReturnTextBlock returnTextBlock;
- (void)returnText:(ReturnTextBlock)block;
@end
