FROM centos:latest

MAINTAINER brockp@umich.edu

ADD scripts scripts

# follows CENTOS source install as following
#   http://elasticluster.readthedocs.io/en/latest/install.html

# pip requires EPEL
RUN yum install -y epel-release

# update centos
RUN yum -y update

RUN yum install -y gcc gcc-c++ git libffi-devel openssl-devel python-devel python-pip which

RUN pip install --upgrade 'pip>=9.0.0'

# newer version of setuptools is required
RUN pip install six packaging appdirs; pip install --upgrade setuptools

RUN mkdir elasticluster && \
    cd elasticluster && \
    git clone git://github.com/gc3-uzh-ch/elasticluster.git src && \
    cd src && \
    pip install -e .


#setup google SDK
# you will need to generate an SSH key pair to use the SDK before
# a cluster will work
# http://googlegenomics.readthedocs.io/en/latest/use_cases/setup_gridengine_cluster_on_compute_engine/index.html#index-obtaining-client-id-and-client-secrets
# https://cloud.google.com/sdk/docs/quickstart-redhat-centos

RUN /bin/bash scripts/google-sdk.sh
RUN yum install -y google-cloud-sdk

#clean up repos
RUN yum clean -y all

# add ansible config to avoid ssh master issues
COPY ansible/ansible.cfg /root/

CMD ["/bin/bash"]
