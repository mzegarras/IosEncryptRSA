//
//  ViewController.m
//  encryptdata
//
//  Created by Manuel Zegarra on 26/08/15.
//  Copyright (c) 2015 M-Sonic. All rights reserved.
//

#import "ViewController.h"

#include <stdio.h>
#import <Security/Security.h>


@interface ViewController ()

@end

@implementation ViewController



- (IBAction)btnGenerate:(id)sender{
    
    //const char *plainTextString = ["pruebas de sms" UTF8String];
    
    NSString* texto = @"YA ESTAMOS LISTOS PARA ENCRIPTAR JEJEJE";
    
    [self encryptRSA:texto];
    
}


-(NSString *)encryptRSA:(NSString*)dataNoEncriptada{
    
    const char *plainTextString = [dataNoEncriptada UTF8String];
    
    //NSLog(@"** original plain text 0: %s", plainTextString);
    
    NSString *certPATH = [[NSBundle mainBundle] pathForResource:@"rsaCert" ofType:@"cer"];
    
    NSData* certData = [NSData dataWithContentsOfFile:certPATH];
    if( ![certData length] ) {
        puts( "ERROR: certData length was 0" ) ;
        return nil;
    }
    
    SecCertificateRef cert = SecCertificateCreateWithData( NULL, (__bridge CFDataRef)certData ) ;
    if( !cert )
    {
        puts( "ERROR: SecCertificateCreateWithData failed" ) ;
        return nil;
    }
    
    SecPolicyRef policy = SecPolicyCreateBasicX509();
    CFArrayRef certs = CFArrayCreate(kCFAllocatorDefault, (const void **) &cert, 1, NULL);
    SecTrustRef trust;
    SecTrustCreateWithCertificates(certs, policy, &trust);
    SecTrustResultType trustResult;
    SecTrustEvaluate(trust, &trustResult);
    SecKeyRef pub_key_leaf = SecTrustCopyPublicKey(trust);
    
    
    size_t BUFFER_SIZE = 1024;
    size_t CIPHER_BUFFER_SIZE = 1024;
    uint32_t PADDING = kSecPaddingPKCS1;
    
    uint8_t *plainBuffer;
    uint8_t *cipherBuffer;
    uint8_t *decryptedBuffer;
    
    
    
    int len = strlen(plainTextString);
    // TODO: this is a hack since i know inputString length will be less than BUFFER_SIZE
    if (len > BUFFER_SIZE) len = BUFFER_SIZE-1;
    
    plainBuffer = (uint8_t *)calloc(BUFFER_SIZE, sizeof(uint8_t));
    cipherBuffer = (uint8_t *)calloc(CIPHER_BUFFER_SIZE, sizeof(uint8_t));
    decryptedBuffer = (uint8_t *)calloc(BUFFER_SIZE, sizeof(uint8_t));
    
    strncpy( (char *)plainBuffer, plainTextString, len);
    
    
    //NSLog(@"== encryptWithPublicKey()");
    
    OSStatus status = noErr;
    
    //NSLog(@"** original plain text 0: %s", plainBuffer);
    
    size_t plainBufferSize = strlen((char *)plainBuffer);
    size_t cipherBufferSize = CIPHER_BUFFER_SIZE;
    
    
    //  Error handling
    // Encrypt using the public.
    status = SecKeyEncrypt(pub_key_leaf,
                           PADDING,
                           plainBuffer,
                           plainBufferSize,
                           &cipherBuffer[0],
                           &cipherBufferSize
                           );
    
    /*
     NSLog(@"encryption result code: %d (size: %d)", status, cipherBufferSize);
     NSLog(@"encrypted text: %s", cipherBuffer);*/
    
    
    NSData *encryptedData = [NSData dataWithBytes:cipherBuffer length:cipherBufferSize];
    

    NSString *base64String = [encryptedData base64EncodedStringWithOptions:0];
    NSLog(@"%@", base64String); // Zm9v

    return base64String;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
        NSLog(@"== encryptWithPublicKey()");
    
    
    //NSString *certPATH = [[NSBundle mainBundle] pathForResource:@"public" ofType:@"crt"];
    
    //NSLog(@"encrypted text: %s", &certPATH);
    

    //NSLog(@"== encryptWithPublicKey()");
    

   
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
