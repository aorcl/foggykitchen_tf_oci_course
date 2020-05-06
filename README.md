# FoggyKitchen Terraform OCI Course - **Windows version**

## Course description

In this course, you can find 10 lessons (+ 4 extra lessons) with the Terraform's HCL version 0.12 code examples for the deployment of OCI resources. Our course starts with the simple example of one webserver in one regional public subnet, nested in one VCN in particular availability domain (AD). Incrementally next lessons will show you how to implement multiplied webservers, spread between ADs, located under load balancer umbrella. Further, we will make this setup even more secure by the introduction of private subnets and bastion-host to jump over. We will also explore storage options for the servers (local block volumes and shared filesystems). Besides the web tier, we will introduce VM based OCI DBSystem deployed in the fully separated private subnet. The last lesson will introduce VCN local peering for the integration of private DBSystem and external VCN with backend server (local VCN peering).

## How to use code from the lessons

### STEP 0.

**0.1 - Prepare SSH key pair**

In **Powershell**, execute:

```
ssh-keygen
```

Answer to the questions asked:

Enter file in which to save the key: **/c/tmp/id_rsa** (we presume the c:\tmp\ directory existed already)

Enter passphrase: **"Enter" for no passphrase and then another time to confirm**

**0.2 - Prepare API Signing key**

In **Powershell**, execute:

```
openssl genrsa -out /c/tmp/oci_api_key.pem 2048
openssl rsa -pubout -in /c/tmp/oci_api_key.pem -out /c/tmp/oci_api_key_public.pem
```

To show the contents of the public key:

```
cat /tmp/oci_api_key_public.pem
```

To associate it with an OCI user: go to **OCI menu > Identity > Users** and select your user, then select the **API Keys** menu and press the **Add Public Key** button. Paste the public key value shown in the shell


To verify key's fingerprint, check that the value show for the uploaded key is the same as shown in the shell:

```
openssl rsa -pubout -outform DER -in /c/tmp/oci_api_key.pem | openssl md5 -c
```


### STEP 1.

1.1: Clone the repo from github by executing the command as follows and then go to foggykitchen_tf_oci_course directory:

```
git clone https://github.com/aorcl/foggykitchen_tf_oci_course.git

Cloning into 'foggykitchen_tf_oci_course'...
remote: Enumerating objects: 121, done.
remote: Counting objects: 100% (121/121), done.
remote: Compressing objects: 100% (89/89), done.
remote: Total 258 (delta 73), reused 79 (delta 32), pack-reused 137
Receiving objects: 100% (258/258), 68.71 MiB | 23.28 MiB/s, done.
Resolving deltas: 100% (142/142), done.
```

Navigate to the repository and switch to the windows version of the lab:

```
cd foggykitchen_tf_oci_course

git checkout develop-windows

ls 

    Directory: C:\Users\adolgano\Documents\DEVELOPMENT\github\aorcl\foggykitchen_tf_oci_course


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----       28/04/2020     16:55                LESSON10_transit_vcn
d-----       28/04/2020     16:55                LESSON1_single_webserver
d-----       28/04/2020     16:55                LESSON2a_second_webserver_in_another_FD
d-----       28/04/2020     16:55                LESSON2_second_webserver_in_other_AD
d-----       28/04/2020     16:55                LESSON3_load_balancer
d-----       28/04/2020     16:55                LESSON4a_load_balancer_NAT_bastion_security_groups
d-----       28/04/2020     16:55                LESSON4_load_balancer_NAT_bastion
d-----       28/04/2020     16:55                LESSON5a_shared_filesystem_security_groups
d-----       28/04/2020     16:55                LESSON5_shared_filesystem
d-----       28/04/2020     16:55                LESSON6_local_block_volumes
d-----       28/04/2020     16:55                LESSON7a_dbsystem_with_dataguard
d-----       28/04/2020     16:55                LESSON7_dbsystem
d-----       28/04/2020     16:55                LESSON8_vcn_local_peering
d-----       28/04/2020     16:55                LESSON9_vcn_remote_peering
-a----       28/04/2020     16:55             31 .gitignore
-a----       28/04/2020     17:53          23417 README.md
```

