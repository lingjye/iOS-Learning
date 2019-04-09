//
//  MTLShaders.h
//  MetalLearning
//
//  Created by txooo on 2019/3/29.
//  Copyright © 2019 txooo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <Metal/Metal.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct VertexIn
{
    packed_float3  position;
    packed_float2  texcoord;
};

struct VertexOut
{
    float4  position [[position]];
    float2  texcoord;
};

struct Uniforms
{
    float animationElapsedTime;
    float animationTotalTime;
    packed_float3 gatherPoint;
};
@interface MTLShaders : NSObject

@end

NS_ASSUME_NONNULL_END
