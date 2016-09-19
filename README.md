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
7. [Feedback - Get in touch !](#feedback)


## Module description
The philips Hue is a hub that controls wirelessly connected lightbulbs. This module allows you to connect to the hub and control the lightbulbs. The purpose of this module is for teaching, and providing a simple framework to start development with. simple_hue will not get any new features, the smart_hue module exposes more features in the philips hue.

## Setup

### What the simple hue affects

-Changes the state of light bulbs connected to the philips hue.

### Setup requirements
- a philips hue hub
- a philips hue light bulb or compatible
- a puppet agent

### Beginning with simple_hue
These two attributes are needed for puppet to control the philips hue hub:
DEVELOPER_KEY: Grab a developer key from your hue hub, follow the steps here: http://www.developers.meethue.com/documentation/getting-started
DEVELOPER_ID: Find the IP / hostname of your hue hub. Use a uPNP scanner, Nmap, your router / DHCP logs.

We use environment variables to store this. On a Ubuntu box we would set them like
export HUE_KEY=pUAUbcowosjBKgE5VQTrD6kkfkfoQK1ZtN14pHl8; export HUE_IP=10.64.12.162

## Usage
Your puppet manifest file that turns the first light on would look something like:
hue_light { '1':
  on  => 'true',
  hue => '0',
}

To apply the manifest run the following (you will need to have set some environment variables mentioned above)

puppet apply manifest.pp

### Query the hue hub
Run the following: (you will need to have set some environment variables mentioned above)
puppet resource hue_light

## Reference
- All API calls are made using the ruby faraday library.
- We follow the type / provider idiom.
- This is agentless.
- Followed this API guide: http://www.developers.meethue.com/documentation/lights-api#11_get_all_lights

## Limitations
There are no known limitations. Currently only tested on Ubuntu.

## Development
This is a simple module designed for teaching, this is not the place for new features. Fixes or improvements to hat is already here, are welcome.

## Feedback
Feel free to leave issues or PR's on the github page.
