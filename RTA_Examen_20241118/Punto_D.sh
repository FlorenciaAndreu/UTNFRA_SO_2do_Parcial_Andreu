#!/bin/bash

# Variables
BASE_DIR="<Path-Repo>/202406/ansible"
ROLE_NAME="setup_parcial"
TEMPLATES_DIR="$BASE_DIR/roles/$ROLE_NAME/templates"
TASKS_DIR="$BASE_DIR/roles/$ROLE_NAME/tasks"
VARS_DIR="$BASE_DIR/roles/$ROLE_NAME/vars"

# Crear la estructura del role
echo "Creando la estructura del role..."
mkdir -p $BASE_DIR/roles/$ROLE_NAME/{tasks,templates,files,vars}

# Crear archivo de tareas principales
echo "Creando archivo de tareas principales..."
cat <<EOF > $TASKS_DIR/main.yml
---
# Generar los templates en sus ubicaciones respectivas
- name: Generar archivo de datos del alumno
  template:
    src: datos_alumno.txt.j2
    dest: /tmp/2do_parcial/alumno/datos_alumno.txt

- name: Generar archivo de datos del equipo
  template:
    src: datos_equipo.txt.j2
    dest: /tmp/2do_parcial/equipo/datos_equipo.txt

# Configurar sudoers para el grupo 2PSupervisores
- name: Configurar sudoers para 2PSupervisores
  lineinfile:
    path: /etc/sudoers
    state: present
    line: "%2PSupervisores ALL=(ALL) NOPASSWD:ALL"
    validate: "visudo -cf %s"
EOF

# Crear templates
echo "Creando templates..."
cat <<EOF > $TEMPLATES_DIR/datos_alumno.txt.j2
Nombre: Florencia Belen
Apellido: Andreu
Division: 115
EOF

cat <<EOF > $TEMPLATES_DIR/datos_equipo.txt.j2
Equipo: {{ equipo_nombre }}
Sistema Operativo: {{ ansible_distribution }} {{ ansible_distribution_version }}
Fecha: {{ ansible_date_time.date }}
EOF

# Crear archivo de variables
echo "Creando archivo de variables..."
cat <<EOF > $VARS_DIR/main.yml
alumno_nombre: "Florencia Belen"
alumno_apellido: "Andreu"
equipo_nombre: "Ubuntu"
EOF

# Crear playbook principal
echo "Creando playbook principal..."
cat <<EOF > $BASE_DIR/main.yml
---
- hosts: localhost
  become: yes
  roles:
    - $ROLE_NAME
EOF

# Ejecutar el playbook
echo "Ejecutando el playbook..."
cd $BASE_DIR
ansible-playbook main.yml

echo "Punto D completado."

