//
//  peopleListView.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/6.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "peopleListView.h"
#import "DYHeader.h"
#import "SignPeople.h"
#import "UIImageView+WebCache.h"

#define imageWH 35
#define groupImageWH 50

@interface peopleListView ()
@property (nonatomic,strong)UserModel * user;

@end
@implementation peopleListView


-(instancetype)init{
    self = [super init];
    if (self) {
        _peopleAry = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}
-(void)addContentView:(NSArray *)peopleListAry{
    
    _user = [[Appsetting sharedInstance] getUsetInfo];

    for (int i = 0; i<peopleListAry.count; i++) {
        SignPeople * s = peopleListAry[i];
        
        NSString * baseURL = _user.host;
        
        if ([UIUtils isBlankString:s.pictureId]) {
            s.pictureId = _user.userHeadImageId;
        }
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageWH*i, 10, imageWH-10, imageWH-10)];
        
        if ((imageWH*(i+1))>APPLICATION_WIDTH-40) {
            break;
        }
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = (imageWH-10)/2;
        if ([UIUtils isBlankString:[NSString stringWithFormat:@"%@",s.pictureId]]) {
            s.pictureId = @"0";
        }
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?resourceId=%@",baseURL,FileDownload,s.pictureId]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
        [self addSubview:imageView];
    }
    
}
-(void)addGroupContentView:(NSArray *)peopleListAry{
    
    _user = [[Appsetting sharedInstance] getUsetInfo];
    
    _peopleAry = [NSMutableArray arrayWithArray:peopleListAry];
    
    for (int i = 0; i<peopleListAry.count; i++) {
        SignPeople * s = peopleListAry[i];
        
        NSString * baseURL = _user.host;
        
        if ([UIUtils isBlankString:s.pictureId]) {
            s.pictureId = _user.userHeadImageId;
        }
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(groupImageWH*i, 0, groupImageWH-10, groupImageWH-10)];
        
        if ((groupImageWH*(i+1))>APPLICATION_WIDTH-85) {
            break;
        }
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = (groupImageWH-10)/2;
        if ([UIUtils isBlankString:[NSString stringWithFormat:@"%@",s.pictureId]]) {
            s.pictureId = @"0";
        }
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?resourceId=%@",baseURL,FileDownload,s.pictureId]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
        [self addSubview:imageView];
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
