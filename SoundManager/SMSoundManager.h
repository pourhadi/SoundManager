//
//  SMSoundManager.h
//  SoundManager
//
//  Created by Daniel Pourhadi on 1/14/16.
//  Copyright © 2016 Daniel Pourhadi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SMSoundManager;
@class AVURLAsset;

@protocol SMSoundManagerDelegate <NSObject>
@optional
- (void)soundManager:(SMSoundManager*)soundManager playStateChanged:(BOOL)playing;
- (void)soundManager:(SMSoundManager *)soundManager elapsedTimeUpdated:(NSTimeInterval)elapsedTime; // is NOT delivered on the main queue
- (void)soundManagerTrackFinishedPlaying:(SMSoundManager *)soundManager;
- (void)soundManager:(SMSoundManager *)soundManager URLReadyToPlay:(NSURL*)url;
- (void)soundManager:(SMSoundManager *)soundManager errorPlayingTrack:(NSError*)error;
@end

@interface SMSoundManager : NSObject

+ (SMSoundManager*)sharedInstance;
@property (nonatomic, weak) id<SMSoundManagerDelegate> delegate;

- (void)loadAudioAtURL:(NSURL*)url play:(BOOL)play;
- (void)loadAsset:(AVURLAsset*)asset play:(BOOL)play;

- (void)play;
- (void)pause;

- (BOOL)isPlaying;
- (NSURL*)url;
- (NSTimeInterval)elapsedTime;
- (NSTimeInterval)trackDuration;

@end
