# Default is 'debian'
Project = string(default=None)

CodeName = string(min=1, max=50) 

DebianInstallerCodeName = string(default=None)

DebVersion = float(min=0)

Official = boolean()

# The minimalist url could be this: ftp://a, (seven characters)
Mirror = string(min=7)

ExtraMirrors = string_list(default=None)

Components = string_list(default=None)

TDir = directory()

# Default value is TDir/out
Out = directory(default=None)

# Deafult value is False
Force = boolean(default=False)

# Default value is False
ForceNonUsOnCD1 = boolean(default=False)

# Default value is TDir/apt
AptTmp = directory(default=None)

# The default value is the current architecture. So, in the python code, if arch is None set the current arch.
Arch = arch(default=None)

#MultiArch = string_list(min=2, default=None)
MultiArch = arch_list(default=None)

# DiskInfo 
DiskInfo = string(default=None)

KernelParams = string(default=None)

# Default value is $(dig_path)/data/distro/sarge/$(arch)_udeb_include
UdebInclude = string(default = None)

# Default value is $(dig_path)/data/distro/sarge/exclude_udebs
UdebExclude = string(default = None)

BaseInclude = string(default = None)

BaseExclude = string(default = None)

InstallerCd = integer(0, 2, default=0)

Devel = boolean(default=False)

MediaType = option('cd', 'cd700', 'cd800', 'dvd', default='cd')
