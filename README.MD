# EBS Volume Test

Simple Terraform script to deploy an EC2 with 5 EBS Volumes attached to test RAID-0 speeds.

The script deploys:
* An EC2 instance in a private subnet (with a NAT Gateway), and enables login via System Manager - Session Manager to the instance. 
* EC2 instance will use the latest x86 Amazon Linux 2 AMI
* 5 EBS volumes at the specified iops/type
* Attaches the EBS volumes to the EC2 instance
* Executes a System Manager - Run Command automation to setup RAID-0 and mounts the volumes to `/mnt/raid`.

## Modifications

To modify the instance type, ebs type (gp3 vs. io2), ebs iops, change the values in `variables.tf` and run `terraform apply` again.

## Warning

Script by default deploys r5n.16xlarge with five 32GB EBS volumes. None of these are free-tier, and will cost you money. Run with care, and remember to `tf destroy` when you're done.


## Steps

On your local machine:

    $ git clone https://github.com/keithrozario/ebs_volumes
    $ cd ebs_volumes
    $ tf apply --auto-approve

* logon to the AWS console, and go to System Manager -> Session Manager
* Select EBSTesting

Now on the console of System Manager, (replace N with the number of cores on the machine)

    $ for i in `seq 1 $((N-1))`; do cpupower idle-set -d $i; done
    $ sudo fio --directory=/mnt/raid --name fio_test_file --direct=1 --rw=randrw --bs=16k --size=1G --numjobs=16 --time_based --runtime=180 --group_reporting --norandommap --iodepth=50

You can run more test with fio (that's installed onto the machine)