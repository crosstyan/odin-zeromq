package zeromq

when ODIN_OS == .Windows {
	foreign import zeromq "libzmq.lib"
} else when ODIN_OS == .Darwin || ODIN_OS == .Linux {
	foreign import zeromq "system:zmq"
}

import "core:c"
import "core:mem"
import "core:strings"

@(link_prefix = "zmq_", default_calling_convention = "c")
foreign zeromq {
	errno :: proc() -> i32 ---
	strerror :: proc(errnum: i32) -> ^u8 ---
	version :: proc(major, minor, patch: ^i32) ---

	ctx_new :: proc() -> ^Context ---
	ctx_term :: proc(ctx: ^Context) -> i32 ---
	ctx_shutdown :: proc(ctx: ^Context) -> i32 ---
	ctx_set :: proc(ctx: ^Context, option, optval: i32) -> i32 ---
	ctx_get :: proc(ctx: ^Context, option: i32) -> i32 ---

	msg_init :: proc(msg: ^Message) -> i32 ---
	msg_init_size :: proc(msg: ^Message, size: uint) -> i32 ---
	msg_init_data :: proc(msg: ^Message, data: rawptr, size: uint, ffn: Free_Proc, hint: rawptr) -> i32 ---
	msg_send :: proc(msg: ^Message, s: rawptr, flags: i32) -> i32 ---
	msg_recv :: proc(msg: ^Message, s: rawptr, flags: i32) -> i32 ---
	msg_close :: proc(msg: ^Message) -> i32 ---
	msg_move :: proc(dest: ^Message, src: ^Message) -> i32 ---
	msg_copy :: proc(dest: ^Message, src: ^Message) -> i32 ---
	msg_data :: proc(msg: ^Message) -> rawptr ---
	msg_size :: proc(msg: ^Message) -> uint ---
	msg_more :: proc(msg: ^Message) -> i32 ---
	msg_get :: proc(msg: ^Message, property: i32) -> i32 ---
	msg_set :: proc(msg: ^Message, property, optval: i32) -> i32 ---
	msg_gets :: proc(msg: ^Message, property: ^u8) -> ^u8 ---
	msg_set_routing_id :: proc(msg: ^Message, routing_id: u32) -> i32 ---
	msg_routing_id :: proc(msg: ^Message) -> u32 ---
	msg_set_routing_group :: proc(msg: ^Message, group: ^u8) -> i32 ---
	msg_routing_group :: proc(msg: ^Message) -> ^u8 ---

	socket :: proc(s: ^Context, kind: i32) -> ^Socket ---
	close :: proc(s: ^Socket) -> i32 ---
	setsockopt :: proc(s: ^Socket, option: i32, optval: rawptr, optvallen: uint) -> i32 ---
	getsockopt :: proc(s: ^Socket, option: i32, optval: rawptr, optvallen: ^uint) -> i32 ---
	bind :: proc(s: ^Socket, addr: cstring) -> i32 ---
	connect :: proc(s: ^Socket, addr: cstring) -> i32 ---
	unbind :: proc(s: ^Socket, addr: cstring) -> i32 ---
	disconnect :: proc(s: ^Socket, addr: cstring) -> i32 ---
	send :: proc(s: ^Socket, buf: rawptr, len: uint, flags: i32) -> i32 ---
	send_const :: proc(s: ^Socket, buf: rawptr, len: uint, flags: i32) -> i32 ---
	recv :: proc(s: ^Socket, buf: rawptr, len: uint, flags: i32) -> i32 ---
	socket_monitor :: proc(s: ^Socket, addr: cstring, events: i32) -> i32 ---

	proxy :: proc(frontend, backend, capture: rawptr) -> i32 ---
	proxy_steerable :: proc(frontend, backend, capture, control: rawptr) -> i32 ---

	has :: proc(capability: ^u8) -> i32 ---

	z85_encode :: proc(dest: ^u8, data: ^u8, size: uint) -> ^u8 ---
	z85_decode :: proc(dest: ^u8, str: ^u8) -> ^u8 ---
	curve_keypair :: proc(z85_public_key, z85_secret_key: ^u8) -> i32 ---
	curve_public :: proc(z85_public_key, z85_secret_key: ^u8) -> i32 ---

	atomic_counter_new :: proc() -> ^Atomic_Counter ---
	atomic_counter_set :: proc(counter: ^Atomic_Counter, value: i32) ---
	atomic_counter_inc :: proc(counter: ^Atomic_Counter) -> i32 ---
	atomic_counter_dec :: proc(counter: ^Atomic_Counter) -> i32 ---
	atomic_counter_value :: proc(counter: ^Atomic_Counter) -> i32 ---
	atomic_counter_destroy :: proc(counter: ^^Atomic_Counter) ---

	poller_new :: proc() -> ^Poller ---
	poller_destroy :: proc(p: ^^Poller) -> i32 ---
	poller_add :: proc(p: ^Poller, socket, user_data: rawptr, events: u16) -> i32 ---
	poller_modify :: proc(p: ^Poller, socket: rawptr, events: u16) -> i32 ---
	poller_remove :: proc(p: ^Poller, socket: rawptr) -> i32 ---
	poller_wait :: proc(p: ^Poller, pe: ^Poller_Event, timeout: c.long) -> i32 ---
	poller_wait_all :: proc(p: ^Poller, pe: ^Poller_Event, n_events: i32, timeout: c.long) -> i32 ---
	poller_add_fd :: proc(p: ^Poller, fd: i32, user_data: rawptr, events: u16) -> i32 ---
	poller_modify_fd :: proc(p: ^Poller, fd: i32, events: u16) -> i32 ---
	poller_remove_fd :: proc(p: ^Poller, fd: i32) -> i32 ---
	socket_get_peer_state :: proc(socket: rawptr, routing_id: rawptr, routing_id_size: uint) -> i32 ---
	pool :: proc(items: ^[]Poll_Item, nitems: i32, timeout: c.long) -> i32 ---

	stopwatch_start :: proc() -> rawptr ---
	stopwatch_stop :: proc(watch: rawptr) -> uint ---
	sleep :: proc(seconds: i32) ---
	threadstart :: proc(func: Thread_Proc, arg: rawptr) -> rawptr ---
	threadclose :: proc(thread: rawptr) ---

	join :: proc(s: ^Socket, group: ^u8) -> i32 ---
	leave :: proc(s: ^Socket, group: ^u8) -> i32 ---

	timers_new :: proc() -> ^Timer ---
	timers_destroy :: proc(timers_p: ^^Timer) -> i32 ---
	timers_add :: proc(timers: ^Timer, interval: uint, handler: Timer_Proc, arg: rawptr) -> i32 ---
	timers_cancel :: proc(timers: ^Timer, timer_id: i32) -> i32 ---
	timers_set_interval :: proc(timers: ^Timer, timer_id: i32, i32erval: uint) -> i32 ---
	timers_reset :: proc(timers: ^Timer, timer_id: i32) -> i32 ---
	timers_timeout :: proc(timers: ^Timer) -> c.long ---
	timers_execute :: proc(timers: ^Timer) -> i32 ---
}

