# Server Performance Stats
Bash script to analyse basic server performance stats. 

The script is able to run on any Linux server and it provides the following stats:

- Total CPU usage
- Total memory usage (Free vs Used including percentage)
- Total disk usage (Free vs Used including percentage)
- Top 5 processes by CPU usage
- Top 5 processes by memory usage

## Getting Started

1. Clone the repository
```bash
git clone https://github.com/lethanix/server-perf-stats.git
```

2. Modify permissions to make the script executable
```bash
chmod +x server-stats.sh
```

3. Run the script
```bash
./server-stats.sh
```

---

This is based on the project from roadmap.sh [Server Stats](https://roadmap.sh/projects/server-stats).
