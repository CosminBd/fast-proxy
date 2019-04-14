Fast squid proxy

This bash script helps you set up a Ubuntu/Debian HTTP proxy in seconds and set the proxy details as env variables as: 

**proxyAddress**

**proxyPort**

**proxyLogin**

**proxyPassword**



You need to pass 2 parameters to stdin: your desired **username** and **port**.

## Installation

```bash
git clone https://github.com/CosminBd/fast-proxy.git
```

## Usage

```bash
. proxy.sh # execute with dot in the current shell otherwise it won't set env vars
```

## Testing 


```bash
curl -L http://ifconfig.me -x http://[username]:[password]@[hostname]:[port]
```