setsockopt_int :: proc(s: ^Socket, option: i32, optval: i32) -> i32 {
	local_val := optval
	return setsockopt(s, option, &local_val, 4)
}

setsockopt_bool :: proc(s: ^Socket, option: i32, optval: bool) -> i32 {
	local_val := cast(i32)optval
	return setsockopt(s, option, &local_val, 4)
}

setsockopt_string :: proc(s: ^Socket, option: i32, optval: string) -> i32 {
	return setsockopt(s, option, raw_data(optval), cast(uint)len(optval))
}

setsockopt_bytes :: proc(s: ^Socket, option: i32, optval: []u8) -> i32 {
	return setsockopt(s, option, raw_data(optval), cast(uint)len(optval))
}

// receive a message via a socket and return it as a string
// use the context allocator to allocate the string, so the caller is responsible for freeing it.
recv_msg_string_copy :: proc(s: ^Socket) -> (string, bool) {
	msg := Message{}
	rc := msg_init(&msg)
	assert(rc == 0, "Failed to initialize message")
	size := msg_recv(&msg, s, 0)
	if size == -1 do return "", false
	str := make([]u8, size + 1)
	mem.copy(&str[0], msg_data(&msg), cast(int)size)
	msg_close(&msg)
	str[size] = 0
	ret := strings.string_from_ptr(mem.raw_data(str), len(str))
	return ret, true
}

