//
//  AWSSiriViewController.m
//  AwesomeiOS
//
//  Created by txooo on 2018/9/12.
//  Copyright © 2018年 领琾. All rights reserved.
//

#import "AWSSiriWaveViewController.h"
#import "AWSWaveView.h"

@interface AWSSiriWaveViewController ()
@property (nonatomic, strong) AVAudioPlayer *playr;
@property (nonatomic, strong) AVAudioRecorder *recorder;

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, strong) AWSWaveView *waveView;

@end

@implementation AWSSiriWaveViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [_displayLink invalidate];
    _displayLink = nil;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.waveView];
    
    [self performSelector:@selector(configRecorder) withObject:nil afterDelay:0];
}

- (void)configRecorder {
    NSDictionary *settings = @{ AVSampleRateKey : @(44100.0),
                                AVFormatIDKey : [NSNumber numberWithInt:kAudioFormatAppleLossless],
                                AVNumberOfChannelsKey : [NSNumber numberWithInt:2],
                                AVEncoderAudioQualityKey : [NSNumber numberWithInt:AVAudioQualityMin] };
    
    NSError *error;
    NSString *documentsDirectory= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *localPath = [documentsDirectory stringByAppendingPathComponent:@"/AWS/records"];
    
    NSFileManager *mgr = [NSFileManager defaultManager];
    if (![mgr fileExistsAtPath:localPath]) {
        [mgr createDirectoryAtPath:localPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *fileName = @"record.caf";//[NSString stringWithFormat:@"%f.caf", [NSDate timeIntervalSinceReferenceDate]];
    
    NSURL *url = [NSURL fileURLWithPath:[localPath stringByAppendingPathComponent:fileName]];
    self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    if (error) {
        NSLog(@"错误:%@", error.localizedDescription);
        return;
    }
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    
    if (error) {
        NSLog(@"错误:%@", error.localizedDescription);
    }

    CADisplayLink *displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeters)];
    [displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    _displayLink = displaylink;
    [self prepareToRecord];
}

- (void)prepareToRecord {
    [self.recorder prepareToRecord];
    [self.recorder setMeteringEnabled:YES];
    [self.recorder record];
}

- (void)updateMeters {
    CGFloat normalizedValue;
    [self.recorder updateMeters];
    normalizedValue = [self _normalizedPowerLevelFromDecibels:[self.recorder averagePowerForChannel:0]];
    [self.waveView updateWavePhase:normalizedValue];
}

#pragma mark - Private 参照SCSiriWaveformView
- (CGFloat)_normalizedPowerLevelFromDecibels:(CGFloat)decibels {
    if (decibels < -60.0f || decibels == 0.0f) {
        return 0.0f;
    }
    return powf((powf(10.0f, 0.05f * decibels) - powf(10.0f, 0.05f * -60.0f)) * (1.0f / (1.0f - powf(10.0f, 0.05f * -60.0f))), 1.0f / 2.0f);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (AWSWaveView *)waveView {
    if (!_waveView) {
        _waveView = [[AWSWaveView alloc] initWithFrame:self.view.bounds];
    }
    return _waveView;
}

@end
