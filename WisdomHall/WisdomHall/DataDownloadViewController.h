//
//  DataDownloadViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/21.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingModel.h"
#import "ClassModel.h"
@interface DataDownloadViewController : UIViewController
@property(nonatomic,strong)MeetingModel * meeting;
@property(nonatomic,strong)ClassModel * classModel;
@property(nonatomic,copy)NSString * type;
@property(nonatomic,copy)NSString * function;
@end
