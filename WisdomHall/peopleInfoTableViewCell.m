//
//  peopleInfoTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/8/1.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "peopleInfoTableViewCell.h"

@interface peopleInfoTableViewCell()
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *peopleName;

@end
@implementation peopleInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 20;
    // Initialization code
}
-(void)addContViewWith:(SignPeople *)s{
    _peopleName.text = s.name;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
