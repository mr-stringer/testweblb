variable "projectName" {
    description = "Naming prefix for the Azure resources"
    type = string
    default = "testweblb-proj"
}

#Required!
variable "rg" {
    description = "The name of the resource group in which the resources will be built"
    type = string
}

#Required!
variable "location" {
    description = "The Azure region where the will be built"
    type = string
}

#Required!
variable "subnetId" {
    description = "The subnet ID of the subnet that the resources will attach to"
    type = string
}

#Required!
variable "cloudInitPath" {
    description = "The path to the required cloud-init.yaml file for example './cloud-init.yaml'.  It is recommended to download and use https://github.com/mr-stringer/testwebserver/releases/download/v1.0.0/cloud-init.yaml"
    type = string  
}

variable "vmCount" {
    description = "The number of webserver VMs that will be built - defaults to 2"
    type = number
    default = 2  
}

variable "adminUser" {
    description = "The name of the admin user account of the VMs, defaults to terry"
    type = string
    default = "terry"
}

#Required
variable "adminUserPubKey" {
    description = "The ssh public key of the admin user"
    type = string
}

locals {
    vmName = "${var.projectName}-vm"
    nicName = "${var.projectName}-nic"
    nicIpConfName = "${var.projectName}-ipConf"
    nsgName = "${var.projectName}-nsg"
    natGwName = "${var.projectName}-natGw"
    natGwPubIpName = "${var.projectName}-natGw-pubIp"
    lbName = "${var.projectName}-lb"
    lbPubIpName = "${var.projectName}-lb-pubIp"
    lbFeIpCfgName = "${var.projectName}-lb-IpCfg"
}