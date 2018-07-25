# See: http://phusion.github.io/baseimage-docker/
# baseimage is an docker friendly version of ubuntu
FROM phusion/baseimage:0.10.1

# Create a directory for working with ClearMap
RUN mkdir clearmap
# Set this as working directory
WORKDIR clearmap

# Install the neccessary Ubuntu packages 
RUN apt-get update
RUN apt-get install -y python2.7
RUN apt-get install -y python-pip
RUN apt-get install -y python-dev
RUN apt-get install -y build-essential
RUN apt-get install -y wget
RUN apt-get install -y bzip2
RUN apt-get install -y unzip
RUN apt-get install -y libgomp1

# Installing neccessary python packages
RUN pip install --upgrade pip
RUN pip install Cython
RUN pip install numpy


# Copy additional ClearMap resources.
# Included in the docker repo to combat any future 
# changes to the iDisco website.
RUN wget https://idiscodotinfo.files.wordpress.com/2016/05/clearmap_ressources_mouse_brain.zip
RUN unzip clearmap_ressources_mouse_brain.zip
RUN rm clearmap_ressources_mouse_brain.zip
RUN rm -r __MACOSX
RUN mv ClearMap_ressources resources

# Programmatically set the version of Elastix to pull.
ENV ElastixVersion "4.9.0"

# Download a release of Elastix. 
# Development deemed stable (July, 2018).
RUN wget https://github.com/SuperElastix/elastix/releases/download/${ElastixVersion}/elastix-${ElastixVersion}-linux.tar.bz2
RUN tar xvjf elastix-4.9.0-linux.tar.bz2
RUN rm elastix-4.9.0-linux.tar.bz2

# Cleaning / reorganizing binaries and libraries.
RUN mv bin/* /bin
RUN mv lib/* /lib
RUN rm -r bin && rm -r lib

# Keeping the original license (good practice).
RUN mkdir elastix_metadata
RUN mv LICENSE elastix_metadata && mv NOTICE elastix_metadata

# Updating the bashrc
RUN echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/lib" >> ~/.bashrc

# Install our custom ClearMap
RUN pip install https://github.com/LernerLab/ClearMap/zipball/master

