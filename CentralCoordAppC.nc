#include <Timer.h>
 #include "CentralCoord.h"
#include <printf.h>
 
 configuration CentralCoordAppC {
 }
 implementation {
   components MainC;
   components LedsC;
   components CentralCoordC as App;
   components new TimerMilliC() as Timer0;
   components ActiveMessageC;
   components new AMSenderC(AM_CENTRALCOORD);
   components new AMReceiverC(AM_CENTRALCOORD); 	
   components SerialPrintfC,SerialStartC;

   App.Boot -> MainC;
   App.Leds -> LedsC;
   App.Timer0 -> Timer0;
   App.Packet -> AMSenderC;
   App.AMPacket -> AMSenderC;
   App.AMSend -> AMSenderC;
   App.AMControl -> ActiveMessageC;
   App.Receive -> AMReceiverC;
 }
