# testweblb

This terraform module will create the following Azure infrastructure:

* A pool of VMs running [testwebserver](https://github.com/mr-stringer/testwebserver)
* A load balancer
* A NAT gateway

The module has the following variables:

|Variable|Type|Description|Required|
|-|-|-|-|
| projectName | string | Naming prefix for the Azure resources | false - defaults to testweblb-proj
| rg | String | The name of the resource group in which the resources will be built | true |
| location | string | The Azure region where the will be built | true
| subnetId | string | The subnet ID of the subnet that the resources will attach to (must be the id not the name) | true
| cloudInitPath | string | The path to the required cloud-init.yaml file for example './cloud-init.yaml'.  It is recommended to download and use [this file](https://github.com/mr-stringer/testwebserver/releases/download/v1.0.0/cloud-init.yaml) | true
| vmCount | number | The number of webserver VMs that will be built | false - defaults to 2 |
| adminUser | string | The name of the admin user account of the VMs | false - defaults to 'terry' |
| adminUserPubKey | string | The ssh public key of the admin user | true

The module has the following outputs:

| Output | Description |
|-|-|
| lbPubIp | The public IP of the load balancer |
| vnNames | The names of the VMs in the pool |

The repo serves no real purpose other than my own expirementation.  However, if you find it useful then that's cool too.  And if you see anything hideously wrong, why not submit an issue or PR?