//
//  CreateCouresTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/7/14.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "CreateCouresTableViewCell.h"

@interface CreateCouresTableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *workNoLabel;
@property (strong, nonatomic) IBOutlet UIImageView *selectImage;
@property (strong, nonatomic) IBOutlet UIButton *selectBtn;

@end
@implementation CreateCouresTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setContenView:(SignPeople *)s withIndex:(NSInteger)n{
    _nameLabel.text = [NSString stringWithFormat:@"姓名：%@",s.name];
    _workNoLabel.text = [NSString stringWithFormat:@"学号：%@",s.workNo];
    if (s.isSelect) {
        _selectImage.image = [UIImage imageNamed:@"方形选中-fill"];
    }else{
        _selectImage.image = [UIImage imageNamed:@"方形未选中"];
    }
    _selectBtn.tag = n+1;
}
- (IBAction)selectPeopleButton:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(signPeopleBtnPressed:)]) {
        [self.delegate signPeopleBtnPressed:sender];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
