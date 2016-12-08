//
//  ViewController.m
//  talkingphoto
//
//  Created by Walid Sassi on 23/10/13.
//  Copyright (c) 2013 Walid Sassi. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    currentPic=0;
    element=0;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(dismissPopUp)];
    [self.view addGestureRecognizer:tapRecognizer];
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    // Define the recorder setting
      // [recorder prepareToRecord];
        //verifier si on  des images dans la liste
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    path = [documentsDirectory stringByAppendingPathComponent:@"list.plist"];
    savedimages = [[NSMutableArray alloc] initWithContentsOfFile: path];
    _currentImg=[[UIImageView alloc]init];
    [_currentImg setFrame:CGRectMake(18, 103, 280, 324)];
    [self.view addSubview:_currentImg];
    UIImage *c=[UIImage imageNamed:@"cadre"];
    _cadre=[[UIImageView alloc]initWithImage:c];
    [_cadre setFrame:CGRectMake(6, 92, 306, 345)];
    [self.view addSubview:_cadre];
    c=[UIImage imageNamed:@"guide01"];
    _guide=[[UIImageView alloc]initWithImage:c];
    [_guide setFrame:CGRectMake(87, 53, 168, 38)];
    [self.view addSubview:_guide];
    [_cadre setHidden:YES];
    [_guide setHidden:YES];
    [_currentImg setHidden:YES];
    [self.view addSubview:_photo];
    if ([[[savedimages objectAtIndex:currentPic]valueForKey:@"nom"]isEqualToString:@""])
    {
        _photo.hidden=NO;
        _guide02.hidden=NO;
    }
    else
    {
        [self drawphoto];
       
        
    }
    
    
}
-(void)dismissPopUp
{
    //your dimiss code here
    _config.hidden=YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showconfig:(id)sender {
    [UIView transitionWithView:_config
                      duration:2.0
                       options:UIViewAnimationOptionTransitionFlipFromBottom
                    animations:^{
                        [self.view addSubview:_config];
                        
                    }
                    completion:NULL];

    _config.hidden=NO;
}
- (IBAction)showhelp:(id)sender
{
       [UIView transitionWithView:_help
                      duration:1.0
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        [self.view addSubview:_help];

                    }
                    completion:NULL];
    _help.hidden=NO;
}
- (IBAction)exithelp:(id)sender
{
   _help.hidden=YES;
}
- (void)playSound {
    
    audioplayer = [[AVAudioPlayer alloc] init];
    
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/button.mp3", [[NSBundle mainBundle] resourcePath]]];
    
	NSError *error;
    
    (void) [audioplayer initWithContentsOfURL:url error:&error];
    [audioplayer play];
}
- (IBAction)record:(id)sender
{
    // Set the audio file
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *docsDir = [dirPaths objectAtIndex:0];
    outputFileURL = [NSURL fileURLWithPath:[docsDir stringByAppendingPathComponent:[NSString stringWithFormat: @"%d.%@",currentPic, @"caf"]]];
   AVAudioSession *session = [AVAudioSession sharedInstance];
   [session setActive:YES error:nil];
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
    NSDictionary *recordSettings = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityMin],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16],
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 2],
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:44100.0],
                                    AVSampleRateKey,
                                    nil];
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSettings error:NULL];
    recorder.delegate = self;
   // This should be 0 or there was an
    [recorder record];
}
- (IBAction)stop:(id)sender
{
    [recorder stop];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    [[savedimages objectAtIndex:currentPic]setValue:[NSString stringWithFormat:@"%d",currentPic] forKey:@"sound"];
    [savedimages writeToFile: path atomically:YES];
}
- (IBAction)play:(id)sender
{
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),&audioRouteOverride);
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     [self playSound];
    NSString *docsDir = [dirPaths objectAtIndex:0];
   outputFileURL = [NSURL fileURLWithPath:[docsDir stringByAppendingPathComponent:[NSString stringWithFormat: @"%d.%@",currentPic, @"caf"]]];
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:outputFileURL error:nil];
         NSLog(@"%@",player.data);
        [player setDelegate:self];
        [player play];
        [player setVolume:1.0];
}
- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    

    
}
- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag
{
   
    
}

- (IBAction)takephoto:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"talking photo"
                                                             delegate:self
                                                    cancelButtonTitle:@"إلغاء"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"كاميرا", @"إختر من المكتبة", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}
