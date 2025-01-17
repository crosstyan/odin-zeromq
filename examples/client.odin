package examples

import "core:fmt"
import "core:strings"

import zeromq "../"

main :: proc() {
	using zeromq

	ctx := ctx_new()

	subscriber := socket(ctx, SUB)
	rc := connect(subscriber, "tcp://localhost:5556")
	assert(rc == 0)

	rc = setsockopt_string(subscriber, SUBSCRIBE, "10001 ")
	assert(rc == 0)

	for i in 0 .. 15 {
		str := recv_msg_string_copy(subscriber)
		defer delete(str)
		fmt.println("zipcode and temps:", str)
	}

	close(subscriber)
	ctx_term(ctx)
}
