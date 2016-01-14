//
//  SMSoundManager.m
//  SoundManager
//
//  Created by Daniel Pourhadi on 1/14/16.
//  Copyright © 2016 Daniel Pourhadi. All rights reserved.
//

#import "SMSoundManager.h"
#import <AVFoundation/AVFoundation.h>

@interface SMSoundManager () {
    dispatch_queue_t _observationQueue;
}

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) id observer;
@end

@implementation SMSoundManager

+ (instancetype)sharedInstance {
    static SMSoundManager* instance = nil;
    static dispatch_once_t onceQueue;
    dispatch_once(&onceQueue, ^{ instance = [[self alloc] init]; });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.player = [[AVPlayer alloc] init];
        self.player.actionAtItemEnd = AVPlayerActionAtItemEndPause;
        [self addObserver:self forKeyPath:@"player.currentItem.status" options:0 context:nil];
        [self addObserver:self forKeyPath:@"player.rate" options:0 context:nil];
        
        _observationQueue = dispatch_queue_create("com.pourhadi.SoundManager.ObservationQueue", DISPATCH_QUEUE_SERIAL);
        
        __weak SMSoundManager *weakSelf = self;
        self.observer = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 10) queue:_observationQueue usingBlock:^(CMTime time) {
            if ([weakSelf.delegate respondsToSelector:@selector(soundManager:elapsedTimeUpdated:)]) {
                NSTimeInterval seconds = CMTimeGetSeconds(time);
                [weakSelf.delegate soundManager:weakSelf elapsedTimeUpdated:seconds];
            }
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playedToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"player.currentItem.status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"player.currentItem.status"]) {
        if (self.player.currentItem.status == AVPlayerItemStatusFailed) {
            if ([self.delegate respondsToSelector:@selector(soundManager:errorPlayingTrack:)]) {
                [self.delegate soundManager:self errorPlayingTrack:self.player.currentItem.error];
            }
        } else if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
            if ([self.delegate respondsToSelector:@selector(soundManager:URLReadyToPlay:)]) {
                [self.delegate soundManager:self URLReadyToPlay:[(AVURLAsset*)self.player.currentItem.asset URL]];
            }
        }
    } else if ([keyPath isEqualToString:@"player.rate"]) {
        if ([self.delegate respondsToSelector:@selector(soundManager:playStateChanged:)]) {
            [self.delegate soundManager:self playStateChanged:[self isPlaying]];
        }
    }
}

- (void)loadAudioAtURL:(NSURL*)url play:(BOOL)play {
    [self loadAsset:[AVURLAsset assetWithURL:url] play:play];
}

- (void)loadAsset:(AVURLAsset*)asset play:(BOOL)play {
    [self.player pause];
    [self.player replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithAsset:asset]];
    if (play) {
        [self.player play];
    }
}

- (void)play {
    [self.player play];
}

- (void)pause {
    [self.player pause];
}

- (BOOL)isPlaying {
    return self.player.rate == 1;
}

- (NSURL*)url {
    return [(AVURLAsset*)self.player.currentItem.asset URL];
}

- (NSTimeInterval)elapsedTime {
    NSTimeInterval seconds = CMTimeGetSeconds(self.player.currentTime);
    return seconds;
}

- (NSTimeInterval)trackDuration {
    NSTimeInterval seconds = CMTimeGetSeconds(self.player.currentItem.duration);
    return seconds;
}

- (void)playedToEnd:(NSNotification*)notification {
    if (notification.object == self.player.currentItem) {
        if ([self.delegate respondsToSelector:@selector(soundManagerTrackFinishedPlaying:)]) {
            [self.delegate soundManagerTrackFinishedPlaying:self];
        }
    }
}

@end
