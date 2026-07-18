# Day 14 - Networking Fundamentals and Hands-on Checks

## Environment

- Machine: Windows workstation
- Hostname: `DESKTOP-UHQ4JJF`
- Main interface: Wi-Fi
- IPv4 address: `192.168.1.68`
- Default gateway: `192.168.1.254`
- Target host for external checks: `example.com`

Linux commands from the README were adapted to Windows equivalents where needed:

- `hostname -I` / `ip addr show` -> `ipconfig`
- `traceroute` -> `tracert`
- `ss -tulpn` -> `netstat -an`
- `nc -zv` -> `Test-NetConnection`

## Quick Concepts

### OSI vs TCP/IP

- The OSI model has 7 layers: physical, data link, network, transport, session, presentation, and application.
- The TCP/IP model is simpler and maps practical networking into link, internet, transport, and application layers.

### Where Key Protocols Fit

- IP sits at the network/internet layer and handles addressing and routing.
- TCP and UDP sit at the transport layer and handle communication between ports.
- DNS sits at the application layer and resolves names like `example.com` to IP addresses.
- HTTP/HTTPS sit at the application layer and run over TCP.

Example:

```text
curl https://example.com = HTTP over TLS over TCP over IP
```

## Hands-on Checks

### 1. Identity

Command:

```powershell
hostname
ipconfig
```

Observed:

```text
Hostname: DESKTOP-UHQ4JJF
IPv4 Address: 192.168.1.68
Default Gateway: 192.168.1.254
```

My machine is on a private LAN subnet, and traffic leaves through the local gateway.

### 2. Reachability

Command:

```powershell
ping example.com -n 4
```

Observed:

```text
Pinging example.com [172.66.147.243] with 32 bytes of data:
Packets: Sent = 4, Received = 4, Lost = 0 (0% loss)
Minimum = 19ms, Maximum = 23ms, Average = 21ms
```

The target is reachable with low latency and no packet loss.

### 3. Path

Command:

```powershell
tracert -d example.com
```

Observed:

```text
1     3 ms     3 ms     3 ms  192.168.1.254
2    16 ms    15 ms    15 ms  24.231.102.241
3    14 ms    13 ms    16 ms  10.170.192.58
4    13 ms    14 ms     *     65.38.93.73
5     *        *        *     Request timed out.
6    14 ms    14 ms    14 ms  154.54.45.113
7    20 ms    24 ms    20 ms  154.54.41.205
8    35 ms    21 ms     *     38.88.240.186
9    29 ms    20 ms    21 ms  108.162.239.24
10   21 ms    22 ms    20 ms  172.66.147.243
```

The route reached the target in 10 hops. Some hops timed out, but the destination still responded, so those timeouts are not automatically a failure.

### 4. Ports

Command:

```powershell
netstat -an
```

Observed listening examples:

```text
TCP    0.0.0.0:5432    0.0.0.0:0    LISTENING
TCP    0.0.0.0:8080    0.0.0.0:0    LISTENING
TCP    0.0.0.0:15672   0.0.0.0:0    LISTENING
```

One useful local service to probe is port `8080`.

### 5. Name Resolution

Command:

```powershell
nslookup example.com
nslookup example.com 1.1.1.1
```

Observed:

```text
DNS request timed out.
Server: UnKnown
Address: 192.168.1.254
*** Request to UnKnown timed-out
```

The explicit `nslookup` checks timed out, both through the local gateway DNS and `1.1.1.1`. However, `ping example.com` still resolved to `172.66.147.243`, so name resolution may be working through a different resolver path, cache, or security policy.

### 6. HTTP Check

Command:

```powershell
curl.exe -I https://example.com
curl.exe -I http://example.com
```

Observed:

```text
curl: (7) Failed to connect to example.com port 443
curl: (7) Failed to connect to example.com port 80
```

ICMP reachability worked, but HTTP/HTTPS connection attempts failed. This points to a higher-layer or policy issue rather than basic IP reachability.

### 7. Connections Snapshot

Command:

```powershell
netstat -an
```

Observed rough counts:

```text
LISTENING=71
ESTABLISHED=85
```

There are many local listening ports and established connections, so filtering by port or process would be the next step during a real incident.

## Mini Task: Port Probe and Interpret

Listening port selected:

```text
localhost:8080
```

Command:

```powershell
Test-NetConnection localhost -Port 8080
```

Observed:

```text
ComputerName     : localhost
RemoteAddress    : ::1
RemotePort       : 8080
TcpTestSucceeded : True
```

Interpretation:

- Port `8080` is reachable locally.
- If this had failed, my next checks would be: identify the process listening on that port, verify the service status, and check firewall rules.

## Reflection

### Fastest signal when something is broken

`curl -I` gives the fastest application-level signal for web services because it tells me whether the service is reachable and which HTTP status code is returned.

For lower-level connectivity, `ping` quickly shows whether the host can be reached at all, but it does not prove that the application works.

### If DNS fails

I would inspect:

- Application layer: DNS query behavior with `nslookup` or `dig`.
- Network/internet layer: whether I can reach the DNS server IP.
- Local config: DNS server settings, VPN, firewall, or router DNS policy.

### If HTTP 500 appears

HTTP 500 means the network path is probably working, but the application failed. I would inspect:

- application logs
- service health
- upstream dependencies such as database, cache, or environment variables

### Two follow-up checks in a real incident

```powershell
netstat -ano | findstr :8080
curl.exe -v http://localhost:8080
```

These would show which process owns the port and give more detail about the HTTP connection.

## Key Takeaways

- `ping` can succeed while HTTP fails, so each layer must be checked separately.
- Traceroute timeouts in the middle do not always mean failure if the final destination responds.
- DNS behavior can differ between tools because of resolver configuration, caching, or network policy.
- For web troubleshooting, I should move from IP reachability to DNS, then port checks, then HTTP response, then application logs.
