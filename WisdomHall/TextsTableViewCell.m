//
//  TextsTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/8.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "TextsTableViewCell.h"


@interface TextsTableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *textName;
@property (strong, nonatomic) IBOutlet UILabel *score;
@property (strong, nonatomic) IBOutlet UILabel *textState;


@end

@implementation TextsTableViewCell

-(void)addContentView:(TextModel *)t withIndex:(int)n{
    _textName.text = [NSString stringWithFormat:@"测验标题：%@",t.title];
    _score.text = [NSString stringWithFormat:@"总分：%@",t.score];
    _textState.text = [NSString stringWithFormat:@"%@",t.statusName];
    _moreBtn.tag = n;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    _textState.layer.masksToBounds = YES;
    _textState.layer.cornerRadius = 10;
    
    // Initialization code
}
- (IBAction)moreBtnPressed:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(moreBtnPressedDelegate:)]) {
        [self.delegate moreBtnPressedDelegate:_moreBtn];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
