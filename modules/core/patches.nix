{ lib, ... }:
{
  boot.kernelPatches = [
    /*
      {
        name = "optimized-kernel-config";
        patch = null;
        structuredExtraConfig = with lib.kernel; {
          ## ==== ARCHITECTURES ====
          ARC = no;
          ARM = no;
          ARM64 = no;
          ALPHA = no;
          CSKY = no;
          H8300 = no;
          HEXAGON = no;
          IA64 = no;
          M68K = no;
          MICROBLAZE = no;
          MIPS = no;
          MN10300 = no;
          NDS32 = no;
          NDS32_64 = no;
          OPENRISC = no;
          PARISC = no;
          PPC = no;
          RISCV = no;
          S390 = no;
          SH = no;
          SPARC = no;
          UNICORE32 = no;
          XTENSA = no;

          ## ==== GPU / FRAMEBUFFER (non-AMD, non-Generic) ====
          DRM_I810 = no;
          DRM_I915 = no;
          DRM_AST = no;
          DRM_CIRRUS_QEMU = no;
          DRM_GMA500 = no;
          DRM_MGA = no;
          DRM_NOUVEAU = no;
          DRM_QXL = no;
          DRM_R128 = no;
          DRM_SAVAGE = no;
          DRM_SIS = no;
          DRM_VGEM = no;
          DRM_VMWGFX = no;
          FB_CIRRUS = no;
          FB_MATROX = no;
          FB_SAVAGE = no;
          FB_SIS = no;
          FB_VGA16 = no;
          FB_VESA = no;

          ## ==== FILESYSTEMS ====
          AFFS_FS = no;
          AFS_FS = no;
          BEFS_FS = no;
          BFS_FS = no;
          CRAMFS_FS = no;
          CODA_FS = no;
          ECRYPT_FS = no;
          EFS_FS = no;
          EXOFS_FS = no;
          F2FS_FS = no;
          GFS2_FS = no;
          HPFS_FS = no;
          HFS_FS = no;
          HFSPLUS_FS = no;
          JFS_FS = no;
          MINIX_FS = no;
          NCP_FS = no;
          NFS_FS = no;
          NILFS2_FS = no;
          NTFS_FS = no;
          OCFS2_FS = no;
          OMFS_FS = no;
          QNX4_FS = no;
          QNX6_FS = no;
          ROMFS_FS = no;
          SYSV_FS = no;
          UDF_FS = no;
          UFS_FS = no;
          UBIFS_FS = no;
          VXFS_FS = no;
          XFS_FS = no;

          ## ==== BUS / IO / HOTPLUG ====
          EISA = no;
          ISA = no;
          PCMCIA = no;
          HOTPLUG_PCI = no;
          IEEE1394 = no;
          FIREWIRE = no;
          VME_BUS = no;
          RAPIDIO = no;
          NTB = no;

          ## ==== STORAGE CONTROLLERS (legacy / enterprise) ====
          SCSI_LOWLEVEL = no;
          ATA_PIIX = no;
          ATA_SFF = no;
          ATA_BMDMA = no;
          ATA_GENERIC = no;
          ATA_PATA_LEGACY = no;
          IDE = no;
          MTD = no;
          MMC = no;
          NVME_FC = no;
          NVME_TCP = no;
          NVME_TARGET = no;

          ## ==== NETWORK HARDWARE (non-USB, non-Wi-Fi) ====
          INFINIBAND = no;
          ATM = no;
          TOKENRING = no;
          HIPPI = no;
          FDDI = no;
          NET_VENDOR_3COM = no;
          NET_VENDOR_ADAPTEC = no;
          NET_VENDOR_ALTEON = no;
          NET_VENDOR_AMD = no;
          NET_VENDOR_ATHEROS = no;
          NET_VENDOR_BROADCOM = no;
          NET_VENDOR_BROCADE = no;
          NET_VENDOR_CHELSIO = no;
          NET_VENDOR_CISCO = no;
          NET_VENDOR_DEC = no;
          NET_VENDOR_DLINK = no;
          NET_VENDOR_EMULEX = no;
          NET_VENDOR_FUJITSU = no;
          NET_VENDOR_HUAWEI = no;
          NET_VENDOR_MARVELL = no;
          NET_VENDOR_MICROCHIP = no;
          NET_VENDOR_MYRI = no;
          NET_VENDOR_NVIDIA = no;
          NET_VENDOR_OKI = no;
          NET_VENDOR_QLOGIC = no;
          NET_VENDOR_SILAN = no;
          NET_VENDOR_SIS = no;
          NET_VENDOR_TI = no;
          NET_VENDOR_VIA = no;
          NET_VENDOR_WIZNET = no;

          ## ==== SOUND / AUDIO ====
          SND_PCSP = no;
          SND_FIREWIRE = no;
          SND_USB_CAIAQ = no;
          SND_PCMCIA = no;
          SOUNDWIRE = no;

          ## ==== INPUT DEVICES (legacy) ====
          INPUT_TOUCHSCREEN = no;
          INPUT_TABLET = no;
          SERIO = no;
          GAMEPORT = no;
          JOYSTICK_IFORCE = no;
          JOYSTICK_WARRIOR = no;
          JOYSTICK_SPACEORB = no;
          JOYSTICK_SPACEBALL = no;
          JOYSTICK_MAGELLAN = no;
          JOYSTICK_GRIP = no;
          JOYSTICK_GRIP_MP = no;

          ## ==== HID (unused exotic devices) ====
          HID_A4TECH = no;
          HID_APPLE = no;
          HID_BELKIN = no;
          HID_CHERRY = no;
          HID_CHICONY = no;
          HID_CYPRESS = no;
          HID_EZKEY = no;
          HID_GYRATION = no;
          HID_ITE = no;
          HID_KENSINGTON = no;
          HID_LOGITECH = no;
          HID_LOGITECH_DJ = no;
          HID_MICROSOFT = no;
          HID_MONTEREY = no;
          HID_PETALYNX = no;
          HID_PLANTRONICS = no;
          HID_SAITEK = no;
          HID_SAMSUNG = no;
          HID_THRUSTMASTER = no;
          HID_TWINHAN = no;
          HID_WACOM = no;
          HID_ZEROPLUS = no;

          ## ==== VIRTUALIZATION / CLOUD ====
          HYPERV = no;
          KVM_GUEST = no;
          XEN = no;
          VBOXGUEST = no;
          PARAVIRT = no;
          PARAVIRT_TIME_ACCOUNTING = no;

          ## ==== POWER / BATTERY / EMBEDDED ====
          APM = no;
          APCI_DEBUG = no;
          PM_TRACE = no;
          PM_ADVANCED_DEBUG = no;
          INTEL_IDLE = no;
          INTEL_SPEED_SELECT = no;
          INTEL_RST = no;
          INTEL_MEI = no;
          INTEL_TURBO_MAX = no;
          INTEL_PSTATE = no;
          CPU_FREQ_GOV_CONSERVATIVE = no;
          CPU_FREQ_GOV_POWERSAVE = no;

          ## ==== DEBUG / PROFILING ====
          DEBUG_INFO = no;
          DEBUG_KERNEL = no;
          DEBUG_MISC = no;
          DEBUG_MEMORY = no;
          DEBUG_PAGEALLOC = no;
          DEBUG_PER_CPU_MAPS = no;
          DEBUG_ATOMIC_SLEEP = no;
          KASAN = no;
          KMSAN = no;
          UBSAN = no;
          GCOV_KERNEL = no;
          KCOV = no;
          LOCKDEP = no;
          LATENCYTOP = no;
          KMEMCHECK = no;
          KGDB = no;
          BOOTPARAM_HUNG_TASK_PANIC = no;
          BOOTPARAM_HUNG_TASK = no;

          ## ==== SECURITY / SANDBOX ====
          SECURITY_SELINUX = no;
          SECURITY_SMACK = no;
          SECURITY_TOMOYO = no;
          SECURITY_APPARMOR = no;
          SECURITY_LOCKDOWN_LSM = no;
          SECURITY_YAMA = no;
          INTEGRITY = no;
          IMA = no;
          EVM = no;

          ## ==== MISC ARCH OPTIONS ====
          ARCH_HAS_DEBUG_VM_PGTABLE = no;
          ARCH_HAS_DEBUG_VIRTUAL = no;
          ARCH_HAS_UNCACHED_SEGMENT = no;
          ARCH_ENABLE_MEMORY_HOTREMOVE = no;
        };
      }
    */
  ];
}
