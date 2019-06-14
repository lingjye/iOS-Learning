//
//  MKMediator.m
//  MKMediator
//
//  Created by txooo on 2019/6/11.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "MKMediator.h"
#import <objc/runtime.h>

NSString *const kMKMediatorParamsKeySwiftTargetModuleName = @"kMKMediatorParamsKeySwiftTargetModuleName";

@interface MKMediator ()

@property (nonatomic, strong) NSMutableDictionary *cachedTarget;

// State
@property (nonatomic, copy) NSString *p_currentState;

// Middleware
@property (nonatomic, strong) NSMutableDictionary *middlewares; // 中间件
@property (nonatomic, strong) NSString *chainMiddlewareKey;

// Observer
@property (nonatomic, strong) NSMutableDictionary *observersIdentifier;  // 存储 identifier 观察者
@property (nonatomic, strong) NSString *chainIdentifier;

// Factory
@property (nonatomic, strong) NSMutableDictionary *factories;
@property (nonatomic, strong) NSString *chainFactoryClass;

@end

@implementation MKMediator

#pragma mark - public methods
//+ (instancetype)sharedInstance {
//    static MKMediator *mediator;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        mediator = [[MKMediator alloc] init];
//    });
//    return mediator;
//}

- (void)middleware:(NSString *)whenClsMethod dispatch:(MKMediatorAction *)action {
    if (whenClsMethod.length < 1 || !action) {
        return;
    }
    NSMutableArray *middlewares = [self.middlewares objectForKey:whenClsMethod];
    if (!middlewares) {
        middlewares = [NSMutableArray new];
    }
    [middlewares addObject:action];
    self.middlewares[whenClsMethod] = middlewares;
}

- (MKMediator *(^)(NSString *))middleware {
    return ^MKMediator *(NSString *middleware) {
        if (middleware.length) {
            self.chainMiddlewareKey = middleware;
        }
        return self;
    };
}

- (MKMediator *(^)(MKMediatorAction *))middlewareAction {
    return ^MKMediator *(MKMediatorAction *action) {
        if (!action) {
            return self;
        }
        NSMutableArray *middlewares = [self.middlewares objectForKey:self.chainMiddlewareKey];
        if (!middlewares) {
            middlewares = [NSMutableArray new];
        }
        [middlewares addObject:action];
        self.middlewares[self.chainMiddlewareKey] = middlewares;
        return self;
    };
}

- (NSString *)currentState {
    return self.p_currentState;
}

- (void)updateCurrentState:(NSString *)state {
    if (state.length) {
        self.p_currentState = state;
    }
}

- (MKMediator *(^)(NSString *))updateCurrentState {
    return ^MKMediator *(NSString *state) {
        if (state.length) {
            self.p_currentState = state;
        }
        return self;
    };
}

- (void)observerWithIdentifier:(NSString *)identifier observer:(MKMediatorAction *)action {
    if (identifier.length < 1 || !action) {
        return;
    }
    NSMutableArray *observers = [self.observersIdentifier objectForKey:identifier];
    if (!observers) {
        observers = [NSMutableArray new];
    }
    [observers addObject:action];
    self.observersIdentifier[identifier] = observers;
}

- (void)notifyObservers:(NSString *)identifier {
    NSMutableArray *observers = [self.observersIdentifier objectForKey:identifier];
    if (observers.count) {
        for (MKMediatorAction *action in observers) {
            self.dispatch(action);
        }
    }
}

- (MKMediator *(^)(NSString *))observerWithIdentifier {
    return ^MKMediator *(NSString *identifier) {
        if (identifier.length) {
            self.chainIdentifier = identifier;
        }
        return self;
    };
}

- (MKMediator *(^)(MKMediatorAction *))observer {
    return ^MKMediator *(MKMediatorAction *action) {
        NSMutableArray *observers = [self.observersIdentifier objectForKey:self.chainIdentifier];
        if (!observers) {
            observers = [NSMutableArray new];
        }
        [observers addObject:action];
        self.observersIdentifier[self.chainIdentifier] = observers;
        return self;
    };
}

