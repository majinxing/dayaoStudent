////
////  MJXChatCellTableViewCell.m
////  WisdomHall
////
////  Created by XTU-TI on 2017/6/26.
////  Copyright © 2017年 majinxing. All rights reserved.
////
//
//#import "MJXChatCellTableViewCell.h"
////#import <Hyphenate/Hyphenate.h>
//#import "DYHeader.h"
//#import "UIImageView+WebCache.h"
//
//#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]
//
//@interface MJXChatCellTableViewCell()
//@property (weak, nonatomic) IBOutlet UITextView *firstTextView;
//@property (strong, nonatomic) IBOutlet UIButton *firstHeadBtn;
//@property (weak, nonatomic) IBOutlet UITextView *fifthTextView;
//@property (weak, nonatomic) IBOutlet UIButton *fifthHeadBtn;
//@property (weak, nonatomic) IBOutlet UIImageView *secondImageVIew;
//@property (strong, nonatomic) IBOutlet UIButton *secondHeadBtn;
//@property (weak, nonatomic) IBOutlet UIImageView *sixthImageView;
//@property (strong, nonatomic) IBOutlet UIButton *sixthHeadBtn;
//@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;
//@property (strong, nonatomic) IBOutlet UIButton *thirdHeadBtn;
//
//@property (strong, nonatomic) IBOutlet UIButton *seventhHeadBtn;
//
//@property (weak, nonatomic) IBOutlet UIButton *seventhBtn;
//@property (weak, nonatomic) IBOutlet UILabel *fourthLabel;
//@property (strong, nonatomic) IBOutlet UIButton *fourthHeadBtn;
//@property (weak, nonatomic) IBOutlet UILabel *eigthLabel;
//@property (weak, nonatomic) IBOutlet UIButton *fourthBtn;
//@property (weak, nonatomic) IBOutlet UIButton *eigthBtn;
//@property (strong, nonatomic) IBOutlet UIButton *eigthHeadBtn;
//@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *secondNameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *thirdNameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *fourthNameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *fifthNameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *sixthNameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *seventhNameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *eigthNameLabel;
//@property (strong, nonatomic) IBOutlet UIImageView *firstHeadImage;
//@property (weak, nonatomic) IBOutlet UIImageView *secondHeadImage;
//@property (strong, nonatomic) IBOutlet UIImageView *thirdHeadImage;
//@property (strong, nonatomic) IBOutlet UIImageView *fourthHeadImage;
//
//@property (weak, nonatomic) IBOutlet UIImageView *fifthHeadImage;
//@property (strong, nonatomic) IBOutlet UIImageView *sixthHeadImage;
//@property (weak, nonatomic) IBOutlet UIImageView *seventhHHeadImage;
//@property (strong, nonatomic) IBOutlet UIImageView *eigthHeadImage;
//
//
//@property (strong, nonatomic) UIView * bView;
//
//@end
//
//@implementation MJXChatCellTableViewCell
//
//- (void)awakeFromNib {
//    [super awakeFromNib];
//    self.backgroundColor =  RGBA_COLOR(241, 241, 241, 1);
//    
//    _bView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
//    _bView.backgroundColor = RGBA_COLOR(241, 241, 241, 1);
//    [self.contentView addSubview:_bView];
//    // Initialization code
//}
//+ (instancetype)tempTableViewCellWith:(UITableView *)tableView EMMessage:(EMMessage *)message {
//    NSString * identifier;
//    NSInteger index = 0;
//    if (message.direction == EMMessageDirectionReceive) {
//        switch (message.body.type) {
//            case EMMessageBodyTypeText: //文字
//                identifier = @"MJXChatCellTableViewCellFirst";
//                index = 0;
//                break;
//            case EMMessageBodyTypeImage://图片
//                identifier = @"MJXChatCellTableViewCellSecond";
//                index = 1;
//                break;
//            case EMMessageBodyTypeVideo://视频
//                identifier = @"MJXChatCellTableViewCellThird";
//                index = 2;
//                break;
//            case EMMessageBodyTypeVoice://语音
//                identifier = @"MJXChatCellTableViewCellForth";
//                index = 3;
//                break;
//                
//            default:
//                break;
//        }
//    }else{
//        switch (message.body.type) {
//            case EMMessageBodyTypeText://文字
//                identifier = @"MJXChatCellTableViewCellFifth";
//                index = 4;
//                break;
//            case EMMessageBodyTypeImage://图片
//                identifier = @"MJXChatCellTableViewCellSixth";
//                index = 5;
//                break;
//            case EMMessageBodyTypeVideo://视频
//                identifier = @"MJXChatCellTableViewCellSeventh";
//                index = 6;
//                break;
//            case EMMessageBodyTypeVoice://语音
//                identifier = @"MJXChatCellTableViewCellEighth";
//                index = 7;
//                break;
//                
//            default:
//                break;
//        }
//        
//    }
//
//    MJXChatCellTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (!cell) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"MJXChatCellTableViewCell" owner:self options:nil] objectAtIndex:index];
//    }
//    [cell setInfoWithNumber:index withMessage:message];
//    return cell;
//}
///**
// *  n判断数据类型
// **/
//-(void)setInfoWithNumber:(NSInteger) n withMessage:(EMMessage *)message{
//    if (n==0) {
//        // 收到的文字消息
//        EMTextMessageBody *textBody = (EMTextMessageBody *)message.body;
//        
//        _firstTextView.text = textBody.text;
//        
//        NSDictionary *dict = message.ext;
//        
//        NSString * name = [dict objectForKey:@"name"];
//        
//        NSString * headimage = [dict objectForKey:@"headImage"];
//        
//        _firstNameLabel.text = [NSString stringWithFormat:@"%@",name];
//        
//        if (![UIUtils isBlankString:headimage]) {
//            
//            UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
//            
//            NSString * baseURL = user.host;
//            [_firstHeadImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?resourceId=%@",baseURL,FileDownload,headimage]] placeholderImage:[UIImage imageNamed:@"h"]];
//            
//        }
//        
//        CGSize size = CGSizeMake(APPLICATION_WIDTH, CGFLOAT_MAX);
//        
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName, nil];
//        
//        CGFloat f = [textBody.text boundingRectWithSize:size
//                                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
//                                                     attributes:dic
//                                                        context:nil].size.width;
//        
//
//        if (f<30) {
//            _bView.frame = CGRectMake(61+35,CGRectGetMaxY(_firstNameLabel.frame), 200, 35.5);
//        }else if(f>=35&&f<200){
//            _bView.frame = CGRectMake(61+f+15, CGRectGetMaxY(_firstNameLabel.frame), 200, 35.5);
//        }else{
//            _bView.frame = CGRectMake(0, 0, 0, 0);
//        }
//        
//    }else if (n==1){
//        
//    }else if (n==2){
//        
//    }else if (n==3){
//        
//    }else if (n==4){
//        EMTextMessageBody *textBody = (EMTextMessageBody *)message.body;
//        _fifthTextView.text = textBody.text;
//        NSDictionary *dict = message.ext;
//        NSString * name = [dict objectForKey:@"name"];
//        NSString * headimage = [dict objectForKey:@"headImage"];
//        _fifthNameLabel.text = [NSString stringWithFormat:@"%@",name];
//        if (![UIUtils isBlankString:headimage]) {
//            UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
//            
//            NSString * baseURL = user.host;
//            [_fifthHeadImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?resourceId=%@",baseURL,FileDownload,headimage]] placeholderImage:[UIImage imageNamed:@"h"]];
//        }
//
//        float f = [self measureSinglelineStringWidth:textBody.text andFont:[UIFont systemFontOfSize:13]];
//        if (f<30) {
//            _bView.frame = CGRectMake(0,CGRectGetMaxY(_fifthNameLabel.frame), APPLICATION_WIDTH-35-45-16, 43);
//        }else if(f>=30&&f<200){
//            _bView.frame = CGRectMake(0, CGRectGetMaxY(_fifthNameLabel.frame),APPLICATION_WIDTH-f-10-45-16, 43);
//        }else{
//            _bView.frame = CGRectMake(0, 0, 0, 0);
//        }
//        
//    }else if (n==5){
//        
//    }else if (n==6){
//        
//    }else if (n==7){
//        
//    }else if (n==8){
//        
//    }
//}
//// 传一个字符串和字体大小来返回一个字符串所占的宽度
//
//-(float)measureSinglelineStringWidth:(NSString*)str andFont:(UIFont*)wordFont{
//    
//    if (str == nil) return 0;
//    
//    CGSize measureSize;
//    
//    if([[UIDevice currentDevice].systemVersion floatValue] < 7.0){
//        
//        measureSize = [str sizeWithFont:wordFont constrainedToSize:CGSizeMake(MAXFLOAT, 200) lineBreakMode:NSLineBreakByWordWrapping];
//        
//        
//    }else{
//        
//        measureSize = [str boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:wordFont, NSFontAttributeName, nil] context:nil].size;
//        
//    }
//    
//    return ceil(measureSize.width);
//    
//}
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    
//    // Configure the view for the selected state
//}
//
//@end

