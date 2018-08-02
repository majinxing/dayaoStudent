//
//  MessageConversationCell.m
//  Message
//
//  Created by daozhu on 14-7-6.
//  Copyright (c) 2014年 daozhu. All rights reserved.
//

#import "MessageConversationCell.h"
#import "IMessage.h"
//#import <gobelieve/IMessage.h>z
#import "Conversation.h"

#define kCatchWidth 74.0f


@interface MessageConversationCell () 
@property (nonatomic,strong)NSMutableArray * nameAry;
@property (nonatomic,strong)UserModel * user;
@end


@implementation MessageConversationCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    CALayer *imageLayer = [self.headView layer];   //获取ImageView的层
    [imageLayer setMasksToBounds:YES];
    [imageLayer setCornerRadius:self.headView.frame.size.width/2];
    
    _nameAry = [NSMutableArray arrayWithArray:[[Appsetting sharedInstance] getGroupId_Name]];
    
    _user = [[Appsetting sharedInstance] getUsetInfo];
    
    
}

#pragma mark - Private Methods

#pragma mark - Overridden Methods

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void) showNewMessage:(int)count{
    //    JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:self.messageContent alignment:JSBadgeViewAlignmentCenterRight];
    //    [badgeView setBadgeTextFont:[UIFont systemFontOfSize:14.0f]];
    //    [self.messageContent bringSubviewToFront:badgeView];
    //    if (count > 99) {
    //       badgeView.badgeText = @"99+";
    //    }else{
    //        badgeView.badgeText = [NSString stringWithFormat:@"%d",count];
    //    }
}

-(void) clearNewMessage{
    //    for (UIView *vi in [self.messageContent subviews]) {
    //        if ([vi isKindOfClass:[JSBadgeView class]]) {
    //            [vi removeFromSuperview];
    //        }
    //    }
}

- (void)dealloc {
    [self.conversation removeObserver:self forKeyPath:@"name"];
    [self.conversation removeObserver:self forKeyPath:@"detail"];
    [self.conversation removeObserver:self forKeyPath:@"newMsgCount"];
    [self.conversation removeObserver:self forKeyPath:@"timestamp"];
    [self.conversation removeObserver:self forKeyPath:@"avatarURL"];
}


+ (NSString *)getConversationTimeString:(NSDate *)date{
    NSMutableString *outStr;
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSUIntegerMax fromDate:date];
    NSDateComponents *todayComponents = [gregorian components:NSIntegerMax fromDate:[NSDate date]];
    
    if (components.year == todayComponents.year &&
        components.day == todayComponents.day &&
        components.month == todayComponents.month) {
        NSString *format = @"HH:mm";
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:format];
        [formatter setTimeZone:[NSTimeZone systemTimeZone]];
        
        NSString *timeStr = [formatter stringFromDate:date];
        
        if (components.hour > 11) {
            outStr = [NSMutableString stringWithFormat:@"%@ %@",@"下午",timeStr];
        } else {
            outStr = [NSMutableString stringWithFormat:@"%@ %@",@"上午",timeStr];
        }
        return outStr;
    } else {
        NSString *format = @"MM-dd HH:mm";
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:format];
        [formatter setTimeZone:[NSTimeZone systemTimeZone]];
        
        return [formatter stringFromDate:date];
    }
}


