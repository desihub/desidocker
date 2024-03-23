# Accessing cloud-hosted DESI data

DESI's early data release (EDR) will soon be made publicly accessible through an S3 cloud storage "bucket" on Amazon Web Services (AWS). 
You can directly download the data at _insert url_.
However, we recommend accessing this data through this repository's Docker image,
a self-contained code environment which comes pre-packaged with
* A filesystem mounted to the DESI S3 bucket, which automatically downloads the data you query and nothing more
* A Jupyter server installed with general Python libraries for scientific programming, as well as DESI-specific libraries.

You can either run this image locally or on a cloud compute instance, such as AWS EC2. 
Below, we will provide instructions for both use cases.

## Getting started

### Obtaining AWS credentials

1. Create an AWS account
2. Follow the steps at [How to backup to S3 CLI](https://aws.amazon.com/getting-started/hands-on/backup-to-s3-cli/)
   to create an AWS IAM user and save its `credentials.csv` file.
3. Open `credentials.csv` and it should look like this:
    ```csv
    Access key ID,Secret access key
    YOUR_KEY_ID,YOUR_KEY_SECRET
    ```
    Add `,User Name` to the first row and `,default` to the second row, similar to this:
    ```csv
    Access key ID,Secret access key,User Name
    YOUR_KEY_ID,YOUR_KEY_SECRET,default
    ```
    Save these changes to your file.

## Setting up an EC2 instance (Optional)

If you wish to run this Docker container

## Running the DESI- and AWS-equipped Jupyter container

1. Install Docker
2. Run this line to build a Docker image from this repository. This should take 3 to 10 minutes.
```bash
docker image build -t docker-aws-jupyter https://github.com/flyorboom/docker-aws-jupyter.git
```
3. Run this line to run the image. Replace `PATH_TO_CREDENTIALS` with the path to your `credentials.csv`, and replace `YOUR_PORT` with a port you want to use, such as `8888`.
```bash
docker run -it \
  -p YOUR_PORT:8888 \
  --mount type=bind,src="PATH_TO_CREDENTIALS",dst="/aws_credentials.csv",readonly \
  --mount type=bind,src="$(pwd)",dst="/mnt/local_volume" \
  --cap-add SYS_ADMIN \
  --device /dev/fuse \
  --security-opt apparmor:unconfined \
  docker-aws-jupyter
```
5. Locate the line beginning with `localhost:` in the output, and open the address in your browser.

