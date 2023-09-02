# Terraform primeros pasos
## Introducción

Este repositorio contiene el código y los pasos para dar los primeros pasos en Terraform. 

Esto es parte de una sesión en vivo que se hace via stream en mi canal de [youtube](https://youtube.com/@daveops) 

## Requisitos
- docker

## Pasos
1. Clonar el repositorio

2. Instalar localstack para poder aprender de forma local

### Linux
```bash
sudo tar xvzf ~/Downloads/localstack-cli-2.2.0-linux-*-onefile.tar.gz -C /usr/local/bin
```

Mas info acá: https://docs.localstack.cloud/getting-started/installation/

3. Iniciar localstack
```bash
localstack start
```

4. Instalar tfenv
```bash
git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv

echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_profile
```

5. Instalar terraform
```bash
tfenv install latest
```

6. Iniciar el proyecto
```bash 
terraform init
```

y Listo! Ya tenes todo listo para empezar a aprender Terraform

## Comandos útiles
- ``terraform init`` # Inicializa el proyecto
- ``terraform plan`` # Muestra los cambios que se van a hacer
- ``terraform apply`` # Aplica los cambios
- ``terraform destroy`` # Destruye los recursos creados
- `` terraform fmt`` # Formatea el código
- ``terraform validate`` # Valida el código
