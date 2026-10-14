"""Parse a user-supplied list of port numbers; performs no network activity."""
def parse_ports(value: str) -> list[int]:
    if not value.strip():
        raise ValueError("provide at least one port")
    ports = []
    for token in value.split(","):
        token = token.strip()
        if not token.isdigit():
            raise ValueError(f"not an integer port: {token!r}")
        port = int(token)
        if not 1 <= port <= 65535:
            raise ValueError(f"port outside 1..65535: {port}")
        ports.append(port)
    return sorted(set(ports))


if __name__ == "__main__":
    raw = input("Ports separated by commas (e.g. 22, 80, 443): ")
    print(parse_ports(raw))
