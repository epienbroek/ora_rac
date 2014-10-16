# == Class: ora_rac::config
#
# The purpose of this class is to configure the basic storage requirements
# for RAC. It creates the partitions and formats them according to needs. This
# is just an example class for getting it running in Vagrant. You need to make
# your own config class..
#
# === Parameters
#
#   none
#
# === Variables
#
# === Authors
#
# Bert Hajee <hajee@moretIA.com>
#
class ora_rac::config inherits ora_rac::params
{

  $devices = [
    '/dev/sda',
    '/dev/sdb',
    '/dev/sdc',
    '/dev/sdd',
    '/dev/sde',
    '/dev/sdf',
    '/dev/sdg',
    ]

  partition_table{$devices:
    ensure  => 'gpt',
  }

  $partitions = $devices.map |$d| {"${d}:1"}

  partition{$partitions:
    ensure    => present,
    part_name => 'primary',
    start     => '1049kB',
    end       => '4294MB',
    require   => Partition_table[$devices],
  }

  ora_rac::asm_disk{'/dev/sda1':
    volume  => 'CRSVOL1',
    require => Partition[$partitions],
  }

  ora_rac::asm_disk{'/dev/sdb1':
    volume  => 'CRSVOL2',
    require => Partition[$partitions],
  }

  ora_rac::asm_disk{'/dev/sdc1':
    volume  => 'CRSVOL3',
    require => Partition[$partitions],
  }

  ora_rac::asm_disk{'/dev/sdd1':
    volume  => 'REDOVOL1',
    require => Partition[$partitions],
  }

  ora_rac::asm_disk{'/dev/sde1':
    volume  => 'REDOVOL2',
    require => Partition[$partitions],
  }

  ora_rac::asm_disk{'/dev/sdf1':
    volume  => 'DATAVOL1',
    require => Partition[$partitions],
  }

  ora_rac::asm_disk{'/dev/sdg1':
    volume  => 'DATAVOL2',
    require => Partition[$partitions],
  }

}