sudo yum update -y

sudo yum install amazon-cloudwatch-agent -y
cat <<EOT >> cloud-watch-config.json
{
  "agent": {
    "metrics_collection_interval": 30,
    "run_as_user": "root"
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/home/ec2-user/logs/Minecraft/latest.log",
            "log_group_name": "minecraft-paper-server-logs",
            "log_stream_name": "{instance_id}",
            "retention_in_days": 60
          }
        ]
      }
    }
  },
  "metrics": {
    "aggregation_dimensions": [
      [
        "InstanceId"
      ]
    ],
    "append_dimensions": {
      "AutoScalingGroupName": "${aws:AutoScalingGroupName}",
      "ImageId": "${aws:ImageId}",
      "InstanceId": "${aws:InstanceId}",
      "InstanceType": "${aws:InstanceType}"
    },
    "metrics_collected": {
      "cpu": {
        "measurement": [
          "cpu_usage_idle",
          "cpu_usage_iowait",
          "cpu_usage_user",
          "cpu_usage_system"
        ],
        "metrics_collection_interval": 30,
        "resources": [
          "*"
        ],
        "totalcpu": false
      },
      "disk": {
        "measurement": [
          "used_percent",
          "inodes_free"
        ],
        "metrics_collection_interval": 30,
        "resources": [
          "*"
        ]
      },
      "diskio": {
        "measurement": [
          "io_time",
          "write_bytes",
          "read_bytes",
          "writes",
          "reads"
        ],
        "metrics_collection_interval": 30,
        "resources": [
          "*"
        ]
      },
      "mem": {
        "measurement": [
          "mem_used_percent"
        ],
        "metrics_collection_interval": 30
      },
      "netstat": {
        "measurement": [
          "tcp_established",
          "tcp_time_wait"
        ],
        "metrics_collection_interval": 30
      },
      "swap": {
        "measurement": [
          "swap_used_percent"
        ],
        "metrics_collection_interval": 30
      }
    }
  }
}

EOT

sudo yum install java-17-amazon-corretto-headless -y
wget https://api.papermc.io/v2/projects/paper/versions/1.19.3/builds/396/downloads/paper-1.19.3-396.jar
mkdir Minecraft
mv paper-1.19.3-396.jar ./Minecraft/paper.jar
echo "eula=true" >> ./Minecraft/eula.txt

wget https://github.com/TheTrillerpfeife/Minecraft-Server-Wrapper/releases/download/v0.0.1/Minecraft-Server-Wrapper-0.0.1.jar
mv Minecraft-Server-Wrapper-0.0.1.jar Minecraft-Server-Wrapper.jar

java -jar Minecraft-Server-Wrapper.jar