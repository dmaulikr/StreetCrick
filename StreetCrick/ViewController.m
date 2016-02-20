//
//  ViewController.m
//  StreetCrick
//
//  Created by Nithin Reddy Gaddam on 2/6/16.
//  Copyright (c) 2016 Nithin Reddy Gaddam. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *displayRuns;

@property (weak, nonatomic) IBOutlet UITextField *displayOvers;

@property (weak, nonatomic) IBOutlet UILabel *striker;

@property (weak, nonatomic) IBOutlet UITextField *strikerRuns;
@property (weak, nonatomic) IBOutlet UITextField *strikerBalls;
@property (weak, nonatomic) IBOutlet UITextField *striker4;
@property (weak, nonatomic) IBOutlet UITextField *striker6;

@property (weak, nonatomic) IBOutlet UILabel *nonStriker;
@property (weak, nonatomic) IBOutlet UITextField *nonStrikerRuns;
@property (weak, nonatomic) IBOutlet UITextField *nonStrikerBalls;
@property (weak, nonatomic) IBOutlet UITextField *nonStriker4;
@property (weak, nonatomic) IBOutlet UITextField *nonStriker6;

@property (weak, nonatomic) IBOutlet UILabel *bowler;
@property (weak, nonatomic) IBOutlet UITextField *bowlerOvers;
@property (weak, nonatomic) IBOutlet UITextField *bowlerRuns;
@property (weak, nonatomic) IBOutlet UITextField *bowlerWickets;
@property (weak, nonatomic) IBOutlet UITextField *bowlerER;
@property (weak, nonatomic) IBOutlet UITextField *displayWickets;

@property (weak, nonatomic) IBOutlet UILabel *displayToWin;
@property (weak, nonatomic) IBOutlet UILabel *displayInnings;
@property (weak, nonatomic) IBOutlet UILabel *displayTeam;

@end

@implementation ViewController

int runs = 0;
int balls = 0;
int wickets = 0;
int extra = 0;
int striker[4] = {0,0,0,0};
int nonStriker[4] = {0,0,0,0};
int bowler[4] = {0,0,0,0};
bool secondInnings = false;

//to dismiss keyboard when you touch something else
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

int runsA = 0;

- (IBAction)secondInnings:(id)sender {
    
    UIAlertView *innings = [[UIAlertView alloc] initWithTitle:@"End of innings" message:@"Are you sure you want to end the innings?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    [innings show];
    
}

// This function will be called by the UIAlertView.
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex != 0)
    {
        runsA = runs + 1;
        runs = 0;
        balls = 0;
        wickets = 0;
        extra = 0;
        
        for(int x = 0; x <4; x++)
        {
            striker[x] = 0;
            nonStriker[x] = 0;
            bowler[x] = 0;
        }
        
        self.displayInnings.text = @"2nd Innings";
        self.displayTeam.text = @"Team B";
        secondInnings = true;
        
        [self updateScore];
        [self updateBoundary];
        [self updateNonStriker];
    }
    // The cancel button ("OK") is always index 0.
    // The index of the other buttons is the order they're defined.
}

- (IBAction)out:(id)sender {
    bowler[0] = bowler[0] +1;
    bowler[2] = bowler[2] +1;
    balls = balls +1;
    striker[1] = striker[1] + 1;
    wickets = wickets + 1;
    
    striker[0] = 0;
    striker[1] = 0;
    striker[2] = 0;
    striker[3] = 0;
    
    
    [self updateScore];
    [self updateBoundary];
}

- (IBAction)extra:(id)sender {
    bowler[1] = bowler[1] +1;
    bowler[3] = bowler[3] +1;
    extra = extra + 1;
    runs = runs + 1;
    [self updateScore];
}

- (IBAction)dotBall:(id)sender {
    balls = balls +1;
    striker[1] = striker[1] + 1;
    bowler[0] = bowler[0] +1;
    [self updateScore];
    
}

- (IBAction)oneRun:(id)sender {
    runs = runs + 1;
    balls = balls + 1;
    striker[0] = striker[0] + 1;
    striker[1] = striker[1] + 1;
    bowler[0] = bowler[0] +1;
    bowler[1] = bowler[1] +1;
    [self switchBatsman];
    [self updateScore];
}

