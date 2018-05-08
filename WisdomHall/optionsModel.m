//
//  optionsModel.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/5/2.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "optionsModel.h"

#import "DYHeader.h"

@implementation optionsModel
-(instancetype)init{
    self = [super init];
    if (self) {
        _optionsImageAry = [NSMutableArray arrayWithCapacity:1];
        _optionsImageIdAry = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}
-(void)setContentWithDict:(NSDictionary *)dict{
    _questionId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"questionId"]];
    _optionId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
    _optionsTitle = [dict objectForKey:@"content"];
    _index = [dict objectForKey:@"index"];
    _optionsImageIdAry = [dict objectForKey:@"resourceList"];
}
-(float)returnOptionHeight{
    if (_edit) {
        return 200;
    }else{
        if (_optionsImageAry.count>0||_optionsImageIdAry.count>0) {
            return [self returnTextHeight]+APPLICATION_WIDTH/3;
        }else{
            return [self returnTextHeight];
        }
    }
    return 0;
}
-(float)returnTextHeight{
    UITextView * textView1 = [[UITextView alloc] init];
    textView1.text = self.optionsTitle;
    
    CGSize size = CGSizeMake( APPLICATION_WIDTH-65, CGFLOAT_MAX);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil];
    
    CGFloat curheight = [textView1.text boundingRectWithSize:size
                                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                 attributes:dic
                                                    context:nil].size.height;
    
    if (curheight<50) {
        return 50;
    }
    return curheight+20;
}
@end
