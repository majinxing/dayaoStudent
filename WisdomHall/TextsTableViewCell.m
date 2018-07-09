//
//  TextsTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/8.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "TextsTableViewCell.h"
#import "DYHeader.h"

@interface TextsTableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *textName;
@property (strong, nonatomic) IBOutlet UILabel *score;
@property (strong, nonatomic) IBOutlet UILabel *textState;
@property (strong, nonatomic) IBOutlet UIView *backView;

@property (nonatomic,strong)UIScrollView * s;
@end

@implementation TextsTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    
    _backView.layer.masksToBounds = YES;

    _backView.layer.cornerRadius = 10;
    
    self.backgroundColor = [UIColor clearColor];
    
    _textState.layer.masksToBounds = YES;
    _textState.layer.cornerRadius = 10;
    
    CGRect rect = CGRectMake(0, 0, 70, 30);
    
    CGSize radio = CGSizeMake(15, 15);//圆角尺寸
    
    UIRectCorner corner = UIRectCornerTopLeft|UIRectCornerBottomLeft;//这只圆角位置
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corner cornerRadii:radio];
    
    CAShapeLayer *masklayer = [[CAShapeLayer alloc]init];
    
    //创建shapelayer
    masklayer.frame = _score.bounds;
    masklayer.path = path.CGPath;
    //设置路径
    _score.layer.mask = masklayer;
    
    
  
    // Initialization code
}

-(void)addContentView:(TextModel *)t withIndex:(int)n{
    
    _textName.text = [NSString stringWithFormat:@"%@",t.title];
    
   
    _textState.text = [NSString stringWithFormat:@"%@",t.statusName];
    if (![t.statusName isEqualToString:@"进行中"]) {
        if ([t.resultStatus isEqualToString:@"2"]) {
            _score.text = [NSString stringWithFormat:@"%@分",t.score];
            _score.backgroundColor = RGBA_COLOR(222, 30, 30, 1);
        }else{
            _score.text = [NSString stringWithFormat:@"未批阅"];
            _score.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
        }
    }
    _moreBtn.tag = n;
    
    
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
