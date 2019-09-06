#include <Timer.h>
#include "RCbroadcast.h"
#include "CentralCoord.h"
#include "mobiledata.h"
#include <printf.h>
 
 configuration RCbroadcastAppC {
 }
 implementation {
   components MainC;
   components LedsC;
   components RCbroadcastC as App;
   components new TimerMilliC() as Timer0;
   components new TimerMilliC() as Timer1;
//
   components ActiveMessageC;
   components new AMSenderC(AM_BROADCASTRC); 	
   components SerialPrintfC,SerialStartC;

   App.Boot -> MainC;
   App.Leds -> LedsC;
   App.Timer0 -> Timer0;
   App.Packet -> AMSenderC;
   App.AMPacket -> AMSenderC;
   App.AMSend -> AMSenderC;
   App.AMControl -> ActiveMessageC;
 }
