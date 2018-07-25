//
//  StatisticalTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/1/29.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "StatisticalTableViewCell.h"
#import "DYHeader.h"

@interface StatisticalTableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *textLabelStr;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (strong, nonatomic) IBOutlet UIImageView *departmentImage;
@property (strong, nonatomic) IBOutlet UIImageView *classImage;
@property (strong, nonatomic) IBOutlet UIButton *departmentBtn;
@property (strong, nonatomic) IBOutlet UIButton *classbtn;

@end
@implementation StatisticalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _selectBtn.layer.masksToBounds = YES;
    _selectBtn.layer.cornerRadius = 20;
    
//    _selectBtn.backgroundColor = [[ThemeTool shareInstance] getThemeColor];
    // Initialization code
}
-(void)addContentView:(NSString *)titleStr withText:(NSString *)textStr{
    _titleLabel.text = titleStr;
    _textLabelStr.text = [NSString stringWithFormat:@"%@   >",textStr];
}
-(void)addContentThirdView:(int)temp{
    if (temp == 0) {
        
        _departmentImage.image = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"方形选中-fill"]];
        _classImage.image = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"方形未选中"]];
    }else{
        _departmentImage.image = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"方形未选中"]];
        _classImage.image = [[Appsetting sharedInstance] grayscale:[UIImage imageNamed:@"方形选中-fill"]];
    }
}
- (IBAction)selectBtnPressed:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectBtnPressedDelegate:)]) {
        [self.delegate selectBtnPressedDelegate:sender];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)departmentPressed:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(departmentPressedDelegate:)]) {
        [self.delegate departmentPressedDelegate:sender];
    }
}

- (IBAction)classPressed:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(classPressedDelegate:)]) {
        [self.delegate classPressedDelegate:sender];
    }
}
@end
