//
//  HistoryViewController.m
//  AnniversairePapa
//
//  Created by Pierre Besson on 02/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HistoryViewController.h"
#import "Personne.h"

//Génération des setter/getter
@implementation HistoryViewController
@synthesize segmentedControl;
@synthesize imageView;
@synthesize personnesArray;
@synthesize textView;
@synthesize swipeLeftRecognizer;
@synthesize swipeRightRecognizer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void) initPersonnes{
    //On charge les données depuis le fihier .plist
    NSString *path = [[NSBundle mainBundle] pathForResource:@"NomPrenom" ofType:@"plist"];
    NSDictionary *dictFromFile = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSArray *arrayFromFile = [dictFromFile objectForKey:@"Root"];
    
    // Créons un tableau temporaire que nous allons remplir avec un objet Personnes par NSDictionnary contenu dans le fichier .plist
    // Notez l'utilisation de NSEnumerator pour parcourir un tableau
    personnesArray = [[NSMutableArray alloc] init];
    NSEnumerator *enumerator = [arrayFromFile objectEnumerator];
    NSDictionary *anObject;
    //On ajoute tous les éléments de la liste du fichier .plist.
    while ((anObject = [enumerator nextObject])) {
        Personne *personne = [[Personne alloc] initWithDictionaryFromPlist: anObject];
        [personnesArray addObject: personne];
        //[personne release];//On ne s'occupe pas de a liberation de mémoire dans iOs5.
    }
}

- (void) initImageAndTextView{
    textView.text  = [[personnesArray objectAtIndex:[segmentedControl selectedSegmentIndex]] message];
    [textView setOpaque:TRUE];
    [imageView setImage:[UIImage imageNamed:@"IMG_0992_face0.jpg"]];
    [imageView setOpaque:TRUE];
    [self.view addSubview:imageView];
    [self.view addSubview:textView];
}
-(void) updateImageView:(bool) isLeft{
    NSString *imageNom;
    if(isLeft){
        imageNom = @"IMG_0992_face0.jpg";
    } else{
        imageNom = @"DSC01133_face1.jpg";
    }
    [imageView setImage:[UIImage imageNamed:imageNom]];
    [imageView setOpaque:TRUE];
    //[self.view addSubview:imageView];
}

//Faire une méthode qui fait la même chose mais pour le bouton sélectionné.

- (void) initSegmentControl{
    
    [segmentedControl removeAllSegments];
    NSInteger i =0;
    for(Personne* personne in personnesArray){
        [segmentedControl insertSegmentWithTitle:personne.surnom atIndex:i animated:FALSE];
        if(i == 0){
            [segmentedControl setSelectedSegmentIndex:i];
        }
        i++;
    }
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    
    CGPoint location = [recognizer locationInView:self.view];
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self updateImageView:TRUE];
    } 
    else {
        [self updateImageView:FALSE];
    }
    
    //[UIView beginAnimations:nil context:NULL];
    //[UIView setAnimationDuration:0.55];
    imageView.alpha = 0.0;
    imageView.center = location;
    //[UIView commitAnimations];
}

- (void)createGestureRecognizers {
    UIGestureRecognizer *recognizer;
    //The right swipe recognizer. 
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeForm:)]; //Target est la classe qui va prendre en charge le callback
    self.swipeRightRecognizer = (UISwipeGestureRecognizer *) recognizer;
    swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.imageView addGestureRecognizer:swipeRightRecognizer];
    
    //The left swipe recognizer
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeForm:)]; //Target est la classe qui va prendre en charge le callback
    self.swipeLeftRecognizer = (UISwipeGestureRecognizer *) recognizer;
    swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.imageView addGestureRecognizer:swipeLeftRecognizer];
  /*  UITapGestureRecognizer *singleFingerDTap = [[UITapGestureRecognizer alloc]
                                                initWithTarget:self action:@selector(handleSingleDoubleTap:)];
    singleFingerDTap.numberOfTapsRequired = 2;
    [s addGestureRecognizer:singleFingerDTap];
    [singleFingerDTap release];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handlePanGesture:)];
    [self.theView addGestureRecognizer:panGesture];
    [panGesture release];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(handlePinchGesture:)];
    [self.theView addGestureRecognizer:pinchGesture];
    [pinchGesture release];*/
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    //On fait toutes les initialisations nécessaires. 
    [self initPersonnes];
    [self initSegmentControl];
    [self initImageAndTextView];
   // [self createGestureRecognizers];
    //[segmentedControl touchesBegan:<#(NSSet *)#> withEvent:<#(UIEvent *)#>]
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end