- (void)factoryClass:(NSString *)factoryClass factory:(NSString *)factory {
    if (factoryClass.length < 1 || factory.length < 1) {
        return;
    }
    self.factories[factoryClass] = factory;
}

- (MKMediator *(^)(NSString *))factoryClass {
    return ^MKMediator *(NSString *factoryClass) {
        self.chainFactoryClass = factoryClass;
        return self;
    };
}

- (MKMediator *(^)(NSString *))factory {
    return ^MKMediator *(NSString *factory) {
        self.factories[self.chainFactoryClass] = factory;
        return self;
    };
}

- (id)dispatch:(MKMediatorAction *)action {
    if (action.toState.length > 0) {
        self.p_currentState = action.toState;
    }
    return [self performClassMethod:action.classMethod parameters:action.parameters];
}

- (id (^)(MKMediatorAction *))dispatch {
    return ^MKMediator *(MKMediatorAction *action) {
        return [self dispatch:action];
    };
}

- (id)performClassMethod:(NSString *)classMethod parameters:(NSDictionary *)parameters {
    // 使用空格 分割出 Class 和 method
    NSArray *classMethodArr = [classMethod componentsSeparatedByString:@" "];
    NSString *classStr = nil;
    NSString *methodStr = nil;
    if (classMethodArr.count == 2) {
        classStr = classMethodArr.firstObject;
        methodStr = classMethodArr.lastObject;
    } else {
        [self NoTargetActionResponseWithTargetString:classMethod
                                      selectorString:classMethod
                                        originParams:parameters];
        return nil;
    }
    
    // factory
    // 由于后面的执行都会用到 class 所以需要优先处理 class 的变形体
    NSString *factory = [self.factories objectForKey:classStr];
    if (factory) {
        classStr = [NSString stringWithFormat:@"%@%@_factory", classStr, factory];
        classMethod = [NSString stringWithFormat:@"%@ %@", classStr, methodStr];
    }
    
    // Middleware
    id middleware = [self.middlewares valueForKey:classMethod];
    if (middleware) {
        [self perform:middleware];
    }

    return [self performTarget:classStr action:methodStr params:parameters shouldCacheTarget:YES];
}

- (void)perform:(id)action {
    if ([action isKindOfClass:[MKMediatorAction class]]) {
        [self dispatch:action];
    } else if ([action isKindOfClass:[NSMutableArray class]]) {
        for (MKMediatorAction *act in action) {
            [self dispatch:act];
        }
    }
}

/*
 scheme://[target]/[action]?[params]

 url sample:
 aaa://targetA/actionB?id=1234
 */

