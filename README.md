# simple_hue

#### Table of Contents

1. [Module Description - This module controls the Philips hue](#module-description)
2. [Setup - The basics of getting started with [modulename]](#setup)
    * [What simple_hue affects](#what-simple_hue-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with simple_hue](#beginning-with-simple_hue)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)


## Module description
The philips Hue is a hub that controls wirelessly connected lightbulbs. This module allows you to connect to the hub and control the lightbulbs. The purpose of this module is for teaching, and providing a simple framework to start development with. simple_hue will not get any new features, the smart_hue module exposes more features in the philips hue.

## Setup

### What the simple hue affects

-Changes the state of light bulbs connected to the philips hue.

### Setup requirements
- a puppet master
- a philips hue hub
- a philips hue light bulb or compatible

### Beginning with simple_hue
Grab a developer key from your hue hub, follow the steps here: http://www.developers.meethue.com/documentation/getting-started
Find the IP / hostname of your hue hub. Use a uPNP scanner, Nmap, your router / DHCP logs.

## Usage
Your puppet config files should look something like:
/etc/puppet/manifests/site.pp
node 'hampton' {
hue_light { '1':
  on        => 'false',
}
}

/etc/puppet/device.conf
[hampton]
  type hue
  url http://192.168.0.14/api/AVsa-nKtZOlssVKhBwM9MBVTVVUo11nSsGQPIm55

/etc/hosts
192.168.0.14 hampton

### Certs
Setup your certs for puppet to talk to your hue hub. EG:

puppet plugin download --server huemaster
puppet device -v --waitforcert 0 --user root --server huemaster
puppet cert sign hampton
puppet device -v --user root --server huemaster

### Query the hue hub
Run the following
FACTER_url=http://192.168.0.14/api/AVsa-nKtZOlssVKhBwM9MBVTVVUo11nSsGQPIm55 puppet resource hue_light

## Reference
- All API calls are made using the ruby faraday library.
- We follow the type / provider idiom.
- Followed this API guide: http://www.developers.meethue.com/documentation/lights-api#11_get_all_lights

## Limitations
There are no known limitations.

## Development
This is a simple module designed for teaching, new features should not be added. Fixes or improvements are.
