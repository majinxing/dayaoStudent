//
//  SelectGroupPeopleViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/19.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^returnSelectPeopleAry)(NSMutableArray * selectAry);

@interface SelectGroupPeopleViewController : UIViewController

@property (nonatomic,strong)NSMutableArray  * dataAry;

@property (nonatomic,copy)returnSelectPeopleAry  returnSelectAryBlock;

- (void)returnSelectPeopleAry:(returnSelectPeopleAry)block;

@end
