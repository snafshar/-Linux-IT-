# TCP, UDP, and Ports

- **TCP** provides a connection-oriented byte stream with sequencing and retransmission.
- **UDP** sends datagrams without TCP's connection and delivery guarantees.
- A **port** identifies an application endpoint within the transport protocol.
- A listening socket is local state; it does not prove that a firewall or network path allows remote access.

## Inspect local state

```bash
ss -lnt
ss -lnu
ss -nt state established
```

## Exercises

1. List TCP listening sockets and identify the owning process when permissions allow.
2. Explain why a service listening on `127.0.0.1` behaves differently from one listening on `0.0.0.0`.
3. Explain why UDP does not establish a TCP-style connection.
4. Document the difference between a local listener and a remotely reachable service.

Only test services and systems you are authorized to inspect.
