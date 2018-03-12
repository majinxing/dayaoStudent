//
//  VoteModel.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/5.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "VoteModel.h"
#import "DYHeader.h"

@implementation VoteModel
-(instancetype)init{
    self = [super init];
    if (self) {
        _selectAry = [NSMutableArray arrayWithCapacity:4];
    }
    return self;
}
-(void)changeText:(UITextView *)textView{
    if (textView.tag == 0) {
        self.title = textView.text;
    }else if (textView.tag == 1){
        self.largestNumbe = textView.text;
    }else if (textView.tag>1){
        if (textView.tag-2<self.selectAry.count) {
            [self.selectAry setObject:textView.text atIndexedSubscript:textView.tag-2];
        }
    }

}
-(void)setInfo:(NSDictionary *)dict{
    _voteState = [dict objectForKey:@"statusName"];
    _title = [dict objectForKey:@"title"];
    _largestNumbe = [dict objectForKey:@"type"];
    _voteId = [dict objectForKey:@"id"];
    _time = [UIUtils timeWithTimeIntervalString:[dict objectForKey:@"createTimeStr"]];
    _selfVoteStatus = [dict objectForKey:@"votedName"];
}

@end
