//
//  VoteViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/1.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingModel.h"
#import "ClassModel.h"
@interface VoteViewController : UIViewController
@property (nonatomic,strong)MeetingModel * meetModel;
@property(nonatomic,strong)ClassModel * classModel;
@property(nonatomic,copy)NSString * type;
@end