- (IBAction)twoRuns:(id)sender {
    runs = runs + 2;
    balls = balls + 1;
    striker[0] = striker[0] + 2;
    striker[1] = striker[1] + 1;
    bowler[1] = bowler[1] +2;
    bowler[0] = bowler[0] +1;
    [self updateScore];
}

- (IBAction)threeRuns:(id)sender {
    bowler[0] = bowler[0] +1;
    bowler[1] = bowler[1] +3;
    runs = runs + 3;
    balls = balls + 1;
    striker[0] = striker[0] + 3;
    striker[1] = striker[1] + 1;
    [self switchBatsman];
    [self updateScore];
}

- (IBAction)fourRuns:(id)sender {
    bowler[0] = bowler[0] +1;
    bowler[1] = bowler[1] +4;
    runs = runs + 4;
    balls = balls + 1;
    striker[0] = striker[0] + 4;
    striker[1] = striker[1] + 1;
    striker[2] = striker[2] + 1;
    [self updateScore];
    [self updateBoundary];
}

- (IBAction)sixRuns:(id)sender {
    bowler[0] = bowler[0] +1;
    bowler[1] = bowler[1] +6;
    runs = runs + 6;
    balls = balls + 1;
    striker[0] = striker[0] + 6;
    striker[1] = striker[1] + 1;
    striker[3] = striker[3] + 1;
    [self updateScore];
    [self updateBoundary];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)switchBatsman {
    int temp;
    
    
    NSString *temp2 = self.striker.text;
    
    self.striker.text = self.nonStriker.text;
    self.strikerRuns.text = [@(nonStriker[0]) stringValue];
    self.strikerBalls.text = [@(nonStriker[1]) stringValue];
    self.striker4.text = [@(nonStriker[2]) stringValue];
    self.striker6.text = [@(nonStriker[3]) stringValue];
    
    self.nonStriker.text = temp2;
    self.nonStrikerRuns.text = [@(striker[0]) stringValue];
    self.nonStrikerBalls.text = [@(striker[1]) stringValue];
    self.nonStriker4.text = [@(striker[2]) stringValue];
    self.nonStriker6.text = [@(striker[3]) stringValue];
    
    for(int i = 0; i <4; i++)
    {
        temp = striker[i];
        striker[i] = nonStriker[i];
        nonStriker[i] = temp;
    }
}

- (float)calculateOvers:(int)balls {
    float ball = balls/6;
    float ball2 = balls%6;
    float overs =  ball + ball2/10;
    return overs ;
}

-(void)updateScore {
    self.displayOvers.text = [@([ self calculateOvers: balls]) stringValue];
    self.displayRuns.text = [@(runs) stringValue];
    self.displayWickets.text = [@(wickets) stringValue];
    self.strikerRuns.text = [@(striker[0]) stringValue];
    self.strikerBalls.text = [@(striker[1]) stringValue];
    self.bowlerOvers.text = [@([ self calculateOvers: bowler[0]]) stringValue];
    self.bowlerRuns.text = [@(bowler[1]) stringValue];
    self.bowlerWickets.text = [@(bowler[2]) stringValue];
    self.bowlerER.text = [@(bowler[3]) stringValue];
    
    if (secondInnings == true)
    {
        if (runs < runsA & wickets < 10)
        {
            int win = runsA - runs;
            self.displayToWin.text = [NSString stringWithFormat:@"To win: %d", win];
        }
        else if ((runs >= runsA)  )
        {
            self.displayToWin.text = @"Team batting 2nd won";
        }
        else if (wickets == 10)
        {
            self.displayToWin.text = @"Team batting 1st won";
        }
    }
    
    
   
}

-(void)updateBoundary {
    self.striker4.text = [@(striker[2]) stringValue];
    self.striker6.text = [@(striker[3]) stringValue];
}

-(void)updateNonStriker {
    self.nonStrikerRuns.text = [@(nonStriker[0]) stringValue];
    self.nonStrikerBalls.text = [@(nonStriker[1]) stringValue];
    self.nonStriker4.text = [@(nonStriker[2]) stringValue];
    self.nonStriker6.text = [@(nonStriker[3]) stringValue];
}
@end
