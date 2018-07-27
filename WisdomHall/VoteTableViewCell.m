//
//  VoteTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/1.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "VoteTableViewCell.h"


@interface VoteTableViewCell()

@property (strong, nonatomic) IBOutlet UILabel *voteState;

@property (strong, nonatomic) IBOutlet UILabel *voteCreateTime;
@property (strong, nonatomic) IBOutlet UILabel *voteTitle;

@property (assign,nonatomic) int temp;

@end
@implementation VoteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addContentView];
    
    // Initialization code
}
-(void)addContentView{
    _voteState.layer.masksToBounds = YES;
    _voteState.layer.cornerRadius = 10;
    
    _voteState.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
    
    _voteState.textColor = [UIColor colorWithRed:0/255.0 green:118/255.0 blue:253/255.0 alpha:1/1.0];
    
    _voteTitle.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    
    _voteTitle.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    
    _voteCreateTime.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    _voteCreateTime.textColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1/1.0];
}
-(void)voteTitle:(NSString *)title withCreateTime:(NSString *)time withState:(NSString *)state withIndex:(int)n withVoteStatus:(NSString *)voteStatus{
    
    _voteTitle.text = [NSString stringWithFormat:@"%@",title];
    
    if (![UIUtils isBlankString:time]) {
        _voteCreateTime.text = [NSString stringWithFormat:@"%@",time];

    }
    
    _voteState.text = [NSString stringWithFormat:@"%@:%@",voteStatus,state];
    
    _temp = n;
    
}
- (IBAction)more:(UIButton *)btn {
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(moreVoteTableViewCellDelegate:)]) {
        btn.tag = _temp;
        [self.delegate moreVoteTableViewCellDelegate:btn];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
