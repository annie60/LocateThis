//
//  FavoritosViewController.m
//  LocateThis
//
//  Created by DA2 on 10/20/14.
//  Last updated: 10/21/2014
//  General Description: Controlador para la sección de toma de fotografía.

//  Copyright (c) 2014 ITESM. All rights reserved.
////

#import "FotoViewController.h"
#import "UNIRest.h"
#import "MapaViewController.h"
@interface FotoViewController (){
    NSString*palabra;
}

@end

@implementation FotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    BOOL isCameraAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if(isCameraAvailable) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
        
    } else {
        UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"El equipo no tiene camara" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alerta show];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"irMapa"]){
            [[segue destinationViewController] setCategoria:palabra];
    }
    
}

#pragma mark UIImagePickerControllerDelegate
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if(image == nil) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    self.ImagenFoto.image = image;
    if([picker sourceType] == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void) image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *) contextInfo {
    if(error){
        UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Save failed"
                                                         message:@"Failed to save image"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [alerta show];
    }
}
-(void) imagePickerControllerDidCancel:(UIImagePickerController *) picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)buscar:(id)sender {
    // Get the path to the Documents folder
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectoryPath = [paths objectAtIndex:0];
    //
    //        // Get the path to an file named "tmp_image.jpg" in the Documents folder
    NSString *imagePath = [documentDirectoryPath stringByAppendingPathComponent:@"tmp_image.jpg"];
    NSURL *imageURL = [NSURL fileURLWithPath:imagePath];
    
    // Write the image to an file called "tmp_image.jpg" in the Documents folder
    NSData *imageData = UIImageJPEGRepresentation(self.ImagenFoto.image, 1.0);
    [imageData writeToURL:imageURL atomically:YES];
    
    
    NSDictionary* parameters = @{@"focus[x]": @"480", @"focus[y]": @"640", @"image_request[altitude]": @"27.912109375", @"image_request[language]": @"en", @"image_request[latitude]": @"35.8714220766008", @"image_request[locale]": @"en_US", @"image_request[longitude]": @"14.3583203002251", @"image_request[image]": imageURL};
    
    // And the headers
    NSDictionary* headers = @{@"X-Mashape-Key":@"evGDsuPOjemsh7rcxyGVnnNVZoZJp16Ecurjsno4pspMAHqplY",  @"Content-Type": @"application/x-www-form-urlencoded"};
    //NSError *error;
    // Call the API using Unirest
    UNIUrlConnection *asyncConnection = [[UNIRest post:^(UNISimpleRequest *request) {
        [request setUrl:@"https://camfind.p.mashape.com/image_requests"];
        [request setHeaders:headers];
        [request setParameters:parameters];
    }] asJsonAsync:^(UNIHTTPJsonResponse *response, NSError *error) {
        //NSInteger code = response.code;
        //NSDictionary *responseHeaders = response.headers;
       //UNIJsonNode *body = response.body;
       // NSData *rawBody = response.rawBody;
        NSLog(@"Info %@",response.body.JSONObject);
        //NSDictionary *datos = [NSJSONSerialization JSONObjectWithData:[response.body.JSONObject objectForKey:@"token"]options:kNilOptions error:&error];
       // NSMutableArray*respuesta =[[NSMutableArray alloc]init];
        //respuesta=[datos objectForKey:@"token"];
        NSDictionary *headers1 = @{@"X-Mashape-Key": @"evGDsuPOjemsh7rcxyGVnnNVZoZJp16Ecurjsno4pspMAHqplY"};
        NSString*liga=[NSString stringWithFormat:@"https://camfind.p.mashape.com/image_responses/%@",[response.body.JSONObject objectForKey:@"token"]];
        UNIUrlConnection *asyncConnection = [[UNIRest get:^(UNISimpleRequest *request) {
            
            [request setUrl:liga];
            [request setHeaders:headers1];
        }] asJsonAsync:^(UNIHTTPJsonResponse *response, NSError *error) {
            //NSInteger code = response.code;
            //NSDictionary *responseHeaders = response.headers;
            //UNIJsonNode *body = response.body;
            //NSData *rawBody = response.rawBody;
            NSLog(@"Info %@",response.body.JSONObject);
            NSString*status=[response.body.JSONObject objectForKey:@"status"];
            palabra=[response.body.JSONObject objectForKey:@"name"];
            if (![status isEqualToString:@"Completed"]) {
                UIAlertView*alerta=[[UIAlertView alloc]initWithTitle:@"Error" message:@"No se pudo realizar la identificación, intente denuevo" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
                [alerta show];
            }else{
           self.palabrabusca.text=palabra;
           self.aceptar.hidden=NO;
                self.cancelar.hidden=NO;}
        }];
    }];
    
    
    
}

@end
