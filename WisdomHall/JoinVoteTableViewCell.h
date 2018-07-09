//
//  JoinVoteTableViewCell.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/7.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol  JoinVoteTableViewCellDelegate<NSObject>
-(void)voteBtnDelegatePressed:(UIButton *)btn;

@end
@interface JoinVoteTableViewCell : UITableViewCell
@property (nonatomic,weak)id<JoinVoteTableViewCellDelegate>delegate;

-(void)setTileOrdescribe:(NSString *)title withLableText:(NSString *)labelText withVoteState:(NSString *)voteStatus selfState:(NSString *)state;

-(void)setSelectText:(NSString *)selectText withTag:(int)tag withSelect:(NSString *)select;

-(void)setQuestionContent:(NSString *)str;

@end
