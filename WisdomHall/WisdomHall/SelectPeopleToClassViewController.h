//
//  SelectPeopleToClassViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/7/13.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYHeader.h"

typedef void(^RreturnTextBlock)(NSMutableArray *returnText);

@interface SelectPeopleToClassViewController : UIViewController

@property (nonatomic, copy) RreturnTextBlock returnTextBlock;

@property (nonatomic,strong) NSMutableArray * selectPeople;

- (void)returnText:(RreturnTextBlock)block;

@end