- (id)performActionWithUrl:(NSURL *)url completion:(void (^)(NSDictionary *))completion {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *urlString = [url query];
    for (NSString *param in [urlString componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if ([elts count] < 2) continue;
        [params setObject:[elts lastObject] forKey:[elts firstObject]];
    }

    // 这里这么写主要是出于安全考虑，防止黑客通过远程方式调用本地模块。这里的做法足以应对绝大多数场景，如果要求更加严苛，也可以做更加复杂的安全逻辑。
    NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if ([actionName hasPrefix:@"native"]) {
        return @(NO);
    }

    // 这个demo针对URL的路由处理非常简单，就只是取对应的target名字和method名字，但这已经足以应对绝大部份需求。如果需要拓展，可以在这个方法调用之前加入完整的路由逻辑
    id result = [self performTarget:url.host action:actionName params:params shouldCacheTarget:NO];
    if (completion) {
        if (result) {
            completion(@{ @"result" : result });
        } else {
            completion(nil);
        }
    }
    return result;
}

- (id)performTarget:(NSString *)targetName
               action:(NSString *)actionName
               params:(NSDictionary *)params
    shouldCacheTarget:(BOOL)shouldCacheTarget {
    NSString *swiftModuleName = params[kMKMediatorParamsKeySwiftTargetModuleName];

    // generate target
    NSString *targetClassString = nil;
    if (swiftModuleName.length > 0) {
        targetClassString = [NSString stringWithFormat:@"%@.%@", swiftModuleName, targetName];
    } else {
        targetClassString = [NSString stringWithFormat:@"%@", targetName];
    }
    NSObject *target = self.cachedTarget[targetClassString];
    if (target == nil) {
        Class targetClass = NSClassFromString(targetClassString);
        target = [[targetClass alloc] init];
    }

    // generate action
    NSString *actionString = [NSString stringWithFormat:@"%@:", actionName];
    SEL action = NSSelectorFromString(actionString);

    if (target == nil) {
        // 这里是处理无响应请求的地方之一，这个demo做得比较简单，如果没有可以响应的target，就直接return了。实际开发过程中是可以事先给一个固定的target专门用于在这个时候顶上，然后处理这种请求的
        [self NoTargetActionResponseWithTargetString:targetClassString selectorString:actionString originParams:params];
        return nil;
    }
    
    if (![self.p_currentState isEqualToString:@"init"]) {
        SEL stateMethod = NSSelectorFromString([NSString stringWithFormat:@"%@_state_%@:", actionName, self.p_currentState]);
        if ([target respondsToSelector:stateMethod]) {
            return [self safePerformAction:stateMethod target:target params:params];
        }
    }

    if (shouldCacheTarget) {
        self.cachedTarget[targetClassString] = target;
    }

    if ([target respondsToSelector:action]) {
        return [self safePerformAction:action target:target params:params];
    } else {
        // 这里是处理无响应请求的地方，如果无响应，则尝试调用对应target的notFound方法统一处理
        SEL action = NSSelectorFromString(@"notFound:");
        if ([target respondsToSelector:action]) {
            return [self safePerformAction:action target:target params:params];
        } else {
            // 这里也是处理无响应请求的地方，在notFound都没有的时候，这个demo是直接return了。实际开发过程中，可以用前面提到的固定的target顶上的。
            [self NoTargetActionResponseWithTargetString:targetClassString
                                          selectorString:actionString
                                            originParams:params];
            [self.cachedTarget removeObjectForKey:targetClassString];
            return nil;
        }
    }
}

- (void)releaseCachedTargetWithTargetName:(NSString *)targetName {
    NSString *targetClassString = [NSString stringWithFormat:@"%@", targetName];
    [self.cachedTarget removeObjectForKey:targetClassString];
}

#pragma mark - private methods
- (void)NoTargetActionResponseWithTargetString:(NSString *)targetString
                                selectorString:(NSString *)selectorString
                                  originParams:(NSDictionary *)originParams {
    SEL action = NSSelectorFromString(@"Action_response:");
    NSObject *target = [[NSClassFromString(@"Target_NoTargetAction") alloc] init];

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"originParams"] = originParams;
    params[@"targetString"] = targetString;
    params[@"selectorString"] = selectorString;

    [self safePerformAction:action target:target params:params];
}

