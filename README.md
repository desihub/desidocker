# Accessing cloud-hosted DESI data

DESI's early data release (EDR) will soon be made publicly accessible through an S3 cloud storage "bucket" on Amazon Web Services (AWS). 
You can directly download the data at _insert url_.
However, we recommend accessing this data through this repository's Docker image,
a self-contained code environment which comes pre-packaged with
* A filesystem mounted to the DESI S3 bucket, which automatically downloads the data you query and nothing more, and
* A Jupyter server installed with general Python libraries for scientific programming, as well as DESI-specific libraries.

You can either run this image locally or on a cloud compute instance.
A cloud compute instance gives you on-demand access to additional storage and processing power.
The cost is mainly charged for actively running the compute instances.

If you prefer to run locally, skip ahead to the section on [Running the Docker image](#running-the-docker-image).
If you wish to run on the cloud, below are instructions for [Setting up an EC2 instance](#setting-up-an-ec2-instance-optional).

## Setting up an EC2 instance (Optional)

(Up to date as of March 2024)

### Creating an account

While you do not need an AWS account to access the DESI data locally,
you do have to make one in order to use the AWS EC2 service.
Follow the official instructions for
[First time users of AWS](https://docs.aws.amazon.com/accounts/latest/reference/welcome-first-time-user.html)
to get started.
Once you’ve signed into your account, you can navigate to **Services » EC2** to set-up a cloud compute instance.

### Creating a security group

To access the Jupyter web server provided by our Docker image, 
first we need to create a security group which allows HTTPS network access.

Navigate to **Services » EC2 » Security groups**, then click **Create security group**.
Fill in the following fields &mdash;

1. **Basic details:** Name the security group **jupyter**.
2. **Inbound rules:** Add the following rules &mdash;

| Type       | Protocol | Port range | Source type | Source      | Description
| ----       | -------- | ---------- | ----------- | ------      | -----------
| Custom TCP | _(TCP)_  | 8888       | My IP       | _(Your IP)_ | Open TCP port for Jupyter server
| HTTPS      | _(TCP)_  | _(443)_    | My IP       | _(Your IP)_ | Allow HTTPS for Jupyter server
| SSH        | _(TCP)_  | _(22)_     | My IP       | _(Your IP)_ | Allow SSH access to the instance

If your IP address is not fixed (for example, if you primarily use cellular data or are on a large WiFi network),
you should instead enter "Custom" for **Source type** and the range of possible IP addresses you use in **Source**.
   
3. **Outbound rules:** Add the following rule (if it isn't already there) &mdash;

| Type        | Protocol | Port range | Source type   | Source        | Description
| ----        | -------- | ---------- | -----------   | ------        | -----------
| All traffic | _(All)_  | _(All)_    | Anywhere-IPv4 | _(0.0.0.0/0)_ | Allow instance to access the whole internet

Then click **Create security group**.

### Launching an instance

Navigate to **Services » EC2 » Instances**, then click **Launch instances**.
Fill in the following fields &mdash;

1. **Name and tags:** Pick your own.
2. **Application and OS Images (Amazon Machine Image):** We recommend selecting **Amazon Linux**, although Ubuntu and other Unix systems should also work.
3. **Instance type:** We recommend starting with **t2.micro**. You can upgrade to other instances if you need more processing power and memory,
   or downgrade to t2.nano for a lower cost.
5. **Key pair:** Create your own and save the private key file.
6. **Network settings:** Select the **jupyter** security group we created earlier.
7. **Configure storage:** For free-tier accounts, we recommend the maximum available **30 GiB**. There can be a lot of locally cached DESI data!

Then click **Launch instance**.
After the instance has loaded, follow the official instructions to 
[Connect to your instance](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-connect-methods.html).

### Installing Docker on the instance

Amazon Linux uses the `yum` package management system. 
Run the following lines to install Git and Docker.
```bash
# Refresh package repository
sudo yum update

# Install Git
sudo yum install git

# Install Docker
sudo yum install docker

# Give Docker extra permissions
sudo usermod -a -G docker ec2-user
id ec2-user
newgrp docker

# Start Docker's daemon
sudo systemctl enable docker.service
sudo systemctl start docker.service
```

## Running the Docker image

1. Get Docker.
   If you're running Amazon Linux, refer to the installation instructions in the previous section.
   If you're running macOS or another Linux distribution,
   we recommend installing [Docker engine](https://docs.docker.com/engine/install/) (the command-line tool).
   Otherwise, you should install [Docker Desktop](https://docs.docker.com/get-docker/).
 
3. Run this line to run the image.
```bash
docker run -it -p 8888:8888 \
  --volume "$(pwd):/mnt/local_volume" \
  --cap-add SYS_ADMIN --device /dev/fuse --security-opt apparmor:unconfined \
  ghcr.io/flyorboom/docker-aws-jupyter:main
```
(Note that mounting the S3 bucket as a local filesystem [requires](https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities)
granting the container sysadmin-level access to your computer's [FUSE](https://en.wikipedia.org/wiki/Filesystem_in_Userspace) interface.
This is not ideal for security, so if that is a major concern, then we do recommend running a cloud instance.)

3. Locate the line beginning with `http://127.0.0.1:8888/lab?token=...` in the output, and open the address in your browser.
   (If you are running a cloud instance, replace `127.0.0.1` with the public IP address of your cloud server.)
