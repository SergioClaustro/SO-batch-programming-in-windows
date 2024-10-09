#!/bin/bash

# Verificar si se proporcionaron suficientes argumentos
if [ "$#" -lt 7 ]; then
    echo "Uso: $0 <nombre_vm> <tipo_os> <num_cpus> <ram_gb> <vram_mb> <disco_duro_gb> <controlador_sata> <controlador_ide>"
    exit 1
fi

# Recibir los argumentos desde la línea de comandos
NOMBRE_VM=$1
TIPO_OS=$2
NUM_CPUS=$3
RAM_GB=$4
VRAM_MB=$5
DISCO_DURO_GB=$6
CONTROLADOR_SATA=$7
CONTROLADOR_IDE=$8

# Convertir la memoria y el disco duro a MB para VBoxManage
RAM_MB=$((RAM_GB * 1024))
DISCO_DURO_MB=$((DISCO_DURO_GB * 1024))

# Crear la máquina virtual
VBoxManage createvm --name "$NOMBRE_VM" --ostype "$TIPO_OS" --register

# Configurar CPUs, RAM y VRAM
VBoxManage modifyvm "$NOMBRE_VM" --cpus "$NUM_CPUS" --memory "$RAM_MB" --vram "$VRAM_MB"

# Crear y asociar un disco duro virtual
DISK_PATH="$HOME/VirtualBox VMs/$NOMBRE_VM/$NOMBRE_VM.vdi"
VBoxManage createhd --filename "$DISK_PATH" --size "$DISCO_DURO_MB"

# Crear un controlador SATA y asociarlo al disco duro
VBoxManage storagectl "$NOMBRE_VM" --name "$CONTROLADOR_SATA" --add sata --controller IntelAhci
VBoxManage storageattach "$NOMBRE_VM" --storagectl "$CONTROLADOR_SATA" --port 0 --device 0 --type hdd --medium "$DISK_PATH"

# Crear un controlador IDE para CD/DVD
VBoxManage storagectl "$NOMBRE_VM" --name "$CONTROLADOR_IDE" --add ide --controller PIIX4
VBoxManage storageattach "$NOMBRE_VM" --storagectl "$CONTROLADOR_IDE" --port 0 --device 0 --type dvddrive --medium emptydrive

# Mostrar la configuración de la máquina virtual
VBoxManage showvminfo "$NOMBRE_VM"