// initialize a message and receive it via a socket, casting the raw data to a
// byte slice. the caller should close the message after use
recv_msg_bytes :: proc(msg: ^Message, s: ^Socket) -> ([]u8, bool) {
	rc := msg_init(msg)
	assert(rc == 0, "Failed to initialize message")
	size := msg_recv(msg, s, 0)
	if size == -1 do return nil, false
	raw := cast([^]u8)msg_data(msg)
	return raw[:size], true
}

send_string :: proc(s: ^Socket, str: string) -> i32 {
	msg := Message{}
	msg_init_size(&msg, cast(uint)len(str))
	mem.copy(msg_data(&msg), raw_data(str), len(str))
	size := msg_send(&msg, s, 0)
	msg_close(&msg)
	return size
}

send_empty :: proc(s: ^Socket) -> i32 {
	msg := Message{}
	msg_init(&msg)
	size := msg_send(&msg, s, 0)
	msg_close(&msg)
	return size
}

send_more :: proc(s: ^Socket, str: string) -> i32 {
	msg := Message{}
	msg_init_size(&msg, cast(uint)len(str))
	mem.copy(msg_data(&msg), raw_data(str), len(str))
	size := msg_send(&msg, s, SNDMORE)
	msg_close(&msg)
	return size
}

Context :: struct {}
Socket :: struct {}
Atomic_Counter :: struct {}
Poller :: struct {}
Timer :: struct {}

// see `zmq_msg_t` in `zmq.h`
// https://github.com/zeromq/libzmq/blob/34f7fa22022bed9e0e390ed3580a1c83ac4a2834/include/zmq.h#L214-L232
Message :: struct {
	data: [64]u8,
}

Poller_Event :: struct {
	socket:    rawptr,
	fd:        i32, // TODO(zaklaus): Double check this!
	user_data: rawptr,
	events:    u16,
}

Poll_Item :: struct {
	socket:  rawptr,
	fd:      i32, // TODO(zaklaus): Double check this!
	events:  u16,
	revents: u16,
}

// Context options
IO_THREADS :: 1
MAX_SOCKETS :: 2
THREAD_PRIORITY :: 3
THREAD_SCHED_PRIORITY :: 4
MAX_MSGSZ :: 5
MSG_T_SIZE :: 6
THREAD_AFFINITY_CPU_ADD :: 7
THREAD_AFFINITY_CPU_REMOVE :: 8
THREAD_NAME_PREFIX :: 9

// Context defaults
IO_THREADS_DFLT :: 1
MAX_SOCKETS_DFLT :: 1023
THREAD_PRIORITY_DLFT :: -1
THREAD_SCHED_POLICY_DFLT :: -1

// Socket types
// https://libzmq.readthedocs.io/en/zeromq3-x/zmq_socket.html
PAIR :: 0
PUB :: 1
SUB :: 2
REQ :: 3
REP :: 4
DEALER :: 5
ROUTER :: 6
PULL :: 7
PUSH :: 8
XPUB :: 9
XSUB :: 10
STREAM :: 11
SERVER :: 12
CLIENT :: 13
RADIO :: 14
DISH :: 15
GATHER :: 16
SCATTER :: 17
DGRAM :: 18
XREQ :: DEALER
XREP :: ROUTER

