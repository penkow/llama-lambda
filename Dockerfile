FROM public.ecr.aws/lambda/python:3.8

RUN yum install -y \
    autoconf \
    automake \
    cmake \
    gcc \
    gcc-c++ \
    libtool \
    make \
    nasm \
    pkgconfig

WORKDIR ${LAMBDA_TASK_ROOT}

RUN  pip3 install llama-cpp-python

# Specify the name of your quantized model here
ENV MODEL_NAME=**your qunatized model here**

# Copy the infrence code
COPY app.py ${LAMBDA_TASK_ROOT}

# Copy the model file
COPY ./model/${MODEL_NAME} ${LAMBDA_TASK_ROOT}/model/${MODEL_NAME}

# Set the CMD to your handler
CMD [ "app.handler" ] 