- (void)setConversation:(Conversation *)conversation {
    
    [self.conversation removeObserver:self forKeyPath:@"name"];
    [self.conversation removeObserver:self forKeyPath:@"detail"];
    [self.conversation removeObserver:self forKeyPath:@"newMsgCount"];
    [self.conversation removeObserver:self forKeyPath:@"timestamp"];
    [self.conversation removeObserver:self forKeyPath:@"avatarURL"];
    
    _conversation = conversation;
    
    
    Conversation *conv = self.conversation;
    if(conv.type == CONVERSATION_PEER){
//        [self.headView sd_setImageWithURL: [NSURL URLWithString:conv.avatarURL] placeholderImage:[UIImage imageNamed:@"PersonalChat"]];
    } else if (conv.type == CONVERSATION_GROUP){
        
        [self.headView sd_setImageWithURL:[NSURL URLWithString:conv.avatarURL] placeholderImage:[UIImage imageNamed:@"GroupChat"]];
        
    } else if (self.conversation.type == CONVERSATION_SYSTEM) {
        //todo
    } else if (self.conversation.type == CONVERSATION_CUSTOMER_SERVICE) {
        [self.headView sd_setImageWithURL: [NSURL URLWithString:conv.avatarURL] placeholderImage:[UIImage imageNamed:@"PersonalChat"]];
    }
    
    self.messageContent.text = self.conversation.detail;
    
    if (conv.timestamp>0) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970: conv.timestamp];
        
        NSString *str = [[self class] getConversationTimeString:date ];//
        
        self.timelabel.text = str;
    }
    
    
    NSMutableString * str1 = [NSMutableString stringWithFormat:@"%@",conv.name];

    if ([str1 rangeOfString:@"gname:"].location != NSNotFound) {
        [str1 deleteCharactersInRange:NSMakeRange(0, 6)];
        self.namelabel.text = [UIUtils getGroupName:str1];
        if ([UIUtils isBlankString:self.namelabel.text]) {
            NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:str1,@"id", nil];
            
            [[NetworkRequest sharedInstance] GET:SelectGroupById dict:dict succeed:^(id data) {
                NSString * str = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"message"]];
                if ([str isEqualToString:@"成功"]) {
                    self.namelabel.text = [[data objectForKey:@"body"] objectForKey:@"name"];
                }
            } failure:^(NSError *error) {
                
            }];
        }
        
    }else{
        if (str1.length>6) {
            [str1 deleteCharactersInRange:NSMakeRange(0, 5)];
            self.namelabel.text = [UIUtils getGPeopleName:str1];
            NSString * strId = [UIUtils getGPeoplePictureId:str1];
            
            if ([UIUtils isBlankString:self.namelabel.text]) {
                NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:str1,@"id", nil];
                [[NetworkRequest sharedInstance] GET:QuerySelfInfo dict:dict succeed:^(id data) {
                    NSString * str = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"message"]];
                    if ([str isEqualToString:@"成功"]) {
                        self.namelabel.text = [NSString stringWithFormat:@"%@",[[data objectForKey:@"body"] objectForKey:@"name"]];//self.conversation.name;
            
                        NSString * picId = [[data objectForKey:@"body"] objectForKey:@"pictureId"];
                        if(![UIUtils isBlankString:[NSString stringWithFormat:@"%@",picId]]){
                            [self.headView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?resourceId=%@",_user.host,FileDownload,picId]] placeholderImage:[UIImage imageNamed:@"PersonalChat"]];
                        }
                        
                    }
                } failure:^(NSError *error) {
                    
                }];
            }else{
                [self.headView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?resourceId=%@",_user.host,FileDownload,strId]] placeholderImage:[UIImage imageNamed:@"PersonalChat"]];
            }
            
        }
    }

    if ([[NSString stringWithFormat:@"%@",conv.name] isEqualToString:@"通知"]) {
        self.namelabel.text = conv.name;

        self.timelabel.text = @"";
        
        self.messageContent.text = @"";
        self.namelabel.frame = CGRectMake(self.namelabel.frame.origin.x, self.frame.size.height/2-self.namelabel.frame.size.height/2, self.namelabel.frame.size.width, self.namelabel.frame.size.height);
        self.headView.image = [UIImage imageNamed:@"通知"];
    }else if ([[NSString stringWithFormat:@"%@",conv.name] isEqualToString:@"群组"]){
        self.namelabel.text = conv.name;

        self.timelabel.text = @"";
        
        self.messageContent.text = @"";
        
        self.namelabel.frame = CGRectMake(self.namelabel.frame.origin.x, self.frame.size.height/2-self.namelabel.frame.size.height/2, self.namelabel.frame.size.width, self.namelabel.frame.size.height);
        self.headView.image = [UIImage imageNamed:@"群组"];
    }
    
    if (conv.newMsgCount > 0) {
        [self showNewMessage:conv.newMsgCount];
    } else {
        [self clearNewMessage];
    }
    
    
    [self.conversation addObserver:self
                        forKeyPath:@"name"
                           options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                           context:NULL];
    
    [self.conversation addObserver:self
                        forKeyPath:@"detail"
                           options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                           context:NULL];
    [self.conversation addObserver:self
                        forKeyPath:@"newMsgCount"
                           options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                           context:NULL];
    [self.conversation addObserver:self
                        forKeyPath:@"timestamp"
                           options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                           context:NULL];
    [self.conversation addObserver:self
                        forKeyPath:@"avatarURL"
                           options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                           context:NULL];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"name"]) {
        NSMutableString * str1 = [NSMutableString stringWithFormat:@"%@",self.conversation.name];
        if (str1.length>6) {
            if ([str1 rangeOfString:@"gname:"].location == NSNotFound) {
                [str1 deleteCharactersInRange:NSMakeRange(0, 5)];
                
                self.namelabel.text = [UIUtils getGPeopleName:str1];
                if ([UIUtils isBlankString:self.namelabel.text]) {
                    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:str1,@"id", nil];
                    [[NetworkRequest sharedInstance] GET:QuerySelfInfo dict:dict succeed:^(id data) {
                        NSString * str = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"message"]];
                        if ([str isEqualToString:@"成功"]) {
                            
                            self.namelabel.text = [NSString stringWithFormat:@"%@",[[data objectForKey:@"body"] objectForKey:@"name"]];//self.conversation.name;
                            NSString * pId = [NSString stringWithFormat:@"%@",[[data objectForKey:@"body"] objectForKey:@"pictureId"]];
                            [[Appsetting sharedInstance] sevePeopleId:str1 withPeopleName:self.namelabel.text withPeoplePictureId:pId];
                        }
                    } failure:^(NSError *error) {
                        
                    }];
                }
            }else{
                [str1 deleteCharactersInRange:NSMakeRange(0, 6)];
                self.namelabel.text = [UIUtils getGroupName:str1];
                
                if ([UIUtils isBlankString:self.namelabel.text]) {
                    
                    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:str1,@"id", nil];
                    
                    [[NetworkRequest sharedInstance] GET:SelectGroupById dict:dict succeed:^(id data) {
                        NSString * str = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"message"]];
                        if ([str isEqualToString:@"成功"]) {
                            self.namelabel.text = [[data objectForKey:@"body"] objectForKey:@"name"];
                            [[Appsetting sharedInstance] saveGroupId:str1 withGroupName:self.namelabel.text];
                        }
                    } failure:^(NSError *error) {
                        
                    }];
                }
                
            }
        }
        
        
    } else if ([keyPath isEqualToString:@"detail"]) {
        self.messageContent.text = self.conversation.detail;
    } else if ([keyPath isEqualToString:@"newMsgCount"]) {
        if (self.conversation.newMsgCount > 0) {
            [self showNewMessage:self.conversation.newMsgCount];
        } else {
            [self clearNewMessage];
        }
    } else if ([keyPath isEqualToString:@"timestamp"]) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970: self.conversation.timestamp];
        NSString *str = [[self class] getConversationTimeString:date ];
        self.timelabel.text = str;
    } else if ([keyPath isEqualToString:@"avatarURL"]) {
        if(self.conversation.type == CONVERSATION_PEER){
            
            NSMutableString * str1 = [NSMutableString stringWithFormat:@"%@",self.conversation.name];
            if (str1.length>6) {
                [str1 deleteCharactersInRange:NSMakeRange(0, 5)];
                
                NSString * picId = [UIUtils getGPeoplePictureId:str1];
                if (![UIUtils isBlankString:picId]) {
                    [self.headView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?resourceId=%@",_user.host,FileDownload,picId]] placeholderImage:[UIImage imageNamed:@"PersonalChat"]];
                }
                
            }
            
            
//            [self.headView sd_setImageWithURL: [NSURL URLWithString:self.conversation.avatarURL]
//                             placeholderImage:[UIImage imageNamed:@"PersonalChat"]];
        } else if (self.conversation.type == CONVERSATION_GROUP){
            [self.headView sd_setImageWithURL:[NSURL URLWithString:self.conversation.avatarURL]
                             placeholderImage:[UIImage imageNamed:@"GroupChat"]];
        } else if (self.conversation.type == CONVERSATION_SYSTEM) {
            //todo
        }
        
    }
}

@end
