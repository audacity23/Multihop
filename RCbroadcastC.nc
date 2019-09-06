// Source node
#include <Timer.h>
#include "RCbroadcast.h"
#include "CentralCoord.h"
#include "mobiledata.h"
#include "printf.h"
														//different frequencies pe msg ko sunna hai...
 
 module RCbroadcastC {
  uses interface Boot;
  uses interface Leds;
  uses interface Timer<TMilli> as Timer0;
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend;
  uses interface SplitControl as AMControl;
}
 
 implementation {

  bool busy = FALSE;
  message_t pkt;
  int count=0;
  
	uint8_t counter;

   event void Boot.booted() {
	call AMControl.start();
	}

   event void AMControl.startDone(error_t err) {
	if (err == SUCCESS) {
     	call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
     	//call Timer0.start
	}
	else {
	call AMControl.start();
	}
}

	event void AMControl.stopDone(error_t err) {
	}

->	event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
		if (len == sizeof(BroadcastMsg)) {
			BroadcastMsg* newpkt = (BroadcastMsg*)payload;
			temp = newpkt->nodeid;
			if (temp == 1){
				counter = newpkt->counter;		
				call Leds.set(newpkt->counter);
				printf("data number : %u \t received from node 1\n",counter);
				}
			}
		return msg;
	}
    	event void Timer0.fired() {
		counter++;	
		if (!busy) {
			BroadcastMsg* newpkt = (BroadcastMsg*)(call Packet.getPayload(&pkt, sizeof(BroacastMsg)));
			//newpkt->data = 1;
			//printf(newpkt->data);
			//printf("sending to node 2 ");
			newpkt->nodeid = TOS_NODE_ID;
			newpkt->counter = data;			//kya data(broadcast table) bhejna hai?
			if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(BroadcastMsg)) == SUCCESS) {
				busy = TRUE;
				}
		}
	}

	// event void sendDone(message_t* msg, error_t error) {
	// }

	event void AMSend.sendDone(message_t* msg, error_t error) {
		if (&pkt == msg) {
		  busy = FALSE;
		}
	}
}
 
