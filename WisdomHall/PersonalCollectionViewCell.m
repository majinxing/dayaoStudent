//
//  PersonalCollectionViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/4.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "PersonalCollectionViewCell.h"
#import "MeetingModel.h"
#import "SignPeople.h"
#import "DYHeader.h"
#import "UIImageView+WebCache.h"

@interface PersonalCollectionViewCell()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *workNo;
@property (strong, nonatomic) IBOutlet UIImageView *headImage;


@end
@implementation PersonalCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    _headImage.layer.masksToBounds = YES;
//    _headImage.layer.cornerRadius = 30;
    // Initialization code
}
-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"PersonalCollectionViewCell" owner:self options:nil].lastObject;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
-(void)setPersonalInfo:(SignPeople *)sign{
    SignPeople * s = sign;
    _nameLabel.text = [NSString stringWithFormat:@"姓名：%@",s.name];
    _workNo.text = [NSString stringWithFormat:@"学号：%@",s.workNo];
    _workNo.font = [UIFont systemFontOfSize:11];
    _workNo.textAlignment = NSTextAlignmentLeft;
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    NSString * baseURL = user.host;
    if (![UIUtils isBlankString:[NSString stringWithFormat:@"%@",sign.pictureId]]) {
        
        [_headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?resourceId=%@",baseURL,FileDownload,sign.pictureId]] placeholderImage:[UIImage imageNamed:@"sign.png"]];
    }
}
@end
