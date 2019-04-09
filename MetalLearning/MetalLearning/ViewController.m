//
//  ViewController.m
//  MetalLearning
//
//  Created by txooo on 2019/3/29.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "ViewController.h"
#import "MTLVertices.h"
#import "MTLShaders.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    MTLVertices *vertices = [[MTLVertices alloc] init];
    NSLog(@"%@", vertices.description);
    for (int i = 0; i < 120; i++) {
        printf("%f---%ld\n", vertices -> vertexData[i], sizeof(vertices->vertexData));
    }
}


@end
