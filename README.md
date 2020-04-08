# Routekut

Route your traffic based on country of the IP address.

Using routekut generated scripts, You can create static routes for a specific country.


## Supported platforms

 - [x] GNU/Linux (using ip command)
 - [ ] Windows
 - [x] Mikrotik
 - [ ] pfSense

## How to use

### GNU/Linux

Go to the [Releases](https://github.com/alisinabh/routekut/releases) page and download the latest `linux-ipv4.tar.gz` file.

Extract it and run `./add_routes.sh` in terminal which will interactiveley ask for your country and gateway.

## Contribution

The elixir project here is only used to extract country ip addresses in CIDR format. It currently only supports IPv4.

## Credits

This project uses [db-ip.com](https://db-ip.com) IP to Country Lite Database.
