//
//  MJXFollowUpPlanTableViewCell.m
//  XinSuiFang
//
//  Created by majinxing on 16/9/23.
//  Copyright © 2016年 majinxing. All rights reserved.
// 展示随访计划的cell

#import "MJXFollowUpPlanTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MJXBrowsePicturesCollectionViewCell.h"
static NSString *cellIdentifier = @"cellIdentifier";
@interface MJXFollowUpPlanTableViewCell ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UITextView *textView;
@property (nonatomic,strong)NSMutableArray *pictureArray;
@end
@implementation MJXFollowUpPlanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        _pictureArray = [NSMutableArray arrayWithCapacity:10];
    }
    return self;
}
-(void)showNameOfFollowUp:(NSString *)followUpName{
    UILabel *namel = [[UILabel alloc] initWithFrame:CGRectMake(12, 23, 300, 14)];
    namel.font = [UIFont systemFontOfSize:14];
    namel.textColor = [UIColor colorWithHexString:@"#333333"];
    namel.text = [NSString stringWithFormat:@"随访名称：%@",followUpName];
    [self.contentView addSubview:namel];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH-28-15, 14, 15, 15)];
    image.image = [UIImage imageNamed:@"tzfa"];
    [self.contentView addSubview:image];
    
    UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH-28-30, CGRectGetMaxY(image.frame)+7,50, 15)];
    t.font = [UIFont systemFontOfSize:11];
    t.textColor = [UIColor colorWithHexString:@"#666666"];
    t.text = @"调整方案";
    [self.contentView addSubview:t];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(APPLICATION_WIDTH-60, 0, 60, 60);
    [btn addTarget:self action:@selector(adjustThePlan) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
}
-(void)adjustThePlan{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(followUpPlanTableViewCelladjustThePlanPressed)]) {
        [self.delegate followUpPlanTableViewCelladjustThePlanPressed];
    }
}
-(void)showPatientName:(NSString *)name withPhoneNumber:(NSString *)number withSex:(NSString *)sex withAge:(NSString *)age withPatientHead:(NSString *)head{
    UIImageView *imageHead = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 48, 48)];
    [imageHead sd_setImageWithURL:[NSURL URLWithString:head] placeholderImage:[UIImage imageNamed:@"woman"]];
    [self.contentView addSubview:imageHead];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageHead.frame)+13, 12, 150, 14)];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    nameLabel.text = name;
    [self.contentView addSubview:nameLabel];
    //算文字长度的
    CGSize detailSize1 = [nameLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    
    UILabel *ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x+detailSize1.width+13, 12, 50, 14)];
    ageLabel.font = [UIFont systemFontOfSize:13];
    ageLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    ageLabel.text = [NSString stringWithFormat:@"%@岁",age];
    [self.contentView addSubview:ageLabel];
    
    CGSize detailSize2 = [ageLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    
    UIImageView *sexImage = [[UIImageView alloc] initWithFrame:CGRectMake(ageLabel.frame.origin.x+detailSize2.width+15, 13, 14, 14)];
    if ([sex isEqualToString:@"女"]) {
        sexImage.image = [UIImage imageNamed:@"girl"];
    }else{
        sexImage.image = [UIImage imageNamed:@"boy"];
    }
    [self.contentView addSubview:sexImage];
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(12+CGRectGetMaxY(imageHead.frame), CGRectGetMaxY(nameLabel.frame)+15, 100, 15)];
    numberLabel.font = [UIFont systemFontOfSize:13];
    numberLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    if (number.length>0) {
        numberLabel.text = number;
    }
    [self.contentView addSubview:numberLabel];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    [self.contentView addSubview:line];
}
-(void)addContenViewWithFollowUpTime:(NSString *)time withContent:(NSString *)content withRemindstate:(NSString *)state1 withButtonTag:(int)tagInt{
    UILabel *titleTime = [[UILabel alloc] initWithFrame:CGRectMake(29, 23,200, 15)];
    titleTime.font = [UIFont systemFontOfSize:15];
    titleTime.textColor = [UIColor colorWithHexString:@"#333333"];
    titleTime.text = [NSString stringWithFormat:@"随访时间：%@",time];
    [self.contentView addSubview:titleTime];
    
    UILabel *remind = [[UILabel alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH-50, 23, 50, 15)];
    remind.font = [UIFont systemFontOfSize:13];
    remind.textColor = [UIColor colorWithHexString:@"#999999"];
    if ([state1 isEqualToString:@"010"]||[state1 isEqualToString:@"001"]) {
        remind.text = @"未提醒";
    }else if([state1 isEqualToString:@"101"]){
        remind.text = @"已提醒";
    }else if([state1 isEqualToString:@"110"]){
        remind.text = @"已反馈";
    }else if ([state1 isEqualToString:@"111"]){
        remind.text = @"已完成";
    }
    [self.contentView addSubview:remind];
    
    CGFloat titleHeight = [self getTextViewHeight:content font:[UIFont systemFontOfSize:13] width:APPLICATION_WIDTH-22-10-13-13];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    [self.contentView addSubview:view];
    
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(22+13, CGRectGetMaxY(titleTime.frame)+10+13, APPLICATION_WIDTH-22-10-13-13, titleHeight+20)];
    view.frame = CGRectMake(22, CGRectGetMaxY(titleTime.frame)+10, APPLICATION_WIDTH-22-10, _textView.frame.size.height+50+15);
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:13];
    _textView.textColor = [UIColor colorWithHexString:@"#333333"];
    _textView.text = content;
    _textView.userInteractionEnabled = NO;
    [self.contentView addSubview:_textView];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(22, CGRectGetMaxY(_textView.frame), APPLICATION_WIDTH-22-10, 1)];
    line1.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    [self.contentView addSubview:line1];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = tagInt;
    btn.frame = CGRectMake(22, CGRectGetMaxY(_textView.frame)+1, APPLICATION_WIDTH-22-10, 50);
    
    [btn addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor clearColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:btn];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];//取消发送按钮
    cancel.frame = CGRectMake(0,0,0,0);
    cancel.titleLabel.font = [UIFont systemFontOfSize:13];
    [cancel setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [cancel setTitle:@"取消发送" forState:UIControlStateNormal];
    cancel.tag = tagInt+1000;
    cancel.backgroundColor = [UIColor clearColor];
    [cancel addTarget:self action:@selector(cancelSend:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:cancel];
    
    UIButton *immediatelySend = [UIButton buttonWithType:UIButtonTypeCustom];//立即发送按钮
    immediatelySend.tag = tagInt+2000;
    immediatelySend.frame = CGRectMake(0,0, 0,0);
    immediatelySend.titleLabel.font = [UIFont systemFontOfSize:13];
    [immediatelySend setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [immediatelySend setTitle:@"立即发送发送" forState:UIControlStateNormal];
    [immediatelySend addTarget:self action:@selector(immediatelySend:) forControlEvents:UIControlEventTouchUpInside];
    immediatelySend.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:immediatelySend];
    UIView *btnLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    btnLine.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    [self.contentView addSubview:btnLine];
    
    if ([state1 isEqualToString:@"001"]) {
        [btn setTitle:@"恢复发送" forState:UIControlStateNormal];
    }else if ([state1 isEqualToString:@"010"]){
        btn.frame = CGRectMake(0, 0, 0,0);
        cancel.frame = CGRectMake(22,CGRectGetMaxY(_textView.frame)+1, APPLICATION_WIDTH/2-11-5, 50);
        btnLine.frame = CGRectMake(CGRectGetMaxX(cancel.frame), CGRectGetMaxY(_textView.frame)+1, 1, 50);
        immediatelySend.frame = CGRectMake(CGRectGetMaxX(cancel.frame),CGRectGetMaxY(_textView.frame)+1, APPLICATION_WIDTH/2-11-5, 50);
        
    }else if ([state1 isEqualToString:@"101"]){
        [btn setTitle:@"重新发送" forState:UIControlStateNormal];
    }else if ([state1 isEqualToString:@"110"]||[state1 isEqualToString:@"111"]){
        [btn setTitle:@"查看复查结果" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#01aeff"] forState:UIControlStateNormal];
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(14, 0, 1, 23+15+10+view.frame.size.height+15)];
    line.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    [self.contentView addSubview:line];
    
    self.height = 23+15+10+view.frame.size.height+15;
    
    UIView *round = [[UIView alloc] initWithFrame:CGRectMake(7, 23,16,16)];
    round.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    round.layer.cornerRadius = 8;
    round.layer.masksToBounds = YES;
    [self.contentView addSubview:round];


}
//立即发送
-(void)immediatelySend:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(immediatelySendPressed:)]) {
        [self.delegate immediatelySendPressed:btn];
    }
}
//取消发送
-(void)cancelSend:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(cancelSendPressed:)]) {
        [self.delegate cancelSendPressed:btn];
    }
}
//恢复发送 重新发送 查看复查结果
-(void)sendMessage:(UIButton *)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(sendMessagePressed:)]) {
        [self.delegate sendMessagePressed:btn];
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(CGFloat)getTextViewHeight:(NSString *)text font:(UIFont*)font width:(CGFloat)width;
{
    UITextView *textView = [[UITextView alloc] init];
    [textView setText:text];
    [textView setFont:font];
    
    CGSize size = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return size.height;
}
#pragma mark ReviewTheResultsVCCell
-(void)addImageArray:(NSArray *)ary withPlan:(NSString *)plan withTitleTime:(NSString *)timeStr  withDescribe:(NSString *)describe{
    _pictureArray = [[NSMutableArray alloc] initWithArray:ary];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, 100, 15)];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor colorWithHexString:@"#333333"];
    label.text = [NSString stringWithFormat:@"方案名称：%@",plan];
    [self.contentView addSubview:label];
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(APPLICATION_WIDTH-10-100, 15, 100, 12)];
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    timeLabel.text = timeStr;
    [self.contentView addSubview:timeLabel];
    UIView *lineW = [[UIView alloc] initWithFrame:CGRectMake(0, 40, APPLICATION_WIDTH, 1)];
    lineW.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    [self.contentView addSubview:lineW];
    UICollectionView *collect = [[UICollectionView alloc] initWithFrame:CGRectMake(23, 10, APPLICATION_WIDTH-26, 73)];
    collect.delegate = self;
    collect.dataSource = self;
    [self.contentView addSubview:collect];
    CGSize detailSize2 = [describe sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(200, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(collect.frame)+12, APPLICATION_WIDTH-20,detailSize2.height+30+30)];
    text.backgroundColor = [UIColor whiteColor];
    text.font = [UIFont systemFontOfSize:13];
    text.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.contentView addSubview:text];
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_pictureArray.count>0) {
        return _pictureArray.count;
    }else
        return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MJXBrowsePicturesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
   // [cell addImageView:_pictureArray[indexPath.row]];
    if ([[_pictureArray objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]) {
        [cell addImageViewWithString:_pictureArray[indexPath.row] withD:NO withTag:(int)indexPath.row+1];
    }else if ([[_pictureArray objectAtIndex:indexPath.row] isKindOfClass:[UIImage class]]){
        [cell addImageViewWithImage:_pictureArray[indexPath.row] withD:NO withTag:(int)indexPath.row+1];
    }
    return cell;
}
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(73,73);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 13;
}
@end
