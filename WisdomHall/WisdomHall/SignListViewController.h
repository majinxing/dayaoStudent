//
//  SignListViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/6.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingModel.h"
#import "ClassModel.h"
/**
 *  查询数据的类型
 **/
typedef enum {
    SignClassRoom,
    SignMeeting,
}SignType;
@interface SignListViewController : UIViewController
@property (nonatomic,assign)SignType  signType;
@property (nonatomic,strong)MeetingModel * meetingModel;
@property (nonatomic,strong)ClassModel * classModel;
@property (nonatomic,strong)NSMutableArray * ary;
@end
