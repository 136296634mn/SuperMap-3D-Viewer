//
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import "ViewController.h"
#import <SuperMap/SuperMap.h>

@interface ViewController ()
{
    SceneControl *_sceneControl;
}

@property (strong, nonatomic) IBOutlet SceneControl *sceneControl;

@end

@implementation ViewController

@synthesize sceneControl = _sceneControl;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [_sceneControl initSceneControl:self];
    _sceneControl.action3D = PANSELECT3D;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
