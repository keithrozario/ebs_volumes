resource "aws_ssm_document" "mount_volumes" {
  name          = "mount_volumes_to_ec2"
  document_type = "Command"

  content = <<DOC
  {
    "schemaVersion": "1.2",
    "description": "Mount Volumes in Instance",
    "parameters": {

    },
    "runtimeConfig": {
      "aws:runShellScript": {
        "properties": [
          {
            "id": "0.aws:runShellScript",
            "runCommand": [
                "sudo mdadm --create --verbose /dev/md0 --level=0 --name=MY_RAID --raid-devices=5 /dev/sdf /dev/sdg /dev/sdh /dev/sdi /dev/sdj",
                "sleep 10",
                "sudo yum install fio -y",
                "sudo mkfs.ext4 -L MY_RAID /dev/md0",
                "sudo mdadm --detail --scan | sudo tee -a /etc/mdadm.conf",
                "sudo dracut -H -f /boot/initramfs-$(uname -r).img $(uname -r)",
                "sudo mkdir -p /mnt/raid",
                "sudo mount LABEL=MY_RAID /mnt/raid"
            ]
          }
        ]
      }
    }
  }
DOC
}

resource "aws_ssm_association" "mount_volumes" {
  depends_on = [aws_volume_attachment.this]
  name       = aws_ssm_document.mount_volumes.name

  targets {
    key    = "InstanceIds"
    values = [aws_instance.this.id]
  }
}