- (id)safePerformAction:(SEL)action target:(NSObject *)target params:(NSDictionary *)params {
    NSMethodSignature *methodSig = [target methodSignatureForSelector:action];
    if (methodSig == nil) {
        return nil;
    }
    const char *retType = [methodSig methodReturnType];

    if (strcmp(retType, @encode(void)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        return nil;
    }

    if (strcmp(retType, @encode(NSInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }

    if (strcmp(retType, @encode(BOOL)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }

    if (strcmp(retType, @encode(CGFloat)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }

    if (strcmp(retType, @encode(NSUInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
}

#pragma mark - getters and setters
- (NSMutableDictionary *)cachedTarget {
    if (_cachedTarget == nil) {
        _cachedTarget = [NSMutableDictionary new];
    }
    return _cachedTarget;
}

- (NSMutableDictionary *)middlewares {
    if (!_middlewares) {
        _middlewares = [NSMutableDictionary new];
    }
    return _middlewares;
}

- (NSString *)p_currentState {
    if (!_p_currentState) {
        _p_currentState = @"init";
    }
    return _p_currentState;
}

- (NSMutableDictionary *)observersIdentifier {
    if (!_observersIdentifier) {
        _observersIdentifier = [NSMutableDictionary new];
    }
    return _observersIdentifier;
}

- (NSString *)chainMiddlewareKey {
    if (!_chainMiddlewareKey) {
        _chainMiddlewareKey = @"empty";
    }
    return _chainMiddlewareKey;
}

- (NSString *)chainIdentifier {
    if (!_chainIdentifier) {
        _chainIdentifier = @"empty";
    }
    return _chainIdentifier;
}

- (NSMutableDictionary *)factories {
    if (!_factories) {
        _factories = [NSMutableDictionary new];
    }
    return _factories;
}

- (NSString *)chainFactoryClass {
    if (!_chainFactoryClass) {
        _chainFactoryClass = @"empty";
    }
    return _chainFactoryClass;
}

@end

@interface MKMediatorAction ()

@property (nonatomic, strong) NSString *chainCls;

@end

@implementation MKMediatorAction

+ (MKMediatorAction *)classMethod:(NSString *)classMethod {
    return [MKMediatorAction classMethod:classMethod parameters:nil toState:nil];
}

+ (MKMediatorAction *)classMethod:(NSString *)classMethod parameters:(NSMutableDictionary *)parameters {
    return [MKMediatorAction classMethod:classMethod parameters:parameters toState:nil];
}

+ (MKMediatorAction *)classMethod:(NSString *)classMethod
                       parameters:(NSMutableDictionary *)parameters
                          toState:(NSString *)toState {
    MKMediatorAction *act = [[MKMediatorAction alloc] init];
    act.classMethod = classMethod;
    act.parameters = parameters;
    act.toState = toState;
    return act;
}

// Chain Helper
+ (MKMediatorAction * (^)(NSString *))sClsMethod {
    return ^MKMediatorAction *(NSString *sClsMethod) {
        MKMediatorAction *act = [[MKMediatorAction alloc] init];
        act.classMethod = sClsMethod;
        return act;
    };
}

+ (MKMediatorAction * (^)(NSString *))sCls {
    return ^MKMediatorAction *(NSString *sCls) {
        MKMediatorAction *act = [[MKMediatorAction alloc] init];
        act.chainCls = sCls;
        return act;
    };
}

- (MKMediatorAction * (^)(NSString *))sMethod {
    return ^MKMediatorAction *(NSString *sMethod) {
        self.classMethod = [NSString stringWithFormat:@"%@ %@", self.chainCls, sMethod];
        return self;
    };
}

- (MKMediatorAction * (^)(NSMutableDictionary *))params {
    return ^MKMediatorAction *(NSMutableDictionary *params) {
        self.parameters = params;
        return self;
    };
}

- (MKMediatorAction * (^)(NSString *))sToState {
    return ^MKMediatorAction *(NSString *sToState) {
        self.toState = sToState;
        return self;
    };
}

// 能在编译期检查的方法
+ (MKMediatorAction * (^)(Class))cls {
    return ^MKMediatorAction *(Class cls) {
        MKMediatorAction *act = [[MKMediatorAction alloc] init];
        act.chainCls = NSStringFromClass(cls);
        return act;
    };
}

- (MKMediatorAction * (^)(SEL))method {
    return ^MKMediatorAction *(SEL method) {
        NSString *selStr = NSStringFromSelector(method);
        NSString *clearSelStr = [selStr substringToIndex:([selStr length] - 1)];
        self.classMethod = [NSString stringWithFormat:@"%@ %@", self.chainCls, clearSelStr];
        return self;
    };
}

@end

@interface MKMediatorParameters ()

@property (nonatomic, strong) NSMutableDictionary *chainDict;
@property (nonatomic, strong) NSString *chainCurrentKey;

@end

@implementation MKMediatorParameters

+ (MKMediatorParameters *)create {
    return [[MKMediatorParameters alloc] init];
}

- (MKMediatorParameters * (^)(NSString *))key {
    return ^MKMediatorParameters *(NSString *key) {
        self.chainCurrentKey = key;
        return self;
    };
}

- (MKMediatorParameters *(^)(id))value {
    return ^MKMediatorParameters *(id value) {
        self.chainDict[self.chainCurrentKey] = value;
        return self;
    };
}

- (NSMutableDictionary *)dictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.chainDict];
    self.chainDict = [NSMutableDictionary dictionary];
    return dict;
}

- (NSMutableDictionary *)chainDict {
    if (!_chainDict) {
        _chainDict = [NSMutableDictionary dictionary];
    }
    return _chainDict;
}

@end
