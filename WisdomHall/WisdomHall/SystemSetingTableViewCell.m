//
//  SystemSetingTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/8.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "SystemSetingTableViewCell.h"
#import "DYHeader.h"
#import "UIImageView+WebCache.h"

@interface SystemSetingTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *workNumber;

@property (weak, nonatomic) IBOutlet UIImageView *setingImage;
@property (strong, nonatomic) IBOutlet UIButton *outBtn;


@property (nonatomic,strong)NSArray * textAry;
@end
@implementation SystemSetingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (!_textAry) {
      _textAry = [NSArray arrayWithObjects:@"个人资料",@"群组",@"主题",@"系统设置",@"关于我们",@"意见反馈",nil];
    }
    _user = [[Appsetting sharedInstance] getUsetInfo];
    _headImage.layer.masksToBounds = YES;
    _headImage.layer.cornerRadius = 55;
    _outBtn.backgroundColor = [[Appsetting sharedInstance] getThemeColor];
    // Initialization code
}
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"";//对应xib中设置的identifier
    NSInteger index = 0; //xib中第几个Cell
    switch (indexPath.section) {
        case 0:
            identifier = @"SystemSetingTableViewCellSecond";
            index = 1;
            break;
        case 1:
            identifier = @"SystemSetingTableViewCellThird";
            index = 2;
        default:
            break;
    }
    SystemSetingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SystemSetingTableViewCell" owner:self options:nil] objectAtIndex:index];
    }
  
    if (indexPath.section == 1) {
        cell.setingLabel.text = cell.textAry[indexPath.row];
        
    }else if (indexPath.section == 0){
        cell.userName.text = cell.user.userName;
        cell.workNo.text = cell.user.studentId;
        cell.workNo.textColor = [UIColor blackColor];
        UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
        if (![UIUtils isBlankString:[NSString stringWithFormat:@"%@",user.userHeadImageId]]) {
            UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
            NSString * baseUrl = user.host;
            [cell.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?resourceId=%@",baseUrl,FileDownload,user.userHeadImageId]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            cell.headImage.frame = CGRectMake(18, 18, 110, 100);
        }
        
        if ([[NSString stringWithFormat:@"%@",user.identity] isEqualToString:@"1"]) {
            cell.workNumber.text = @"工号";
        }
    }
    return cell;
}
- (IBAction)outAppBtn:(UIButton *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(outAPPBtnPressedDelegate)]) {
        [self.delegate outAPPBtnPressedDelegate];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
