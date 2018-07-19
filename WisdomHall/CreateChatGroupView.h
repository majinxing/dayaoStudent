//
//  CreateChatGroupView.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/18.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "peopleListView.h"
#import "IMGroupModel.h"

@protocol CreateChatGroupViewDelegate<NSObject>
-(void)addPeopleBtnPressedDelegae;
-(void)outSelfViewDelegate;
-(void)endEditeDelegate;
-(void)createGroupBtnPressedDelegate:(IMGroupModel *)imGroupModel;
@end
@interface CreateChatGroupView : UIView

@property (nonatomic,strong)peopleListView * peopleListView;

@property (nonatomic,weak)id<CreateChatGroupViewDelegate>delegate;

-(void)addContentViewWithAry:(NSMutableArray *)ary;

@end
