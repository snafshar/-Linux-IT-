# DNS Troubleshooting Lab

A successful IP connection and a successful name lookup are separate questions.

## Useful commands

```bash
getent hosts example.com
dig example.com
nslookup example.com
cat /etc/resolv.conf
```

Not every Linux installation has both `dig` and `nslookup`; `getent` commonly follows the machine's configured name-service policy.

## Workflow

1. Confirm that the local interface has an address.
2. Check the default route.
3. Try resolving a known hostname.
4. Compare the result with a direct-IP connectivity test.
5. Record errors instead of assuming every failure is a DNS problem.

## Exercise

Write down one scenario where DNS works but HTTP fails, and one where IP routing works but DNS fails. Explain what evidence would distinguish each case.
