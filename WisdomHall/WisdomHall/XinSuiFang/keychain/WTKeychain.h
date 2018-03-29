//
//  WTKeychain.h
//  weiting
//
//  Created by Yuan Li on 7/24/14.
//
//

#import <Foundation/Foundation.h>

@interface WTKeychain : NSObject

//KeyChain
+ (void)keyChainSave:(NSString *)service data:(id)data;
+ (id)keyChainload:(NSString *)service;
+ (void)keyChainDelete:(NSString *)service;

@end
