#ifndef RCBROADCAST_H
 #define RCBROADCAST_H
 
 enum {
   AM_BROADCASTRC = 6,
   TIMER_PERIOD_MILLI = 10
 };
 
typedef nx_struct BroadcastMsg {	//Broadcast message structure
  nx_uint16_t nodeid;
 -> nx_uint16_t broadcasttable;		// how do you broadcast a table message?
  nx_uint16_t data;
  nx_uint16_t counter;
} BroadcastMsg;

typedef nx_struct RCtoCCMsg {	//RC to CC message structure
  nx_uint16_t nodeid;
  nx_uint16_t data;
  nx_uint16_t counter;
} RCtoCCMsg;


 #endif