### STEP 2. - Install the Terraform binary

Follow the installation guide: https://learn.hashicorp.com/terraform/getting-started/install.html 

Find your platform and download the latest version of your terraform runtime. Add directory of terraform binary into PATH and check terraform version:


To verify the terraform binary was correctly installed, execute:

```
terraform --version

  Terraform v0.12.24
```

### STEP 3. 

Go to the lesson directory and create an environment file with 'TF_VAR_' variables (region1 + region2 required by lesson9 and lesson10):

#### If Windows:

```
cd LESSON3_load_balancer
code setup_oci_tf_vars.ps1
```

Enter this content into the powershell batch file, replacing the tenancy-specific IDs with your's:

```
$env:TF_VAR_user_ocid="ocid1.user.oc1..aaaaaaaaaqyobrezj7wnjk5zt2q6(...)mxvepdcr23z5kor4v5ceea"
$env:TF_VAR_tenancy_ocid="ocid1.tenancy.oc1..aaaaaaaalvbbkqilwful6cmkqa(...)whbevh5wjlsl6zpzm4ibj4a"
$env:TF_VAR_compartment_ocid="ocid1.compartment.oc1..aaaaaaaap4dw4cmk23(...)tslzljkw3h2fglgnb7g44p7tva"
$env:TF_VAR_fingerprint="91:e6:56:0c:6a:(...):f0:f3:22:bb:bd:eb:9d:eb"
$env:TF_VAR_private_key_path="c:\tmp\oci_api_key.pem"
$env:TF_VAR_region="eu-frankfurt-1"
$env:TF_VAR_region1="eu-frankfurt-1"
$env:TF_VAR_region2="eu-amsterdam-1"
$env:TF_VAR_private_key_oci="c:\tmp\id_rsa"
$env:TF_VAR_public_key_oci="c:\tmp\id_rsa.pub"
```

save, then execute the file to set the variables:

```
setup_oci_tf_vars.ps1
```

You can later veryfy the variables were set, executing

```
gci env:TF_VAR_* | Format-Table -Wrap -AutoSize
```

#### If Linux:

```
cd LESSON3_load_balancer
vi setup_oci_tf_vars.sh
```

Enter this content into the shell file, replacing the tenancy-specific IDs with your's:

```
export TF_VAR_user_ocid="ocid1.user.oc1..aaaaaaaaob4qbf2(...)uunizjie4his4vgh3jx5jxa"
export TF_VAR_tenancy_ocid="ocid1.tenancy.oc1..aaaaaaaas(...)krj2s3gdbz7d2heqzzxn7pe64ksbia"
export TF_VAR_compartment_ocid="ocid1.tenancy.oc1..aaaaaaaasbktyckn(...)ldkrj2s3gdbz7d2heqzzxn7pe64ksbia"
export TF_VAR_fingerprint="00:f9:d1:41:bb:57(...)82:47:e6:00"
export TF_VAR_private_key_path="/tmp/oci_api_key.pem"
export TF_VAR_region="eu-frankfurt-1"
export TF_VAR_region1="eu-frankfurt-1"
export TF_VAR_region2="eu-amsterdam-1"
export TF_VAR_private_key_oci="/tmp/id_rsa"
export TF_VAR_public_key_oci="/tmp/id_rsa.pub"
```

save, then execute the file to set the variables:

```
source setup_oci_tf_vars.sh
```

You can later veryfy the variables were set, executing

```
env | grep TF_VAR
```

### STEP 4.

Run *terraform init* with upgrade option just to download the lastest neccesary providers for this lesson:

```
$ terraform init -upgrade

Initializing the backend...

Initializing provider plugins...
- Checking for available provider plugins...
- Downloading plugin for provider "null" (hashicorp/null) 2.1.2...
- Downloading plugin for provider "oci" (hashicorp/oci) 3.65.0...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.null: version = "~> 2.1"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

### STEP 5.

Run *terraform apply* to provision the content of this lesson (type **yes** to confirm the the apply phase):

```
$ terraform apply

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)

