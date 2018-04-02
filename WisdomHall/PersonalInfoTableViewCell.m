//
//  PersonalInfoTableViewCell.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/8.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "PersonalInfoTableViewCell.h"
#import "SignPeople.h"
#import "DYHeader.h"
#import "UIImageView+WebCache.h"


@interface PersonalInfoTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *workNo;

@property (strong, nonatomic) IBOutlet UILabel *signNumber;

@end
@implementation PersonalInfoTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }return self;
}
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath array:(NSMutableArray *)ary{
    NSString *identifier = @"";//对应xib中设置的identifier
    NSInteger index = 0; //xib中第几个Cell
    switch (indexPath.section) {
//        case 0:
//            identifier = @"PersonalInfoTableViewCellFirst";
//            index = 0;
//            break;
//        case 1:
//            identifier = @"PersonalInfoTableViewCellSecond";
//            index = 1;
//            break;
        case 0:
            identifier = @"PersonalInfoTableViewCellThird";
            index = 2;
            break;
        case 1:
            identifier = @"PersonalInfoTableViewCellFourth";
            index = 3;
        default:
            break;
    }
    PersonalInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PersonalInfoTableViewCell" owner:self options:nil] objectAtIndex:index];
    }
    if (indexPath.section == 1) {
        SignPeople * ss = ary[(int)indexPath.row];//[[SignPeople alloc] init];
//        [ss setInfoWithDict:ary[(int)indexPath.row]];
        
        cell.personalNameLabel.text = [NSString stringWithFormat:@"姓名 :%@",ss.name];
        cell.workNo.text = [NSString stringWithFormat:@"学号 :%@",ss.workNo];
        if ([UIUtils isBlankString:[NSString stringWithFormat:@"%@",ss.pictureId]]) {
            UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
            
            NSString * baseURL = user.host;
            [cell.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?resourceId=%@",baseURL,FileDownload,ss.pictureId]] placeholderImage:[UIImage imageNamed:@"signa.png"]];
        }
    }
    return cell;
    
}
-(void)setSignNumebr:(NSString *)str{
    _signNumber.text = [NSString stringWithFormat:@"%@人",str];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)signBtnPressed:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(signBtnPressedPInfoDelegate)]) {
        [self.delegate signBtnPressedPInfoDelegate];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
