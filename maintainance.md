# Maintaining this project

Our Docker container is bulit off of the Jupyter Project's [Docker images for running Jupyter servers](https://github.com/jupyter/docker-stacks/).
Starting from their image, we install
* AWS Mountpoint to mount the AWS S3 filesystem
* Additional DESI Python packages document at
  [Installing DESI code on your laptop or other local machine](https://desi.lbl.gov/trac/wiki/Pipeline/GettingStarted/Laptop)
  (DESI collaboration internal link)

We have a weekly [GitHub Actions](https://docs.github.com/en/actions) job to build the Docker image and upload it to [ghcr.io/desihub/desidocker](https://ghcr.io/desihub/desidocker),
hosted by [GitHub's container repository (GHCR)](https://ghcr.io). As of 2024, GitHub makes GitHub Action and GHCR available to public repositories free-of-charge.
