//
//  MeetingTableViewCell.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/10/24.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingModel.h"
#import "ClassModel.h"

@protocol MeetingTableViewCellDelegate <NSObject>
-(void)shareButtonClickedDelegate:(NSString *)platform;
-(void)peopleManagementDelegate;
-(void)signNOPeopleDelegate;
-(void)signBtnPressedDelegate:(UIButton *)btn;
-(void)codePressedDelegate:(UIButton *)btn;
@end
@interface MeetingTableViewCell : UITableViewCell
@property(nonatomic,weak)id<MeetingTableViewCellDelegate>delegate;

-(void)addFirstContentView:(MeetingModel *)meetModel;
-(void)addSecondContentView:(MeetingModel *)meetModel;
-(void)addFourthContentView:(MeetingModel *)meetModel;
-(void)addThirdContentView:(MeetingModel *)meetModel isEnable:(BOOL)isEnable;

//class
-(void)addFirstCOntentViewWithClassModel:(ClassModel *)classModel;
-(void)addSecondContentViewWithClassModel:(ClassModel *)classModel;
-(void)addFourthContentViewWithClassModel:(ClassModel *)classModel;
-(void)addThirdContentViewWithClassModel:(ClassModel *)meetModel isEnable:(BOOL)isEnable;
@end
