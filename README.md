# Accessing cloud-hosted DESI data

DESI's early data release (EDR) will soon be made publicly accessible through an S3 cloud storage "bucket" on Amazon Web Services (AWS). 
You can directly download the data at _insert url_.
However, we recommend accessing this data through this repository's Docker image,
a self-contained code environment which comes pre-packaged with
* A filesystem mounted to the DESI S3 bucket, which automatically downloads the data you query and nothing more, and
* A Jupyter server installed with general Python libraries for scientific programming, as well as DESI-specific libraries.

You can either run this image locally or on a cloud compute instance, such as AWS EC2. 
Below, we will provide instructions for both use cases.

## Getting started

All DESI S3 data can be accessed via HTTPS without an AWS account.
However, this Docker image relies on specific AWS software, which requires user credentials to run.
As such, you will need to make an AWS account (which you can set to free tier), but you will not be charged any fees for this.

### Obtaining AWS credentials

1. Create an AWS account
2. Follow the steps at [How to backup to S3 CLI](https://aws.amazon.com/getting-started/hands-on/backup-to-s3-cli/)
   to create an AWS IAM user and save its `credentials.csv` file.

## Setting up an EC2 instance (Optional)

(Up to date as of March 2024)

If you wish to run this Docker container on the cloud, one option is via with AWS EC2.

### Create a security group

To access the Jupyter web server provided by our Docker image, 
we need to create a security group which allows HTTPS network access.

On AWS, navigate to **Services > EC2 > Security groups**, then click **Create security group**.
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
   
4. **Outbound rules:** Add the following rule (if it isn't already there) &mdash;

| Type        | Protocol | Port range | Source type   | Source        | Description
| ----        | -------- | ---------- | -----------   | ------        | -----------
| All traffic | _(All)_  | _(All)_    | Anywhere-IPv4 | _(0.0.0.0/0)_ | Allow instance to access the whole internet

Then click **Create security group**.

### Launch an instance

On AWS, navigate to **Services > EC2 > Instances**, then click **Launch instances**.
Fill in the following fields &mdash;

1. **Name and tags:** Pick your own.
2. **Application and OS Images (Amazon Machine Image):** We recommend selecting **Amazon Linux**, although Ubuntu and other Unix systems should also work.
3. **Instance type:** At least **2 GiB** of memory is required for installing all the necessary packages for DESI.
   The cheapest instance type which has this much memory is **t2.small**.
   You can upgrade to other instances if you need more processing power and memory.
5. **Key pair:** Create your own and save the private key file.
6. **Network settings:** Select the **jupyter** security group we created earlier.
7. **Configure storage:** For free-tier accounts, we recommend the maximum available **30 GiB**. There can be a lot of locally cached DESI data!

Then click **Launch instance**.

### Connecting to the instance

We recommend using SSH?

### Importing credentials 

On the Terminal, write
```bash
nano credentials.csv
```
Paste in your credentials (`Ctrl+Shift+V`), then save and exit (`Ctrl+X`, `Yes`, `Enter`).
The credentials are now stored at `$HOME/credentials.csv`.

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

1. Install **[Docker engine](https://docs.docker.com/engine/install/)**.
   (If you're running on Amazon Linux, refer to the above instructions instead).
3. Open the Terminal
4. Run this line to build a Docker image from this repository. This should take 3 to 10 minutes.
```bash
docker image build -t docker-aws-jupyter https://github.com/flyorboom/docker-aws-jupyter.git
```
3. Run this line to run the image. Replace `PATH_TO_CREDENTIALS` with the path to your `credentials.csv`.
```bash
docker run -it \
  -p 8888:8888 \
  --mount type=bind,src="PATH_TO_CREDENTIALS",dst="/tmp/aws_credentials.csv",readonly \
  --mount type=bind,src="$(pwd)",dst="/mnt/local_volume" \
  --cap-add SYS_ADMIN \
  --device /dev/fuse \
  --security-opt apparmor:unconfined \
  docker-aws-jupyter
```
5. Locate the line beginning with `localhost:` in the output, and open the address in your browser.

