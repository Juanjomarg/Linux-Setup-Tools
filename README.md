# Setup tool

This shell script was made to make setting up linux terminals for the first time quick and easy. It downloads all the basic tools and installs them. Use the menu to choose what to install and press enter to proceed. WIP

## Usage

1. Install wget if not on pc
2. Clone the setup.sh script to your computer.
3. Give execution permissions
4. Run script

### 000. All steps at once

```
sudo apt install wget -y || wget https://raw.githubusercontent.com/Juanjomarg/setup/main/setup.sh || chmod +x setup.sh || ./setup.sh
```

### 1. Install wget if not on pc

```
sudo apt install wget -y
```

### 2. Clone the setup.sh script to your computer.

```
wget https://raw.githubusercontent.com/Juanjomarg/setup/main/setup.sh
```

### 3. Give execution permissions

```
chmod +x setup.sh
```

### 4. Run script

```
./setup.sh
```

## Authors

Contributors names and contact info

Juan José Martínez
[@juandesigned](https://instagram.com/juandesigned)

## Version History

* 0.2
    * Various bug fixes and optimizations
    * See [commit change]() or See [release history]()
* 0.1
    * Initial Release

## License

This project is licensed under the CC License
