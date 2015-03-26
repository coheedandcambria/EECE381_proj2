echo "Installing necessary files, Please stay connected to the internet and leave your rPI running"

# update the rPI
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install cmake

# Install open CV
sudo apt-get install libopencv-*
sudo apt-get install python-opencv
sudo apt-get install python-numpy

# Install zbar
sudo apt-get install python-gtk2-dev
wget http://sourceforge.net/projects/zbar/files/zbar/0.10/zbar-0.10.tar.bz2/download -O zbar-0.10.tar.bz2

bunzip2 zbar-0.10.tar.bz2
tar -xvf zbar-0.10.tar

mkdir -v zbar-build
cd zbar-build
../zbar-0.10/configure \
	--prefix=/usr/local \
	--disable-video \
	--without-imagemagick
make
make check
sudo make install

sudo nano /etc/ld.so.conf.d/zbar.conf
sudo echo '/usr/local/lib' >> /etc/ld.so.conf.d/zbar.conf
sudo ldconfig


#leave zbar directory
cd ..

# Setting up camera stuff
sudo apt-get install uv4l uv4l-raspicam
sudo apt-get install uv4l-raspicam-extras
sudo service uv4l_raspicam restart

echo "your pi is now up to date with current code and has all necessary software"

