//
//  ViewController.h
//  talkingphoto
//
//  Created by Walid Sassi on 23/10/13.
//  Copyright (c) 2013 Walid Sassi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    AVAudioPlayer *audioplayer;
     UIImage * selectedImage;
    NSMutableArray *savedimages;
    NSString *path;
   NSNumber *element;
    NSURL *outputFileURL;
    NSString *filePath;
    int currentPic;
}
- (IBAction)twitter:(id)sender;
- (IBAction)facebook:(id)sender;
- (IBAction)previous:(id)sender;
- (IBAction)next:(id)sender;
- (IBAction)deletesound:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *config;
@property (strong, nonatomic) IBOutlet UIView *help;
- (IBAction)deletepicture:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *guide02;
@property (strong, nonatomic) IBOutlet UIImageView *guide;
@property (strong, nonatomic) IBOutlet UIImageView *cadre;
@property (strong, nonatomic) IBOutlet UIView *menu_d;
@property (strong, nonatomic) IBOutlet UIImageView *currentImg;
@property(nonatomic,retain)IBOutlet UIButton * recordB;
@property (strong, nonatomic) IBOutlet UIButton *photo;
@property(nonatomic,retain)IBOutlet UIButton * playB;
@property(nonatomic,retain)IBOutlet UIButton * stopB;
- (IBAction)showconfig:(id)sender;
- (IBAction)showhelp:(id)sender;
- (IBAction)record:(id)sender;
- (IBAction)play:(id)sender;
- (IBAction)stop:(id)sender;
- (IBAction)takephoto:(id)sender;
@end
