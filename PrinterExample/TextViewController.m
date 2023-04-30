//
//  TextViewController.m
//  PrinterExample
//
//  Created by King on 25/12/2017.
//  Copyright © 2017 Printer. All rights reserved.
//

#import "TextViewController.h"
#import "Printer.h"
#import "style.h"
#import "PrinterManager.h"
#import "LabelCommonSetting.h"
#import "ESCCmd.h"
#import "PinCmd.h"
#import "TSCCmd.h"
#import "ZPLCmd.h"

@interface TextViewController ()
{
  PrinterManager *_printerManager;
}
@end

@implementation TextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 /*
    _txtViewinput.layer.backgroundColor = [[UIColor clearColor] CGColor];
    
    _txtViewinput.layer.borderColor = [[UIColor colorWithRed:230.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0]CGColor];
    _txtViewinput.layer.borderWidth = 3.0;
    _txtViewinput.layer.cornerRadius = 8.0f;
    [_txtViewinput.layer setMasksToBounds:YES];
    */
    _printerManager = PrinterManager.sharedInstance;
    
    
    self.txtViewinput.layer.borderColor = FLAT_BLUE_COLOR.CGColor;
    self.txtViewinput.layer.borderWidth =1.0;
    self.txtViewinput.layer.cornerRadius =5.0;
    [self.txtViewinput.layer setMasksToBounds:YES];

   
   // UIColor *disabledcolor = UIColorFromHex(0x6B7A8D);
   self.btnPrint.disabledColor = UIColorFromHex(0x6B7A8D);
    self.btnCancelPrint.disabledColor = UIColorFromHex(0x6B7A8D);
   self.btnPrint.enabled = ([PrinterManager.sharedInstance.CurrentPrinter IsOpen]);
    self.btnCancelPrint.enabled = self.btnPrint.enabled;
    if (self.btnPrint.enabled)
    {
        self.btnPrint.alpha = 1;
        self.btnCancelPrint.alpha = 1;
    }
    else
    {
        self.btnPrint.alpha = 0.5;
        self.btnCancelPrint.alpha = 0.5;
    }
    if (_printerManager.CurrentPrinterCmdType==PrinterCmdZPL)
        [self.btnCancelPrint setHidden:false];
    else
         [self.btnCancelPrint setHidden:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)pinPrint{
    Printer * currentprinter = _printerManager.CurrentPrinter;
    if (currentprinter.IsOpen){
        NSString* inputStr = self.txtViewinput.text;
        NSLog(@"inputStr=%@",inputStr);
        TextSetting *textst = currentprinter.TextSets;
        [textst setAlignmode:Align_Left];
        [textst setIsTimes_Wide:Set_DisEnable];
        [textst setIsTimes_Heigh:Set_DisEnable];
        [textst setIsUnderline:Set_DisEnable];
        Cmd *cmd =  [_printerManager CreateCmdClass:_printerManager.CurrentPrinterCmdType];
        [cmd Clear];
        [cmd setEncodingType:Encoding_GBK];
        NSData *headercmd = [_printerManager GetHeaderCmd:cmd cmdtype:_printerManager.CurrentPrinterCmdType];//
        [cmd Append:headercmd];
      
    
        //
        //        NSArray * textArray = [inputStr componentsSeparatedByString:@"\n"];
        //        for(NSString * str in textArray ){
        //           NSData *data = [cmd GetTextCmd:currentprinter.TextSets text:str];
        //           textst.Y_start = textst.Y_start+30;
        //           [cmd Append:data];
        //           [cmd Append:cmd.GetLFCRCmd];
        //           data = nil;
        //        }
       // inputStr = @"_____________________________________________________________";
//        NSMutableString *stlist = [[NSMutableString alloc] init];
//        [stlist appendString:@"┌─────┬──────┬─────┬───────┬───────┬──────┬──────┐\r\n"];
//        [stlist appendString:@"├─────┼──────┼─────┼───────┼───────┼──────┼──────┤\r\n"];
//        [stlist appendString:@"├─────┼──────┼─────┼───────┼───────┼──────┼──────┤\r\n"];
//        [stlist appendString:@"└─────┴──────┴─────┴───────┴───────┴──────┴──────┘\r\n"];
//        inputStr = [NSString stringWithFormat:@"%@",stlist];
        NSData *data = [cmd GetTextCmd:currentprinter.TextSets text:inputStr];
        [cmd Append:data];

//
//        NSData *data0 = [(PinCmd*)cmd GetAbsolutePrintPositionCmd:5];
//        [cmd Append:data0];
//        NSData *data = [cmd GetTextCmd:currentprinter.TextSets text:@"中国人民000001"];
//        [cmd Append:data];
//        [cmd Append:[cmd GetLFCRCmd]];
//        [cmd Append:[(PinCmd*)cmd GetJumpingRow180thCmd:JumpMode_Forward n:100]];
//
//
//        [textst setIsTimes_Wide:Set_DisEnable];
//        [textst setIsTimes_Heigh:Set_DisEnable];
//       // data0 = [(PinCmd*)cmd GetAbsolutePrintPositionCmd:50];
//        [cmd Append:data0];
//        NSData *data2 = [cmd GetTextCmd:currentprinter.TextSets text:@"中国人民000002"];
//        [cmd Append:data2];
//        [cmd Append:[cmd GetLFCRCmd]];
//        [textst setIsTimes_Wide:Set_DisEnable];
//        [textst setIsTimes_Heigh:Set_DisEnable];
//       // data0 = [(PinCmd*)cmd GetAbsolutePrintPositionCmd:100];
//        [cmd Append:data0];
//        NSData *data3 = [cmd GetTextCmd:currentprinter.TextSets text:@"中国人民000003"];
//        [cmd Append:data3];
//
        [cmd Append:[cmd GetLFCRCmd]]; //一定要加回车换行，否则打印不了，Be sure to add a carriage return to the    line, otherwise it will not print.

      ////        [cmd Append:[(PinCmd*)cmd GetJumpingRow180thCmd:JumpMode_Forward n:1]];
//        NSString *sjump= @"I will jump row";
//        [cmd Append:[cmd ImportData:sjump]];
//        [cmd Append:[cmd GetLFCRCmd]];

        [cmd Append:[cmd GetPrintEndCmd]];
        
        if ([currentprinter IsOpen]){
            NSData *data=[cmd GetCmd];
            NSLog(@"data bytes=%@",data);
            [currentprinter Write:data];

        }

        
        
    }
    
    
}

