//
//  MJXSelectGroupTableViewCell.m
//  XinSuiFang
//
//  Created by majinxing on 16/11/23.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXSelectGroupTableViewCell.h"
#import "MJXGroup.h"

@interface MJXSelectGroupTableViewCell ()
@property (nonatomic,strong) UILabel * groupName;
@property (nonatomic,strong) UIButton * selectBtn;
@property (nonatomic,strong) UIImageView * selectImage;
@property (nonatomic,strong) UIView * lineH;
@property (nonatomic,assign) int sign;
@end
@implementation MJXSelectGroupTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        _groupName = [[UILabel alloc] init];
        _groupName.font = [UIFont systemFontOfSize:15];
        _groupName.textColor = [UIColor colorWithHexString:@"#333333"];
        
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectImage = [[UIImageView alloc] init];
        _sign = 0;
        
        _lineH = [[UIView alloc] init];
    }
    return self;
}
-(void)selectGroup:(MJXGroup *)g withTag:(int)tag{
    _groupName.frame = CGRectMake(16, 16, 180, 17);
    _groupName.text = g.gName;
    [self.contentView addSubview:_groupName];
    _selectBtn.frame = CGRectMake(APPLICATION_WIDTH-60, 0,60, 50);
    
    _selectImage.frame = CGRectMake(APPLICATION_WIDTH-35,18, 15, 15);
    _selectImage.image = [UIImage imageNamed:@"ｙｅｓ"];
    [self.contentView addSubview:_selectImage];
    
    _selectBtn.tag = tag;
    [_selectBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_selectBtn];
    
    _lineH.frame = CGRectMake(0, 49, APPLICATION_WIDTH, 1);
    _lineH.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    [self.contentView addSubview:_lineH];
}
-(void)selectBtn:(UIButton *)btn{
    if (_sign == 0) {
        _selectImage.image = [UIImage imageNamed:@"xuanzhong"];
        _sign = 1;
    }else{
        _selectImage.image = [UIImage imageNamed:@"ｙｅｓ"];
        _sign = 0;
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectBtnPressed:)]) {
        [self.delegate selectBtnPressed:btn];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
