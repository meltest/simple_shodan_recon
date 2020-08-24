# Overview
Simple Shodan Recon collects host information from Shodan and output them to csv file.
Simple Shodan Recon collects

* IP address

* Ports

* OS

* Hostnames

* Domains

* Products

* Version

* Vulnerabilities

* Timestamp

# Requirements

* jq [https://stedolan.github.io/jq/](https://stedolan.github.io/jq/)

* Shodan CLI [https://cli.shodan.io/](https://cli.shodan.io/)

# Support
Linux


# Usage
```
Usage: simple_shodan_recon.sh [OPTION] <ip_address>
Options: 
    -h		Display help.
    -f IP_LIST	Get IP Address list from file instead of STDIN.
    -p		Show the complete history of the host.
```

# Install

```
git clone 
cd simple_shodan_recon
shodan init YOUR_API_KEY 
chmod +x simple_shodan_recon.sh
./simple_shodan_recon TARGET_IP
```
