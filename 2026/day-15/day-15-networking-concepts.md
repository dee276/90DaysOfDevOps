# Day 15 - Networking Concepts: DNS, IP, Subnets and Ports

## Environment

- Machine: Windows workstation
- Main interface: Wi-Fi
- IPv4 address: `192.168.1.68`
- Subnet mask: `255.255.255.0`
- Default gateway: `192.168.1.254`

Linux commands from the task were adapted to Windows equivalents:

- `dig google.com` -> `Resolve-DnsName google.com -Type A`
- `ip addr show` -> `ipconfig`
- `ss -tulpn` -> `netstat -ano`

## Task 1: DNS - How Names Become IPs

When I type `google.com` in a browser, the browser first needs an IP address for that name. It checks cache, then asks a DNS resolver. The resolver finds the authoritative DNS records and returns one or more IP addresses. After that, the browser can open a TCP connection and send an HTTP/HTTPS request.

### DNS Record Types

- `A`: maps a domain name to an IPv4 address.
- `AAAA`: maps a domain name to an IPv6 address.
- `CNAME`: creates an alias from one domain name to another.
- `MX`: tells mail servers where to deliver email for a domain.
- `NS`: lists the authoritative name servers for a domain.

### DNS Command Output

Command:

```powershell
Resolve-DnsName google.com -Type A
```

Observed A records:

```text
google.com A TTL 39 192.178.192.139
google.com A TTL 39 192.178.192.100
google.com A TTL 39 192.178.192.101
google.com A TTL 39 192.178.192.113
google.com A TTL 39 192.178.192.102
google.com A TTL 39 192.178.192.138
```

TTL observed: `39` seconds.

Other examples:

```text
google.com AAAA TTL 71 2607:f8b0:4023:1807::71
google.com MX   TTL 300 smtp.google.com
google.com NS   TTL 8395 ns1.google.com, ns2.google.com, ns3.google.com, ns4.google.com
```

## Task 2: IP Addressing

An IPv4 address is a 32-bit address written as four decimal numbers separated by dots, for example:

```text
192.168.1.10
```

Each number is an octet from `0` to `255`.

### Public vs Private IPs

- Public IP: routable on the internet, for example `8.8.8.8`.
- Private IP: used inside local networks, for example `192.168.1.68`.

### Private IP Ranges

- `10.0.0.0/8`
- `172.16.0.0/12` through `172.31.255.255`
- `192.168.0.0/16`

### Local IP Check

Command:

```powershell
ipconfig
```

Observed:

```text
IPv4 Address: 192.168.1.68
Subnet Mask: 255.255.255.0
Default Gateway: 192.168.1.254
```

`192.168.1.68` is private because it is inside the `192.168.0.0/16` range.

## Task 3: CIDR and Subnetting

`/24` in `192.168.1.0/24` means the first 24 bits are the network portion. The remaining 8 bits are available for host addresses.

We subnet to split larger networks into smaller, more manageable sections. This helps with organization, routing, security boundaries, and reducing unnecessary broadcast traffic.

| CIDR | Subnet Mask | Total IPs | Usable Hosts |
|------|-------------|-----------|--------------|
| /24  | 255.255.255.0 | 256 | 254 |
| /16  | 255.255.0.0 | 65,536 | 65,534 |
| /28  | 255.255.255.240 | 16 | 14 |

Note: usable hosts usually subtract 2 addresses: one for the network address and one for the broadcast address.

## Task 4: Ports - The Doors to Services

A port identifies a specific service on a host. The IP address gets traffic to the machine; the port gets traffic to the correct service or process on that machine.

| Port | Service |
|------|---------|
| 22   | SSH |
| 80   | HTTP |
| 443  | HTTPS |
| 53   | DNS |
| 3306 | MySQL |
| 6379 | Redis |
| 27017 | MongoDB |

### Listening Ports

Command:

```powershell
netstat -ano
```

Observed listening ports:

```text
TCP 0.0.0.0:5432  LISTENING  PID 2132
TCP 127.0.0.1:27017 LISTENING PID 7172
TCP 0.0.0.0:15672 LISTENING PID 8500
TCP 0.0.0.0:8080  LISTENING  PID 7052
```

Process mapping:

```text
PID 2132 -> postgres
PID 7172 -> mongod
PID 8500 -> erl
PID 7052 -> AgentService
```

At least two clear matches:

- `5432` -> PostgreSQL (`postgres`)
- `27017` -> MongoDB (`mongod`)

## Task 5: Putting It Together

### `curl http://myapp.com:8080`

This involves DNS, IP, TCP, a port, and HTTP. DNS resolves `myapp.com` to an IP address, TCP connects to port `8080`, and HTTP sends the request to the application listening on that port.

### App cannot reach database at `10.0.1.50:3306`

I would check whether `10.0.1.50` is reachable, whether port `3306` is open, and whether the database service is listening. I would also verify firewall/security-group rules, database bind address, credentials, and whether the app and database are in the same network or routable subnets.

Example checks:

```bash
ping 10.0.1.50
nc -zv 10.0.1.50 3306
ss -tulpn | grep 3306
```

Windows equivalents:

```powershell
ping 10.0.1.50
Test-NetConnection 10.0.1.50 -Port 3306
netstat -ano | findstr :3306
```

## What I Learned

- DNS converts human-friendly names into IP addresses, but different record types solve different problems.
- IP addresses identify machines or interfaces, while ports identify services on those machines.
- CIDR notation defines how much of an address belongs to the network and how much is available for hosts.
- During troubleshooting, I should separate DNS resolution, IP reachability, port connectivity, and application behavior.
