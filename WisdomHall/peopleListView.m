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
@interface peopleListView ()
@property (nonatomic,strong)UserModel * user;
@end
@implementation peopleListView


-(instancetype)init{
    self = [super init];
    if (self) {
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
