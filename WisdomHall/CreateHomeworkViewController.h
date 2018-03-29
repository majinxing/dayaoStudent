//
//  CreateHomeworkViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/3/23.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassModel.h"
#import "Homework.h"

@interface CreateHomeworkViewController : UIViewController
@property (nonatomic,strong)ClassModel * c;
@property (nonatomic,strong)Homework * homeworkModel;
@property (nonatomic,assign) BOOL edit;
@end
