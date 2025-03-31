# Nginx Log Analyser

Simple shell tool to analyse an nginx access log file, which contains the following fields:

- IP address
- Date and time
- Request method and path
- Response status code
- Response size
- Referrer
- User agent

The script is able to run on any Linux server and it provides the following information:

- Top 5 IP addresses with the most requests
- Top 5 most requested paths
- Top 5 response status codes
- Top 5 user agents

Here is an example of what the output should look like:

```bash
Top 5 IP addresses with the most requests:
45.76.135.253 - 1000 requests
142.93.143.8 - 600 requests
178.128.94.113 - 50 requests
43.224.43.187 - 30 requests
178.128.94.113 - 20 requests

Top 5 most requested paths:
/api/v1/users - 1000 requests
/api/v1/products - 600 requests
/api/v1/orders - 50 requests
/api/v1/payments - 30 requests
/api/v1/reviews - 20 requests

Top 5 response status codes:
200 - 1000 requests
404 - 600 requests
500 - 50 requests
401 - 30 requests
304 - 20 requests
```

## Getting Started

1. Clone the repository
```bash
git clone https://github.com/lethanix/nginx-log-analyser.git
```

2. Modify permissions to make the script executable
```bash
chmod +x nginx-analyser.sh
```

3. Run the script
```bash
./nginx-analyser.sh
```

---

This is based on the project from roadmap.sh [Nginx Log Analyser](https://roadmap.sh/projects/nginx-log-analyser).

