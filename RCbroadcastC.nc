// Source node
#include <Timer.h>
#include "RCbroadcast.h"
#include "CentralCoord.h"
#include "mobiledata.h"
#include "printf.h"
#include "ApplicationDefinitions.h"			//new
#include "RssiDemoMessages.h"				//new

 
 module RCbroadcastC {
  uses interface Boot;
  uses interface Leds;
  uses interface Timer<TMilli> as Timer0;
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend;
  uses interface SplitControl as AMControl;
  uses interface Intercept as RssiMsgIntercept;				//new
  
  #ifdef __CC2420_H__							//new
  uses interface CC2420Packet;
#elif defined(TDA5250_MESSAGE_H)
  uses interface Tda5250Packet;    
#else
  uses interface PacketField<uint8_t> as PacketRSSI;
#endif 
  
}
 
 implementation {

  bool busy = FALSE;
  message_t pkt;
  int count=0;
  uint16_t CCID;				//new
  uint16_t duplicateCC_id;			//new
  uint16_t getRssi(message_t *msg);		//new
	uint8_t counter;

   event void Boot.booted() {
	call AMControl.start();
	}

   event void AMControl.startDone(error_t err) {
	if (err == SUCCESS) {
     	//call Timer0.start
	}
	else {
	call AMControl.start();
	}
}

	event void AMControl.stopDone(error_t err) {
	}

->	event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
		if (len == sizeof(BroadcastbyCC)) {				//new
			BroadcastbyCC* newpkt = (BroadcastbyCC*)payload;
			CCID = newpkt->CCid;
			if(newpkt->duplicateCCid == CCID) 
			{						//new
			duplicateCC_id = newpkt->duplicateCCid;
			call Timer0.startOneShot(TOS_NODE_ID*10);
			}
			else if(newpkt->duplicateCCid < TOS_NODE_ID || )
			{
			duplicateCC_id = newpkt->duplicateCCid;
			call Timer0.startOneShot(TOS_NODE_ID*10);
			}
		return msg;
	}
    	event void Timer0.fired() {							//new
		if (!busy) {
			BroadcastbyCC* newpkt = (BroadcastbyCC*)(call Packet.getPayload(&pkt, sizeof(BroadcastbyCC)));
			newpkt->ccid = CCID;
			newpkt->duplicateCCid = TOS_NODE_ID;
			if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(BroadcastbyCC)) == SUCCESS) {
				busy = TRUE;
				}
		}
	}
	
	event bool RssiMsgIntercept.forward(message_t *msg,void *payload,uint8_t len) {
    RssiMsg *rssiMsg = (RssiMsg*) payload;
    rssiMsg->rssi = getRssi(msg);
    return TRUE;
  }
	

	// event void sendDone(message_t* msg, error_t error) {
	// }

	event void AMSend.sendDone(message_t* msg, error_t error) {				//new
		if (&pkt == msg) {
		  busy = FALSE;
		}
	}
}
 
