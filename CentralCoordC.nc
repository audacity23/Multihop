#include <Timer.h>
#include "CentralCoord.h"
#include "RCbroadcast.h"
#include "printf.h"
 
 module CentralCoordC {
   uses interface Boot;
   uses interface Leds;
   uses interface Timer<TMilli> as Timer0;
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend;
  uses interface SplitControl as AMControl;
  uses interface Receive;
}
 
 implementation {

 message_t pkt;
 uint16_t temp;
 uint8_t counter;
 uint16_t data;
 error_t lol;		//new

   event void Boot.booted() {
	call AMControl.start();
	}

    event void AMControl.startDone(error_t err) {
	if (err == SUCCESS) {
        call Timer0.startOneShot(TIMER_PERIOD_MILLI);			//new
   	}
	else {
	call AMControl.start();
	}
}

	event void AMControl.stopDone(error_t err) {
	}

    	event void Timer0.fired() {						//new
	call CC2420Config.setChannel(12);			//channel
			lol = call CC2420Config.sync();				//channel
			while(lol != SUCCESS)					//channel
			{
			lol = call CC2420Config.sync();
			}
	BroadcastbyCC* newpkt = (BroadcastbyCC*)(call Packet.getPayload(&pkt, sizeof(BroadcastbyCC)));
	newpkt->CCid = TOS_NODE_ID;
	newpkt->duplicateCCid ->TOS_NODE_ID;
	newpkt->x = 0;
	newpkt->y = 0;
	if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(BroadcastbyCC)) == SUCCESS) {
				busy = TRUE;
			}
	}

	event void AMSend.sendDone(message_t* msg, error_t error) {			//new
	if (&pkt == msg) {
		  busy = FALSE;
		}
	}
	event Syncdone(error_t error)				//new
	{
	}

	event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
		if (len == sizeof(CentralCoordMsg)) {
			CentralCoordMsg* newpkt = (CentralCoordMsg*)payload;	
			//temp = newpkt->data;
			//temp++;
			//printf("Done");
			temp = newpkt->nodeid;

			if (temp == 1 || temp==2 || temp==3 || temp==4 || temp==5 || temp==6){			//only if it belongs to a Room coordi	
				counter = newpkt->counter;
				data = newpkt->data;			//data kya receive hoga?		
				call Leds.set(newpkt->counter);
				printf("node number : %u \t",nodeid);
				}
			}
		return msg;
		}
 }
 
