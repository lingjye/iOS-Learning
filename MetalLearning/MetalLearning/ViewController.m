//
//  ViewController.m
//  MetalLearning
//
//  Created by txooo on 2019/3/29.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "ViewController.h"
#import "MTLVertices.h"
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#import <ModelIO/ModelIO.h>

#define MaxBuffers 3
#define ConstantBufferSize 2048 * 1024

@interface ViewController () <MTKViewDelegate>

@property (nonatomic) id<MTLDevice> device;
@property (nonatomic) id<MTLCommandQueue> commandQueue;
@property (nonatomic) id<MTLRenderPipelineState> pipelineState;
@property (nonatomic) id<MTLBuffer> vertexBuffer;
@property (nonatomic) id<MTLBuffer> vertexColorBuffer;
@property (nonatomic) dispatch_semaphore_t inflightSemaphore;
@property (nonatomic, assign) NSInteger bufferIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // float 4字节
    printf("%ld", sizeof(float));
    // sizeof(vertexData) 480  除以float 所占的4字节 刚好为数组长度 120
    for (int i = 0; i < 120; i++) {
        printf("%f---%ld\n", vertexData[i], sizeof(vertexData));
    }
    _inflightSemaphore = dispatch_semaphore_create(MaxBuffers);

    _device = MTLCreateSystemDefaultDevice();
    if (!_device) {
        printf("Metal is not supported on this device");
        return;
    }

    MTKView *view = MTKView.alloc.init;
    view.device = _device;
    view.delegate = self;

    self.view = view;

    [self loadAssets];
}

- (void)loadAssets {
    // load any resources required for rendering
    _commandQueue = [_device newCommandQueue];
    _commandQueue.label = @"main command queue";

    MTKView *view = (MTKView *)self.view;

    // create library for project
    id<MTLLibrary> defaultLibrary = _device.newDefaultLibrary;
    id<MTLFunction> fragmentProgram = [defaultLibrary newFunctionWithName:@"passThroughFragment"];
    id<MTLFunction> vertexProgram = [defaultLibrary newFunctionWithName:@"passThroughVertex"];

    // create render pipeline descriptor
    MTLRenderPipelineDescriptor *pipelineStateDescriptor = MTLRenderPipelineDescriptor.alloc.init;
    pipelineStateDescriptor.vertexFunction = vertexProgram;
    pipelineStateDescriptor.fragmentFunction = fragmentProgram;
    pipelineStateDescriptor.colorAttachments[0].pixelFormat = view.colorPixelFormat;
    pipelineStateDescriptor.sampleCount = view.sampleCount;

    NSError *error = nil;
    _pipelineState =
        [_device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    // layout memory and set up vertex buffers
    NSInteger dataSize = sizeof(vertexData);
    _vertexBuffer = [_device newBufferWithBytes:vertexData length:dataSize options:0];
    _vertexBuffer.label = @"vertices";

    _vertexColorBuffer = [_device newBufferWithBytes:vertexColorData length:dataSize options:0];
    _vertexColorBuffer.label = @"colors";
}

- (void)drawInMTKView:(nonnull MTKView *)view {
    // use semaphore to encode 3 frames ahead
    dispatch_semaphore_wait(_inflightSemaphore, DISPATCH_TIME_FOREVER);
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    commandBuffer.label = @"frame command buffer";
    
    // use completion handler to signal the semaphore when this frame is completed allowing the encoding of the next frame to proceed
    // use capture list to avoid any retain cycles if the command buffer gets retained anywhere besides this stack frame
    __weak typeof(self) weakSelf = self;
    [commandBuffer addCompletedHandler:^(id<MTLCommandBuffer> _Nonnull buffer) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_semaphore_signal(strongSelf.inflightSemaphore);
    }];
    
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;
    id<MTLDrawable> currentDrawable = view.currentDrawable;
    if (renderPassDescriptor && currentDrawable) {
        id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        renderEncoder.label = @"render encoder";
        
        [renderEncoder pushDebugGroup:@"draw star"];
        [renderEncoder setRenderPipelineState:_pipelineState];
        
        [renderEncoder setVertexBuffer:_vertexBuffer offset:0 atIndex:0];
        [renderEncoder setVertexBuffer:_vertexColorBuffer offset:0 atIndex:1];
        [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:120];
        
        [renderEncoder popDebugGroup];
        [renderEncoder endEncoding];
        [commandBuffer presentDrawable:currentDrawable];
    }
    
    // bufferIndex matches the current semaphore controled frame index to ensure writing occurs at the correct region in the vertex buffer
    _bufferIndex = (_bufferIndex + 1) % MaxBuffers;
    
    [commandBuffer commit];
}

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size {
    
}

@end