-(void)EscPrint{
    Printer * currentprinter = _printerManager.CurrentPrinter;
    if (currentprinter.IsOpen){
    
        NSString* inputStr = self.txtViewinput.text;
        NSLog(@"inputStr=%@",inputStr);
        TextSetting *textst = currentprinter.TextSets;
        [textst setIsBold:Set_Enabled];
        [textst setIsItalic:Set_Enabled];
        [textst setIsTimes_Wide:Set_DisEnable];
        [textst setIsTimes_Heigh:Set_DisEnable];
        [textst setIsTimes4_Wide:Set_DisEnable];
        [textst setIsTimes_Wide:Set_Enabled];
        [textst setAlignmode:Align_Left];
        [textst setIsUnderline:Set_Enabled];
        [textst setRotate:Rotate0];//ESC: Rotate90,Rotate0 有效(valid)
        Cmd *cmd =  [_printerManager CreateCmdClass:_printerManager.CurrentPrinterCmdType];
        [cmd Clear];
        [cmd setEncodingType:Encoding_GBK];
        NSData *headercmd = [_printerManager GetHeaderCmd:cmd cmdtype:_printerManager.CurrentPrinterCmdType];//
        [cmd Append:headercmd];

        NSData *data = [cmd GetTextCmd:currentprinter.TextSets text:inputStr];
        [cmd Append:data];
        for (int i=0; i<2; i++) {
            [cmd Append:[cmd GetLFCRCmd]];
        }
       [cmd Append:[cmd GetPrintEndCmd]];
        //询问打印是否完成，打印完成，返回 “print Ok" 适用于 Rpp80Use 定制客户使用。
        
        //Inquire whether the printing is completed, printing is completed, return "print Ok" For Rpp80Use custom customer use.
//       [cmd Append:[cmd GetAskPrintOkCmd]];
        
        
        //        [cmd Append:[cmd GetCutPaperCmd:CutterMode_half]];
        //        [cmd Append:[cmd GetBeepCmd:3 interval:10]];
        //        [cmd Append:[cmd GetOpenDrawerCmd:0 startTime:5 endTime:0]];
        //
   
        if ([currentprinter IsOpen]){
            NSData *data=[cmd GetCmd];
            NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            aString = [aString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            [currentprinter Write:data];
        }
        
        
        
        
    }
}

-(void)TscPrint{
    Printer * currentprinter = _printerManager.CurrentPrinter;
    if (currentprinter.IsOpen){
        
        NSString* inputStr = self.txtViewinput.text;
        NSLog(@"inputStr=%@",inputStr);
        TextSetting *textst = currentprinter.TextSets;
        [textst setIsBold:Set_Enabled];//ESC, Rpp806-TSC
        [textst setX_start:10];// X coordinate of the upper left corner
        [textst setY_start:50];// coordinate of the upper left corner
        [textst setX_multi:1];//X 方向 1~10
        [textst setY_multi:1];//Y 方向 1~10
        [textst setTSCFonttype:TSCFontType_Font5];//TSC
        // [textst setTSCFonttype:TSCFontType_TSS24];//for Chinese
        [textst setRotate:Rotate0];
        
        
        Cmd *cmd =  [_printerManager CreateCmdClass:_printerManager.CurrentPrinterCmdType];
        [cmd Clear];
        [cmd setEncodingType:Encoding_GBK];
        NSData *headercmd = [_printerManager GetHeaderCmd:cmd cmdtype:_printerManager.CurrentPrinterCmdType];//
        [cmd Append:headercmd];
     
        
        //
        //        NSArray * textArray = [inputStr componentsSeparatedByString:@"\n"];
        //        for(NSString * str in textArray ){
        //           NSData *data = [cmd GetTextCmd:currentprinter.TextSets text:str];
        //           textst.Y_start = textst.Y_start+30;
        //           [cmd Append:data];
        //           [cmd Append:cmd.GetLFCRCmd];
        //           data = nil;
        //        }
        
        
        NSData *data = [cmd GetTextCmd:currentprinter.TextSets text:inputStr];
        [cmd Append:data];
        NSData *data1 = [(TSCCmd*) cmd GetReverseCmd:CoordMake(0, 40, 100,200)];
        [cmd Append:data1];

        
        for (int i=0; i<2; i++) {
            [cmd Append:[cmd GetLFCRCmd]];
        }
        
        [cmd Append:[cmd GetPrintEndCmd:1]];
        
        if ([currentprinter IsOpen]){
            NSData *data=[cmd GetCmd];
            NSLog(@"data bytes=%@",data);
            NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            aString = [aString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            NSLog(@"data string=%@",aString);
            [currentprinter Write:data];
            
        }
        
    }
}

-(void)ZplPrint{
    Printer * currentprinter = _printerManager.CurrentPrinter;
    if (currentprinter.IsOpen){
    }
}

- (IBAction)btnPrintText:(id)sender {
    switch (_printerManager.CurrentPrinterCmdType) {
        case PrinterCmdPIN:
           [self pinPrint];
            return;
        case PrinterCmdESC:
            [self EscPrint];
            return;
        case PrinterCmdTSC:
            [self TscPrint];
            return;
            
            
        default:
            break;
    }
    
    
    
    
   // PrinterManager *_printerManager = PrinterManager.sharedInstance;
    Printer * currentprinter = _printerManager.CurrentPrinter;
    if (currentprinter.IsOpen){
        
        NSString* inputStr = self.txtViewinput.text;
        NSLog(@"inputStr=%@",inputStr);
        TextSetting *textst = currentprinter.TextSets;
        [textst setIsBold:Set_Enabled];//ESC, Rpp806-TSC
        [textst setIsItalic:Set_Enabled];//ESC,Rpp806-TSC
        [textst setIsTimes_Wide:Set_DisEnable];//ESC,Pin
        [textst setIsTimes_Heigh:Set_DisEnable];//ESC,Pin
        [textst setIsTimes4_Wide:Set_DisEnable];//ESC,Pin
        [textst setIsTimes_Wide:Set_Enabled];//ESC,Pin
        [textst setAlignmode:Align_Left];//ESC
        [textst setIsUnderline:Set_Enabled];//ESC
        [textst setX_start:10];//TSC,Cpcl,zpl X coordinate of the upper left corner
        [textst setY_start:50];//TSC,Cpcl,zpl Y coordinate of the upper left corner
        [textst setX_multi:1];//TSC
        [textst setY_multi:1];//TSC
        [textst setTSCFonttype:TSCFontType_Font5];//TSC
       // [textst setTSCFonttype:TSCFontType_TSS24];//for Chinese
        [textst setZplFonttype:ZplFontType_Vector];//zpl
        [textst setZplHeihtFactor:30];//zpl
        [textst setZplWidthFactor:30];//zpl
        [textst setRotate:Rotate0];//ESC: Rotate90,Rotate0 有效(valid),  TSC,CPcl,zpl:(for valid)
       // [textst setIsInverse:Set_Enabled];//ESC
        
 
        Cmd *cmd =  [_printerManager CreateCmdClass:_printerManager.CurrentPrinterCmdType];
        [cmd Clear];
        [cmd setEncodingType:Encoding_GBK];
        NSData *headercmd = [_printerManager GetHeaderCmd:cmd cmdtype:_printerManager.CurrentPrinterCmdType];//
        [cmd Append:headercmd];
       
        if (_printerManager.CurrentPrinterCmdType==PrinterCmdPIN){
           //  [cmd Append:[(PinCmd*)cmd GetIsDualPrintCmd:true]];
            // Used for old printers（用于旧的打印机） ipageLen 1=<n<=127
          
        }
       
//
//        NSArray * textArray = [inputStr componentsSeparatedByString:@"\n"];
//        for(NSString * str in textArray ){
//           NSData *data = [cmd GetTextCmd:currentprinter.TextSets text:str];
//           textst.Y_start = textst.Y_start+30;
//           [cmd Append:data];
//           [cmd Append:cmd.GetLFCRCmd];
//           data = nil;
//        }
        NSData *data = [cmd GetTextCmd:currentprinter.TextSets text:inputStr];
        [cmd Append:data];
        for (int i=0; i<2; i++) {
          [cmd Append:[cmd GetLFCRCmd]];
        }
   
        
//        [cmd Append:[cmd GetCutPaperCmd:CutterMode_half]];//for ESC
//        [cmd Append:[cmd GetBeepCmd:3 interval:10]];
//        [cmd Append:[cmd GetOpenDrawerCmd:0 startTime:5 endTime:0]];
//
        
        [cmd Append:[cmd GetPrintEndCmd:1]];
        
        if ([currentprinter IsOpen]){
            NSData *data=[cmd GetCmd];
            NSLog(@"data bytes=%@",data);
            NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            aString = [aString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            NSLog(@"data string=%@",aString);
            [currentprinter Write:data];

        }
        
    }
    
}

//取消打印，用于Rpp410定制客户，签纸打印
//Cancel printing, for Rpp410 custom customers, paper printing
- (IBAction)btnCancelClick:(id)sender {
    if (_printerManager.CurrentPrinter.IsOpen){
        ZPLCmd *cmd =  [_printerManager CreateCmdClass:PrinterCmdZPL];
        if (cmd == NULL)
            return;
        [cmd Clear];
        [cmd Append:[cmd GetCancelPrintCmd]];
        if ([_printerManager.CurrentPrinter IsOpen]){
            [_printerManager.CurrentPrinter Write:[cmd GetCmd]];
        }
        
    }
}


@end