// Socket options
AFFINITY :: 4
ROUTING_ID :: 5
SUBSCRIBE :: 6
UNSUBSCRIBE :: 7
RATE :: 8
RECOVERY_IVL :: 9
SNDBUF :: 11
RCVBUF :: 12
RCVMORE :: 13
FD :: 14
EVENTS :: 15
TYPE :: 16
LINGER :: 17
RECONNECT_IVL :: 18
BACKLOG :: 19
RECONNECT_IVL_MAX :: 21
MAXMSGSIZE :: 22
SNDHWM :: 23
RCVHWM :: 24
MULTICAST_HOPS :: 25
RCVTIMEO :: 27
SNDTIMEO :: 28
LAST_ENDPOINT :: 32
ROUTER_MANDATORY :: 33
TCP_KEEPALIVE :: 34
TCP_KEEPALIVE_CNT :: 35
TCP_KEEPALIVE_IDLE :: 36
TCP_KEEPALIVE_INTVL :: 37
IMMEDIATE :: 39
XPUB_VERBOSE :: 40
ROUTER_RAW :: 41
IPV6 :: 42
MECHANISM :: 43
PLAIN_SERVER :: 44
PLAIN_USERNAME :: 45
PLAIN_PASSWORD :: 46
CURVE_SERVER :: 47
CURVE_PUBLICKEY :: 48
CURVE_SECRETKEY :: 49
CURVE_SERVERKEY :: 50
PROBE_ROUTER :: 51
REQ_CORRELATE :: 52
REQ_RELAXED :: 53
CONFLATE :: 54
ZAP_DOMAIN :: 55
ROUTER_HANDOVER :: 56
TOS :: 57
CONNECT_ROUTING_ID :: 61
GSSAPI_SERVER :: 62
GSSAPI_PRINCIPAL :: 63
GSSAPI_SERVICE_PRINCIPAL :: 64
GSSAPI_PLAINTEXT :: 65
HANDSHAKE_IVL :: 66
SOCKS_PROXY :: 68
XPUB_NODROP :: 69
BLOCKY :: 70
XPUB_MANUAL :: 71
XPUB_WELCOME_MSG :: 72
STREAM_NOTIFY :: 73
INVERT_MATCHING :: 74
HEARTBEAT_IVL :: 75
HEARTBEAT_TTL :: 76
HEARTBEAT_TIMEOUT :: 77
XPUB_VERBOSER :: 78
CONNECT_TIMEOUT :: 79
TCP_MAXRT :: 80
THREAD_SAFE :: 81
MULTICAST_MAXTPDU :: 84
VMCI_BUFFER_SIZE :: 85
VMCI_BUFFER_MIN_SIZE :: 86
VMCI_BUFFER_MAX_SIZE :: 87
VMCI_CONNECT_TIMEOUT :: 88
USE_FD :: 89
GSSAPI_PRINCIPAL_NAMETYPE :: 90
GSSAPI_SERVICE_PRINCIPAL_NAMETYPE :: 91
BINDTODEVICE :: 92
ZAP_ENFORCE_DOMAIN :: 93


// Message property names
MSG_PROPERTY_ROUTING_ID :: "Routing-Id"
MSG_PROPERTY_SOCKET_TYPE :: "Socket-Type"
MSG_PROPERTY_USER_ID :: "User-Id"
MSG_PROPERTY_PEER_ADDRESS :: "Peer-Address"

// Message options
MORE :: 1
SHARED :: 3

// Send/Recv options
DONTWAIT :: 1
SNDMORE :: 2

// Security mechanisms
NULL :: 0
PLAIN :: 1
CURVE :: 2
GSSAPI :: 3

// RADIO-DISH protocol
GROUP_MAX_LENGTH :: 15

// Deprecated options and aliases
IDENTITY :: ROUTING_ID
CONNECT_RID :: CONNECT_ROUTING_ID
TCP_ACCEPT_FILTER :: 38
IPC_FILTER_PID :: 58
IPC_FILTER_UID :: 59
IPC_FILTER_GID :: 60
IPV4ONLY :: 31
DELAY_ATTACH_ON_CONNECT :: IMMEDIATE
NOBLOCK :: DONTWAIT
FAIL_UNROUTABLE :: ROUTER_MANDATORY
ROUTER_BEHAVIOR :: ROUTER_MANDATORY

// Deprecated Message options
SRCFD :: 2

// Deprecated aliases
STREAMER :: 1
FORWARDER :: 2
QUEUE :: 3

