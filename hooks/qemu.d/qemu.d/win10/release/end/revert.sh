set -x

source "/etc/libvirt/hooks/kvm.conf"

modprobe -r vfio_pci
modprobe -r vfio_iommu_type1
modprobe -r vfio

virsh nodedev-reattach $VIRSH_GPU_VIDEO
virsh nodedev-reattach $VIRSH_GPU_AUDIO
virsh nodedev-reattach $VIRSH_GPU_USB
virsh nodedev-reattach $VIRSH_GPU_SERIAL

echo 1 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind

nvidia-smi  > /dev/null 2>&1

echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind

modprobe nvidia_drum
modprobe nvidia_modeset
modprobe drm_kms_helper
modprobe nvidia-dkms
modprobe drm
modprobe nvidia_uvm
modprobe i2c_nvidia_gpu

systemctl start lightdm.service