Terraform will perform the following actions:

  # data.oci_core_vnic.FoggyKitchenBackendserver1_VNIC1 will be read during apply
  # (config refers to values not yet known)
 <= data "oci_core_vnic" "FoggyKitchenBackendserver1_VNIC1"  {

(...)

  # oci_load_balancer_listener.FoggyKitchenPublicLoadBalancerListener will be created
  + resource "oci_load_balancer_listener" "FoggyKitchenPublicLoadBalancerListener" {
      + default_backend_set_name = "FoggyKitchenPublicLBBackendset"
      + hostname_names           = (known after apply)
      + id                       = (known after apply)
      + load_balancer_id         = (known after apply)
      + name                     = "FoggyKitchenPublicLoadBalancerListener"
      + path_route_set_name      = (known after apply)
      + port                     = 80
      + protocol                 = "HTTP"
      + rule_set_names           = (known after apply)
      + state                    = (known after apply)

      + connection_configuration {
          + idle_timeout_in_seconds = (known after apply)
        }
    }

Plan: 49 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

(...)
oci_identity_compartment.ExternalCompartment: Creating...
oci_identity_compartment.FoggyKitchenCompartment: Creating...
oci_identity_compartment.ExternalCompartment: Creation complete after 2s [id=ocid1.compartment.oc1..aaaaaaaatanq4gogyxvneubmw3nf6gmegvzyh6ylqq4c3u2i3nc36jhdemda]
oci_identity_compartment.FoggyKitchenCompartment: Creation complete after 2s [id=ocid1.compartment.oc1..aaaaaaaagillnk7ttj6wpdhmewpibpxc5gbmrfxdtmaa3gfgjzbudesm3tsq]
oci_identity_policy.FoggyKitchenLPGPolicy1: Creating...

(...)

oci_database_db_system.FoggyKitchenDBSystem: Still creating... [21m11s elapsed]
oci_database_db_system.FoggyKitchenDBSystem: Still creating... [21m21s elapsed]
oci_database_db_system.FoggyKitchenDBSystem: Still creating... [21m31s elapsed]
oci_database_db_system.FoggyKitchenDBSystem: Still creating... [21m41s elapsed]
oci_database_db_system.FoggyKitchenDBSystem: Still creating... [21m51s elapsed]
oci_database_db_system.FoggyKitchenDBSystem: Still creating... [22m1s elapsed]

(...)

oci_database_db_system.FoggyKitchenDBSystem: Modifications complete after 2m8s [id=ocid1.dbsystem.oc1.eu-frankfurt-1.abtheljrbanqwij36gqnj7eya3yvkilc5ieflw3ukh6hkwtbuj7oeuaylx6a]
data.oci_database_db_nodes.DBNodeList: Refreshing state...
data.oci_database_db_node.DBNodeDetails: Refreshing state...
data.oci_core_vnic.FoggyKitchenDBSystem_VNIC1: Refreshing state...

Apply complete! Resources: 49 added, 0 changed, 0 destroyed.

Outputs:

FoggyKitchenBackendserver1_PrivateIP = [
  "192.168.1.2",
]
FoggyKitchenBastionServer_PublicIP = [
  "130.61.57.119",
]
FoggyKitchenDBServer_PrivateIP = [
  "10.0.4.2",
]
FoggyKitchenPublicLoadBalancer_Public_IP = [
  [
    "132.145.242.177",
  ],
]
FoggyKitchenWebserver1_PrivateIP = [
  "10.0.2.2",
]
FoggyKitchenWebserver2_PrivateIP = [
  "10.0.2.3",
]
```

### STEP 6.

After testing the environment you can remove the lesson's content. You should just run *terraform destroy* (type **yes** for confirmation of the destroy phase):

```
$ terraform destroy

oci_identity_compartment.FoggyKitchenCompartment: Refreshing state... [id=ocid1.compartment.oc1..aaaaaaaagillnk7ttj6wpdhmewpibpxc5gbmrfxdtmaa3gfgjzbudesm3tsq]
oci_identity_compartment.ExternalCompartment: Refreshing state... [id=ocid1.compartment.oc1..aaaaaaaatanq4gogyxvneubmw3nf6gmegvzyh6ylqq4c3u2i3nc36jhdemda]
oci_file_storage_file_system.FoggyKitchenFilesystem: Refreshing state... [id=ocid1.filesystem.oc1.eu_frankfurt_1.aaaaaaaaaaabenqnmzzgcllqojxwiotfouwwm4tbnzvwm5lsoqwtcllbmqwtcaaa]
(...)
Plan: 0 to add, 0 to change, 49 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

null_resource.FoggyKitchenWebserver1_oci_u01_fstab: Destroying... [id=3529939257266357221]
null_resource.FoggyKitchenWebserver2SharedFilesystem: Destroying... [id=95791244474403118]
null_resource.FoggyKitchenWebserver1SharedFilesystem: Destroying... [id=4614169576253275506]
null_resource.FoggyKitchenWebserver2SharedFilesystem: Destruction complete after 0s
null_resource.FoggyKitchenWebserver1SharedFilesystem: Destruction complete after 0s

(...)

oci_core_virtual_network.FoggyKitchenVCN: Destroying... [id=ocid1.vcn.oc1.eu-frankfurt-1.aaaaaaaajyphwxm26aqbfzd4er4u7wkqetcasmxv4izm7cvqu6jdvztj2cpa]
oci_core_local_peering_gateway.FoggyKitchenLPG2: Destruction complete after 0s
oci_core_virtual_network.FoggyKitchenVCN2: Destroying... [id=ocid1.vcn.oc1.eu-frankfurt-1.aaaaaaaaqwjipowxnpyyo37skinezkhbxs7t3fsaeo4gfhaydkzjajuhvdmq]
oci_core_virtual_network.FoggyKitchenVCN: Destruction complete after 0s
oci_core_virtual_network.FoggyKitchenVCN2: Destruction complete after 1s
oci_identity_policy.FoggyKitchenLPGPolicy2: Destroying... [id=ocid1.policy.oc1..aaaaaaaaewh6rmehovenbdluf3qhm6tafb3qsdefqphujvpgocsnsbhlifca]
oci_identity_policy.FoggyKitchenLPGPolicy2: Destruction complete after 0s
oci_identity_compartment.FoggyKitchenCompartment: Destroying... [id=ocid1.compartment.oc1..aaaaaaaagillnk7ttj6wpdhmewpibpxc5gbmrfxdtmaa3gfgjzbudesm3tsq]
oci_identity_compartment.ExternalCompartment: Destroying... [id=ocid1.compartment.oc1..aaaaaaaatanq4gogyxvneubmw3nf6gmegvzyh6ylqq4c3u2i3nc36jhdemda]
oci_identity_compartment.FoggyKitchenCompartment: Destruction complete after 0s
oci_identity_compartment.ExternalCompartment: Destruction complete after 0s

Destroy complete! Resources: 49 destroyed.

```

## Description and Topology diagrams for each lesson

### LESSON 1 - Single Webserver

In this lesson we will create the simplest set of OCI resources, starting with one compartment, one VCN and one subnet in this VCN. The subnet will be regional (covering all availability domains AD1-AD3). Inside this public subnet, we will nest one VM for WebServer. Public subnet means that VM will have public IP associated - VM will be exposed to the public Internet (via Internet Gateway and proper route table). After this deployment, one basic Security List will permit access from the public Internet to VM via protocol SSH (port 22) & HTTP/HTTPS protocols (port 80, 443). For the software provisioning we will utilize null_resource and remote-exec capability of Terraform *Null Provider* - Terraform will install HTTP server with root webpage content. As a consequence, after successful terraform apply, we should be able to visit VM public IP address with our web browser and expect their simple webpage content - **Welcome to FoggyKitchen.com! This is WEBSERVER1...**.

![](LESSON1_single_webserver/LESSON1_single_webserver.jpg)

### LESSON 2 - Second Webserver in other Availability Domain (AD)

In this lesson, we will add the second VM in another AD in the same VCN and regional subnet. Inside this new VM again *Null Provider* will be used to configure yet another webserver with the simple webpage content, but this time it will be showing content as follows: **Welcome to FoggyKitchen.com! This is WEBSERVER2...**. After this lesson, you can use public IP addresses of both VMs to access two different web pages. Wouldn't it be great to have some load balancer on top of that and hide both web servers under the load balancer umbrella?

![](LESSON2_second_webserver_in_other_AD/LESSON2_second_webserver_in_other_AD.jpg)

### LESSON 2a - Second Webserver in other Fault Domain (FD)

In this lesson, we will deploy the infrastructure in OCI region where only one Availablity Domain (AD) has been delivered. It means we will deploy webservers in the same AD, but in different Fault Domains (FD). The rest of the configuration is the same as in the original lesson 2.

![](LESSON2a_second_webserver_in_another_FD/LESSON2a_second_webserver_in_another_FD.jpg)


### LESSON 3 - Load Balancer

In this lesson, we will introduce the OCI Public Load Balancer. Load Balancer's Listener entity will be visible on the Internet, which means you will have an additional public IP address. On the other hand Load Balancer's Backendset with Backends will be associated with both Webserver VMs. The outcome of this training is very simple. You can access web servers via the Load Balancer. Reload webpage a couple of times and you should expect index.html page to be different depends on what web server has been chosen by the Load Balancer. There is only one drawback of this configuration. Webservers are still visible with their public IPs. Wouldn't it be great to hide them? 

![](LESSON3_load_balancer/LESSON3_load_balancer.jpg)

### LESSON 4 - Load Balancer + NAT Gateway + Bastion Host

In this lesson we will create brand new regional subnets inside current VCN: **(1)** dedicated Load Balancer public subnet and **(2)** special dedicated subnet for Bastion Host which will enable access to private/non-public resources. The first subnet which has been created in the previous lessons will be still used to nest webserver VMs there. But this time VMs will not receive public IPs during deployment phase (*assign_public_ip = false*). Since that moment we can treat them as nested in private subnet (they are not public). In that case previously used Internet Gateway will not be sufficient and we need to create NATGateway entity and route traffic there (*RouteTableViaNAT*). As VMs are not visible directly from the Internet with public IPs, to access them with SSH protocol, we need to jump via bastion host. This reconfiguration should have a reflection on the usage of *Null Provider*. In practice, remote exec will use the connection with webserver VMs via bastion host. Last but not least we also need to change Security Lists. Now Load Balancer and Web server Subnets will be bound with HTTP/HTTPS Security List. Webserver and Bastion host subnets will be bound with SSH Security List.  

![](LESSON4_load_balancer_NAT_bastion/LESSON4_load_balancer_NAT_bastion.jpg)

### LESSON 4a - Load Balancer + NAT Gateway + Bastion Host (+ Network Security Groups) 

In this lesson, we will explore a new approach to security in OCI. Instead of using Security Lists which were previously bound to subnet level, this time we will create Network Security Groups (NGS) with Network Security Roles. Each NGS will be then bound to each VM's virtual network interface (VNIC) and Load Balancer directly (not via LB subnet). It makes OCI security more granular. This is an optional lesson, just to explore new security concepts in OCI. Keep in mind that further lessons will be fully based on the previously implemented Security List concept. 

![](LESSON4a_load_balancer_NAT_bastion_security_groups/LESSON4a_load_balancer_NAT_bastion_security_groups.jpg)

### LESSON 5 - Shared Filesystem 

In this lesson, we will modify the configuration a little bit. It means we will create the shared filesystem (*File Storage Mount Target*) which will be mounted as NFS over both Webservers (/sharedfs mount point). Into that share storage we will upload index.html file with new content: **Welcome to FoggyKitchen.com! These are both WEBSERVERS under LB umbrella with shared index.html ...**. Next *Null Resources* will modify /etc/httpd/conf/httpd.conf to include alias and directory of shared resource. Load Balancer will be modified as little bit as well. Now Backend Health Check will check URL /shared every 3000 ms. After successful *terraform apply* we should go to Web Browser and check URL: *http://public_ip_of_load_balancer/shared/*. 

![](LESSON5_shared_filesystem/LESSON5_shared_filesystem.jpg)

### LESSON 5a - Shared Filesystem (+ Network Security Groups) 

In this lesson, we will modify the configuration a little bit. Shared filesystem will be moved to additonal
subnet and NSG will be used instead of SecurityList. This is not obligatory lesson, but it good to understand how to make your configuration more secured.

![](LESSON5a_shared_filesystem_security_groups/LESSON5a_shared_filesystem_security_groups.jpg)

### LESSON 6 - Local Block Volume

In this lesson, we will add only one additional OCI resource. It will be 100G block volume (*oci_core_volume*), which will be then associated with the first web server VM. With the usage of *Null Provider* we will execute the script to discover iscsi disk on Webserver1, configure partition there, format as ext4 filesystem and finally mount it as /u01 (entries added to /etc/fstab). This kind of block volume can be used for example for installation of Glassfish or any other Application Container software which requires a lot of space. 

![](LESSON6_local_block_volumes/LESSON6_local_block_volumes.jpg)

### LESSON 7 - DBSystem

In this lesson, we will introduce the database component which is based on additional region private subnet for OCI DBSystem (*oci_database_db_system*). All necessary variables required to setup DBSystem have been added to variables.tf file. We have to also create additional Security List for SQLNet protocol and this Security List has been bound to this new private database subnet. DBSystem provisioning is based on one VM and Standard Edition of 12.1 RDBMS. With this OCI PaaS offering included in Terraform automation, you can expect to have a longer break in work. DBSystem use to be provisioned in 1 hour, so one or two coffees will be needed :)

![](LESSON7_dbsystem/LESSON7_dbsystem.jpg)

### LESSON 7a - DBSystem with DataGuard

In this lesson, we will introduce the OCI DBSystem DataGuard association. It will provide standby database in additional DBSystem located in a different AD comparing to primary database. This setup is for DR purposes.
Another aspect is a switch from security lists to NSG, now also on DBSystem level.

![](LESSON7a_dbsystem_with_dataguard/LESSON7a_dbsystem_with_dataguard.jpg)

### LESSON 8 - VCN local peering

This lesson is the most complex so far. Besides the current pair of Compartment and VCN we would like to setup up a completely separated island. It will be a new Compartment there called *ExternalCompartment*. It this compartment we will create brand new VCN (*FoggyKitchenVCN2*) with completely different CIDR (192.168.0.0/16). Inside this VCN we will create a new regional private subnet and the Backend server will be nested there. So far this is the isolated island from original cloud infrastructure, so to interconnect them we need to create local peering with LPGs. Finally, we need to apply LPG policies there. If everything goes good we should be able to access Backend Server from Database server with SSH protocol. Let's roll with *terraform apply*.


![](LESSON8_vcn_local_peering/LESSON8_vcn_local_peering.jpg)

### LESSON 9 - VCN remote peering

In this lesson I will move *FoggyKitchenVCN2* content, including subnet and BackendServer to another region (eu-amsterdam-1). In this case I need to build Dynamic Routing Gateways (DRGs) for both VCNs and interconnect them with Remote Peering Connections (RPCs). I also need to establish some additional policies to let this interconnection work. From functional perspective cross-region connection will work as the local one from the lesson 8. We will be able to access Backend server with SSH from DBSystem server and additonally from webservers.


![](LESSON9_vcn_remote_peering/LESSON9_vcn_remote_peering.jpg)

### LESSON 10 - Transit VCN

This lesson will be based on Lesson9. VCN2 located in another region (eu-amsterdam-1) will be transformed into *Hub VCN*. Additionally we will create two *Spoke VCNs* in this region. *Spoke VCNs* will be interconnected with this *Hub VCN* with the usage of LPGs (local VCN peering). In the code we will also add two route tables: (1) on DRG attach and (2) on *Hub VCN* LPGs' side. As a consequence it will be possible to start connection from departamental servers located in a *Spoke VCNs / Spoke subnets* to the infrastructure in the first original region (eu-frankfurt-1). It means *Hub VCN* will play a role of Transit Routing VCN for *Spoke VCNs*.

![](LESSON10_transit_vcn/LESSON10_transit_vcn.jpg) 
