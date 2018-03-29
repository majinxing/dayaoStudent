//
//  ConversationVC.h
//  EMChatText
//
//  Created by zzjd on 2017/3/17.
//  Copyright © 2017年 zzjd. All rights reserved.
//语音聊天界面

#import <UIKit/UIKit.h>
#import <Hyphenate/Hyphenate.h>
#import "EMCallOptions+NSCoding.h"

typedef enum{
    CALLED,//被叫
    CALLING,//主叫
}CallType;


@interface ConversationVC : UIViewController

@property (nonatomic,copy) NSString * teacherName;

@property (nonatomic,copy)NSString *HyNumaber;

@property (nonatomic,assign)int type;

@property (nonatomic,strong)EMCallSession *callSession;

@property (nonatomic,assign)BOOL isSender;

@property (nonatomic,assign)CallType call;
@end
