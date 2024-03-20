# DESI access via AWS

## Obtaining AWS credentials 

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

## Running the DESI- and AWS-equipped Jupyter container

1. Install Docker
2. Run this line to build a Docker image from this repository. This should take 3 to 10 minutes.
```bash
docker image build -t docker-aws-jupyter https://github.com/flyorboom/docker-aws-jupyter.git
```
2. Run this line to run the image. Replace `PATH_TO_CREDENTIALS` to the path to your `credentials.csv`, and replace `YOUR_PORT` with a port you want to use, such as `8888`.
```bash
docker run -it \
  -p YOUR_PORT:8888 \
  --mount type=bind,src="PATH_TO_CREDENTIALS",dst="/opt/aws/credentials.csv",readonly \
  --device /dev/fuse \
  --privileged \
  docker-aws-jupyter
```
3. Locate the line beginning with `localhost:` in the output, and open the address in your browser.

