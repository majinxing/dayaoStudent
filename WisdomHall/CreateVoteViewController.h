//
//  CreateVoteViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/2.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingModel.h"
#import "ClassModel.h"
@interface CreateVoteViewController : UIViewController
@property (nonatomic,strong)MeetingModel * meetModel;
@property (nonatomic,strong)ClassModel  *classModel;
@property (nonatomic,copy)NSString * type;
@end