#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int j = buttonIndex;
    switch(j)
    {
        case 0:
        {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init] ;
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:^{}];
        }
            break;
        case 1:
        {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init] ;
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:^{}];
        }
        default:
            // Do Nothing.........
            break;
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	// Picking Image from Camera/ Library
    [picker dismissViewControllerAnimated:YES completion:^{}];
    selectedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if (!selectedImage)
    {
        return;
    }
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    [[savedimages objectAtIndex:currentPic]setValue:[NSString stringWithFormat:@"%d",currentPic] forKey:@"nom"];
    [savedimages writeToFile: path atomically:YES];
    
    NSString  *path2 = [NSHomeDirectory() stringByAppendingPathComponent:
                        [NSString stringWithFormat: @"Documents/%d.jpg",currentPic]];
    [UIImageJPEGRepresentation(selectedImage,1.0) writeToFile:path2 atomically:YES];
    [self drawphoto];
  
}
-(void)drawphoto
{
    
    NSString  *path2 = [NSHomeDirectory() stringByAppendingPathComponent:
        [NSString stringWithFormat: @"Documents/%d.jpg",currentPic]];
        _currentImg.image=[[UIImage alloc]initWithContentsOfFile:path2];
    //show menu
    [_cadre setHidden:NO];
    [_guide setHidden:NO];
    [_currentImg setHidden:NO];
    [_photo setHidden:YES];
    [_guide02 setHidden:YES];
    _menu_d.hidden=NO;

    

}
-(void)showpick
{
   
    _photo.hidden=NO;
    _guide02.hidden=NO;
    [_cadre setHidden:YES];
    [_guide setHidden:YES];
    [_currentImg setHidden:YES];
    [self playSound];
    [UIView animateWithDuration:0.3/2.5 animations:^{
       _photo.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/3 animations:^{
            _photo.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/4 animations:^{
                _photo.transform = CGAffineTransformIdentity;
                [self.view layoutIfNeeded];
            }];
        }];
    }];


}

- (IBAction)deletepicture:(id)sender {
    NSString  *path2 = [NSHomeDirectory() stringByAppendingPathComponent:
                        [NSString stringWithFormat: @"Documents/%d.jpg",currentPic]];
    [[NSFileManager defaultManager] removeItemAtPath: path2 error:Nil];
    // delete sound also
    NSString  *path3 = [NSHomeDirectory() stringByAppendingPathComponent:
                        [NSString stringWithFormat: @"Documents/%d.caf",currentPic]];
    [[NSFileManager defaultManager] removeItemAtPath: path3 error:Nil];
    [[savedimages objectAtIndex:currentPic]setValue:@"" forKey:@"nom"];
    [savedimages writeToFile: path atomically:YES];
    [self showpick];
   
}
- (IBAction)twitter:(id)sender {
    NSURL *   url = [ [ NSURL alloc ] initWithString: @"https://twitter.com/zhoCare" ];
    [[UIApplication sharedApplication] openURL:url];

}

- (IBAction)facebook:(id)sender {
 NSURL *   url = [ [ NSURL alloc ] initWithString: @"http://www.zho.ae/arabic/Pages/home.aspx" ];
    [[UIApplication sharedApplication] openURL:url];

}

- (IBAction)previous:(id)sender {
    if (currentPic>0)
    {
        currentPic --;
        if ([[[savedimages objectAtIndex:currentPic]valueForKey:@"nom"]isEqualToString:@""])
        {
            
            [self showpick];
        }
        else
        {
            [self drawphoto];
            
        }
       NSLog(@"%d",currentPic);
    }
    
}

- (IBAction)next:(id)sender {
    if (currentPic<21)
    {
        currentPic ++;
        if ([[[savedimages objectAtIndex:currentPic]valueForKey:@"nom"]isEqualToString:@""])
        {
            
            [self showpick];
        }
       else
        {
        [self drawphoto];
        
        }
       NSLog(@"%d",currentPic);
    }
}

- (IBAction)deletesound:(id)sender {
    NSString  *path2 = [NSHomeDirectory() stringByAppendingPathComponent:
                        [NSString stringWithFormat: @"Documents/%d.caf",currentPic]];
    [[NSFileManager defaultManager] removeItemAtPath: path2 error:Nil];
    [[savedimages objectAtIndex:currentPic]setValue:@"" forKey:@"sound"];
    [savedimages writeToFile: path atomically:YES];
    [self playSound];
}
@end
