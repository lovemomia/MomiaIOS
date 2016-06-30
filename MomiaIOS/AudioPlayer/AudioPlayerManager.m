//
//  AudioPlayerManager.m
//  MomiaIOS
//
//  Created by mosl on 16/6/14.
//  Copyright © 2016年 Deng Jun. All rights reserved.
//

#import "AudioPlayerManager.h"
#import "amrFileCodec.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayerManager() <AVAudioRecorderDelegate>

@property (nonatomic, strong) NSData *audioData;
@property (nonatomic, strong) NSURL * recordedTmpFile;
@property (nonatomic, strong) AVAudioRecorder * recorder;
@property (nonatomic, strong) AVPlayer *player;

@end

@implementation AudioPlayerManager

static double startRecordTime=0;
static double endRecordTime=0;

RCT_EXPORT_MODULE()

//开始录音
RCT_EXPORT_METHOD(startRecord) {
    
    startRecordTime = [NSDate timeIntervalSinceReferenceDate];
    NSDictionary *recordSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                   [NSNumber numberWithFloat:8000.00], AVSampleRateKey,
                                   [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
                                   [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                   [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                   [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                   nil];
    
    self.recordedTmpFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent: [NSString stringWithFormat: @"%.0f.%@", [NSDate timeIntervalSinceReferenceDate] * 1000.0, @"caf"]]];
    NSError *error;
    self.recorder = [[ AVAudioRecorder alloc] initWithURL:self.recordedTmpFile settings:recordSetting error:&error];
    [self.recorder setDelegate:self];
    [self.recorder prepareToRecord];
    [self.recorder record];
}

//停止录音
RCT_EXPORT_METHOD(stopRecord) {
    
    NSURL *url = [[NSURL alloc]initWithString:self.recorder.url.absoluteString];
    [self.recorder stop];
    
    endRecordTime = [NSDate timeIntervalSinceReferenceDate];
    endRecordTime -= startRecordTime;
    if (endRecordTime<2.00f) {
        NSLog(@"录音时间过短");
        return;
    }
    
    if (url != nil) {
        self.audioData = EncodeWAVEToAMR([NSData dataWithContentsOfURL:url],1,16);
    }
}

//播放语音
RCT_EXPORT_METHOD(play) {
    
    NSData *outData = DecodeAMRToWAVE(self.audioData);
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"temp.wav"]];
    
    NSLog(@"===%@",databasePath);
    [outData writeToFile:databasePath atomically:YES];
    
    NSURL *localPath = [[NSURL alloc]initFileURLWithPath:databasePath];
    self.player = [[AVPlayer alloc]initWithURL:localPath];
    [self.player play];
}

//上传语音
RCT_EXPORT_METHOD(uploadAudioFile) {
    
    NSLog(@"hello upload");
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"88.amr"]];
    
    NSLog(@"===%@",databasePath);
    
    [[HttpService defaultService] uploadAudioWithFilePath:databasePath fileName:@"audioFile" handler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        
    }];
}

@end
