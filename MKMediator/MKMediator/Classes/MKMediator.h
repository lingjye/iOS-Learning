//
//  MKMediator.h
//  MKMediator
//
//  Created by txooo on 2019/6/11.
//  Copyright © 2019 txooo. All rights reserved.
//

/*
 基于 MKMediator 实现扩展
 原项目地址: https://github.com/casatwy/MKMediator
 */

#import <UIKit/UIKit.h>

@class MKMediatorAction;

extern NSString *const kMKMediatorParamsKeySwiftTargetModuleName;

@interface MKMediator : NSObject

//+ (instancetype)sharedInstance;

// 远程App调用入口
- (id)performActionWithUrl:(NSURL *)url completion:(void (^)(NSDictionary *info))completion;
// 本地组件调用入口
- (id)performTarget:(NSString *)targetName
               action:(NSString *)actionName
               params:(NSDictionary *)params
    shouldCacheTarget:(BOOL)shouldCacheTarget;
- (void)releaseCachedTargetWithTargetName:(NSString *)targetName;
// 以下方法是扩展, 及增加链式调用
- (id)performClassMethod:(NSString *)classMethod parameters:(NSDictionary *)parameters;

- (id)dispatch:(MKMediatorAction *)action;
- (id (^)(MKMediatorAction *))dispatch;

/* ------- Middleware ------- */
// Middleware 当设置的方法执行时先执行指定的方法，可用于观察某方法的执行，然后通知其它 组件 执行观察方法进行响应
- (void)middleware:(NSString *)whenClsMethod dispatch:(MKMediatorAction *)action;
- (MKMediator * (^)(NSString *))middleware;
- (MKMediator * (^)(MKMediatorAction *))middlewareAction;

/* ------- State ------- */
// 状态管理
- (NSString *)currentState;
- (void)updateCurrentState:(NSString *)state;
- (MKMediator * (^)(NSString *))updateCurrentState;

/* ------- Observer ------- */
- (void)observerWithIdentifier:(NSString *)identifier observer:(MKMediatorAction *)action;
- (void)notifyObservers:(NSString *)identifier;
- (MKMediator * (^)(NSString *))observerWithIdentifier;
- (MKMediator * (^)(MKMediatorAction *))observer;

/* ------- Factory ------- */
- (void)factoryClass:(NSString *)factoryClass factory:(NSString *)factory;
- (MKMediator * (^)(NSString *))factoryClass;
- (MKMediator * (^)(NSString *))factory;

@end

@interface MKMediatorAction : NSObject

@property (nonatomic, strong) NSString *classMethod;
@property (nonatomic, strong) NSMutableDictionary *parameters;
// state
@property (nonatomic, strong) NSString *toState;

+ (MKMediatorAction *)classMethod:(NSString *)classMethod;
+ (MKMediatorAction *)classMethod:(NSString *)classMethod parameters:(NSMutableDictionary *)parameters;
+ (MKMediatorAction *)classMethod:(NSString *)classMethod
                       parameters:(NSMutableDictionary *)parameters
                          toState:(NSString *)toState;

// 通过类名调用, 字符串方式
// s is string type
+ (MKMediatorAction * (^)(NSString *))sClsMethod;        // 类和方法
+ (MKMediatorAction * (^)(NSString *))sCls;              // 类
- (MKMediatorAction * (^)(NSString *))sMethod;           // 方法
- (MKMediatorAction * (^)(NSMutableDictionary *))params; // 可选：参数
- (MKMediatorAction * (^)(NSString *))sToState;          // 可选：更改状态

// 通过类调用
+ (MKMediatorAction * (^)(Class))cls;  // 类
- (MKMediatorAction * (^)(SEL))method; // 方法

@end

@interface MKMediatorParameters : NSObject

+ (MKMediatorParameters *)create;
- (MKMediatorParameters *(^)(NSString *))key;
- (MKMediatorParameters *(^)(id))value;
- (NSMutableDictionary *)dictionary;

@end
