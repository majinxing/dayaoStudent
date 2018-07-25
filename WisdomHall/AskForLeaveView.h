//
//  AskForLeaveView.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/21.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "peopleListView.h"
#import "IMGroupModel.h"

@protocol AskForLeaveViewDelegate<NSObject>
-(void)addPeopleBtnPressedDelegae;
-(void)outSelfViewDelegate;
-(void)endEditeDelegate;

-(void)askForLeaveWithReationDelegate:(NSString *)reasionStr;
-(void)picturebtnPressedDelegate:(UIButton *)btn;
@end
@interface AskForLeaveView : UIView
@property (nonatomic,strong)peopleListView * peopleListView;

@property (nonatomic,weak)id<AskForLeaveViewDelegate>delegate;

@property (nonatomic,strong)UIButton * picturebtn;

-(void)addContentViewWithAry:(NSMutableArray *)ary;

@end