// Socket transport events (TCP, IPC and TIPC only)
EVENT_CONNECTED :: 0x0001
EVENT_CONNECT_DELAYED :: 0x0002
EVENT_CONNECT_RETRIED :: 0x0004
EVENT_LISTENING :: 0x0008
EVENT_BIND_FAILED :: 0x0010
EVENT_ACCEPTED :: 0x0020
EVENT_ACCEPT_FAILED :: 0x0040
EVENT_CLOSED :: 0x0080
EVENT_CLOSE_FAILED :: 0x0100
EVENT_DISCONNECTED :: 0x0200
EVENT_MONITOR_STOPPED :: 0x0400
EVENT_ALL :: 0xFFFF

// DRAFT 0MQ socket events and monitoring
// Unspecified system errors during handshake. Event value is an errno.
EVENT_HANDSHAKE_FAILED_NO_DETAIL :: 0x0800
// Handshake complete successfully with successful authentication (if enabled).
// Event value is unused.
EVENT_HANDSHAKE_SUCCEEDED :: 0x1000
// Protocol errors between ZMTP peers or between server and ZAP handler.
// Event value is one of ZMQ_PROTOCOL_ERROR_*
EVENT_HANDSHAKE_FAILED_PROTOCOL :: 0x2000
// Failed authentication requests. Event value is the numeric ZAP status
// code, i.e. 300, 400 or 500.
EVENT_HANDSHAKE_FAILED_AUTH :: 0x4000
PROTOCOL_ERROR_ZMTP_UNSPECIFIED :: 0x10000000
PROTOCOL_ERROR_ZMTP_UNEXPECTED_COMMAND :: 0x10000001
PROTOCOL_ERROR_ZMTP_INVALID_SEQUENCE :: 0x10000002
PROTOCOL_ERROR_ZMTP_KEY_EXCHANGE :: 0x10000003
PROTOCOL_ERROR_ZMTP_MALFORMED_COMMAND_UNSPECIFIED :: 0x10000011
PROTOCOL_ERROR_ZMTP_MALFORMED_COMMAND_MESSAGE :: 0x10000012
PROTOCOL_ERROR_ZMTP_MALFORMED_COMMAND_HELLO :: 0x10000013
PROTOCOL_ERROR_ZMTP_MALFORMED_COMMAND_INITIATE :: 0x10000014
PROTOCOL_ERROR_ZMTP_MALFORMED_COMMAND_ERROR :: 0x10000015
PROTOCOL_ERROR_ZMTP_MALFORMED_COMMAND_READY :: 0x10000016
PROTOCOL_ERROR_ZMTP_MALFORMED_COMMAND_WELCOME :: 0x10000017
PROTOCOL_ERROR_ZMTP_INVALID_METADATA :: 0x10000018

// the following two may be due to erroneous configuration of a peer
PROTOCOL_ERROR_ZMTP_CRYPTOGRAPHIC :: 0x11000001
PROTOCOL_ERROR_ZMTP_MECHANISM_MISMATCH :: 0x11000002

PROTOCOL_ERROR_ZAP_UNSPECIFIED :: 0x20000000
PROTOCOL_ERROR_ZAP_MALFORMED_REPLY :: 0x20000001
PROTOCOL_ERROR_ZAP_BAD_REQUEST_ID :: 0x20000002
PROTOCOL_ERROR_ZAP_BAD_VERSION :: 0x20000003
PROTOCOL_ERROR_ZAP_INVALID_STATUS_CODE :: 0x20000004
PROTOCOL_ERROR_ZAP_INVALID_METADATA :: 0x20000005

// GSSAPI principal name types
GSSAPI_NT_HOSTBASED :: 0
GSSAPI_NT_USER_NAME :: 1
GSSAPI_NT_KRB5_PRINCIPAL :: 2

// I/O multiplexing
POLLIN :: 1
POLLOUT :: 2
POLLERR :: 4
POLLPRI :: 8

Free_Proc :: #type proc "c" (data, hint: rawptr)
Thread_Proc :: #type proc "c" (ptr: rawptr)
Timer_Proc :: #type proc "c" (timer_id: i32, arg: rawptr)
