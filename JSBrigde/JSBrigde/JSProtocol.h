//
//  JSProtocol.h
//  JSBrigde
//
//  Created by txooo on 2019/4/4.
//  Copyright © 2019 txooo. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JSProtocol <JSExport>

- (NSString *)fullName; //fullName用来拼接firstName和lastName，并返回全名

@end

NS_ASSUME_NONNULL_END
