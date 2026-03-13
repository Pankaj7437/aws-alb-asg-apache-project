# Highly Available Web Server Architecture on AWS using ALB and Auto Scaling

This project demonstrates how to build a **highly available and scalable web server architecture on AWS** using:

- Amazon EC2
- Application Load Balancer (ALB)
- Auto Scaling Group (ASG)
- Launch Template
- Custom AMI
- Apache HTTP Server

The infrastructure distributes incoming traffic across multiple servers and automatically replaces failed instances to maintain high availability.

---

# Project Architecture

The following architecture ensures that traffic is distributed evenly across EC2 instances.

```
                Internet
                    │
                    ▼
        Application Load Balancer
                    │
                    ▼
              Target Group
                    │
                    ▼
            Auto Scaling Group
          /          │           \
         ▼           ▼            ▼
   EC2 Instance  EC2 Instance  EC2 Instance
      Apache         Apache        Apache
```

---

# Repository Structure

```
aws-alb-asg-apache-project/
│
├── README.md
│
├── scripts/
│   └── user-data.sh
│
├── architecture/
│   └── architecture-diagram.png
│
└── screenshots/
    ├── ec2-instances.png
    ├── launch-template.png
    ├── load-balancer.png
    ├── target-group.png
    ├── auto-scaling-group.png
    └── web-page.png
```

---

# AWS Services Used

| Service | Purpose |
|------|------|
| Amazon EC2 | Hosting web servers |
| Amazon AMI | Creating identical instance images |
| Launch Template | Template for launching instances |
| Auto Scaling Group | Automatically manages instance count |
| Application Load Balancer | Distributes traffic |
| Target Group | Routes traffic to instances |
| Security Groups | Controls inbound and outbound traffic |

---

# Step 1: Launch EC2 Instance

Navigate to:

```
AWS Console → EC2 → Launch Instance
```

Configuration:

```
AMI: Amazon Linux
Instance type: t3.micro
Security Group: Allow SSH (22) and HTTP (80)
```

Connect to the instance using SSH.

---

# Step 2: Install Apache Web Server

Run the following commands:

```bash
sudo yum update -y
sudo yum install httpd -y
```

Start Apache:

```bash
sudo systemctl start httpd
sudo systemctl enable httpd
```

---

# Step 3: Create Web Page

Create a simple HTML page:

```bash
echo "<h1>Apache Webserver running on Amazon Linux - $(hostname)</h1>" > /var/www/html/index.html
```

Restart Apache:

```bash
sudo systemctl restart httpd
```

---

# Step 4: Test Web Server

Open the instance public IP in the browser:

```
http://<instance-public-ip>
```

You should see the Apache web page.

---

# Step 5: Create Custom AMI

Go to:

```
EC2 → Instances
```

Select the configured instance.

```
Actions → Image and templates → Create Image
```

Example AMI name:

```
aws-ami-apacheweb-server
```

This AMI contains Apache and the web page configuration.

---

# Step 6: Create Launch Template

Navigate to:

```
EC2 → Launch Templates → Create Launch Template
```

Configuration:

```
AMI: aws-ami-apacheweb-server
Instance type: t3.micro
Security Group: allow HTTP
```

Add **User Data script** from `scripts/user-data.sh`.

---

# Step 7: Create Target Group

Navigate to:

```
EC2 → Target Groups → Create Target Group
```

Configuration:

```
Target type: Instance
Protocol: HTTP
Port: 80
Health check path: /
```

---

# Step 8: Create Application Load Balancer

Go to:

```
EC2 → Load Balancers → Create Load Balancer
```

Select:

```
Application Load Balancer
```

Configuration:

```
Scheme: Internet-facing
Listener: HTTP (80)
Target Group: apache-webserver-asg
```

---

# Step 9: Configure Security Groups

Load Balancer Security Group

| Type | Port | Source |
|-----|-----|------|
| HTTP | 80 | 0.0.0.0/0 |

EC2 Instance Security Group

| Type | Port | Source |
|-----|-----|------|
| HTTP | 80 | Load Balancer Security Group |

---

# Step 10: Create Auto Scaling Group

Navigate to:

```
EC2 → Auto Scaling Groups → Create Auto Scaling Group
```

Configuration:

```
Launch Template: apache-template
Desired Capacity: 2
Minimum Capacity: 2
Maximum Capacity: 4
```

Attach the previously created **Target Group**.

---

# Step 11: Access the Application

Open the Load Balancer DNS:

```
http://<load-balancer-dns>
```

Example:

```
http://new-lb-apache-704109030.ap-south-1.elb.amazonaws.com
```

---

# Step 12: Test Load Balancing

Refresh the page multiple times.

You will see different hostnames:

```
Apache Webserver running on Amazon Linux - ip-172-31-26-94
Apache Webserver running on Amazon Linux - ip-172-31-45-10
```

This confirms that traffic is being distributed across multiple instances.

---

# Step 13: Test Auto Scaling

Terminate one EC2 instance.

```
EC2 → Instances → Terminate
```

Auto Scaling Group will automatically launch a new instance.

---

# Key Features

- High Availability
- Automatic instance replacement
- Load balancing across servers
- Scalable infrastructure
- Automated server configuration using user data

---

# Project Outcome

This project demonstrates a **production-style scalable web architecture on AWS** where:

- traffic is balanced across servers
- instances are automatically replaced if they fail
- infrastructure can scale based on demand