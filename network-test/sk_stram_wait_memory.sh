#!/usr/bin/stap
# Simple probe to detect when a process is waiting for more socket send
# buffer memory. Usually means the process is doing writes larger than the
# socket send buffer size or there is a slow receiver at the other side.
# Increasing the socket's send buffer size might help decrease application
# latencies, but it might also make it worse, so buyer beware.

# Typical output: timestamp in microseconds: procname(pid) event
#
# 1218230114875167: python(17631) blocked on full send buffer
# 1218230114876196: python(17631) recovered from full send buffer
# 1218230114876271: python(17631) blocked on full send buffer
# 1218230114876479: python(17631) recovered from full send buffer
probe kernel.function("sk_stream_wait_memory")
{
    printf("%u: %s(%d) blocked on full send buffern",
        gettimeofday_us(), execname(), pid())
}

probe kernel.function("sk_stream_wait_memory").return
{
    printf("%u: %s(%d) recovered from full send buffern",
        gettimeofday_us(), execname(), pid())
}
