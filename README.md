# **PracticaLAMP**
En este proyecto crearemos una configuración LAMP con dos máquinas: una para Apache y otra para MySQL. Cada una tendrá una IP estática en una red privada, y la máquina Apache también tendrá salida a Internet. El propósito es usar Vagrant para configurar y desplegar un entorno LAMP (Linux, Apache, MySQL, PHP) distribuido, simulando un entorno de producción mediante la separación del servidor web y la base de datos.

# **Vagrantfile**
Este bloque de código en Vagrant configura dos máquinas virtuales con Ubuntu. La primera máquina, AntonioZancadaApache, tiene un nombre de host definido, redireccionamiento de puertos para acceso a través del puerto 8080 en la máquina anfitriona, una red privada con una IP estática 192.168.55.1, y conexión a la red pública. Además, se ejecuta un script de aprovisionamiento provapache.sh para configurarla. La segunda máquina, AntonioZancadaMysql, se configura con un nombre de host, una red privada con la IP 192.168.55.2, y se ejecuta un script de aprovisionamiento provmysql.sh para instalar y configurar MySQL. En resumen, este Vagrantfile establece un entorno LAMP distribuido, separando las funciones del servidor web y la base de datos en máquinas virtuales distintas. 

![imagenVagrantfile](https://github.com/user-attachments/assets/5eb8d062-c53b-4fc7-9d63-119c81ffa68c)

### **Aprovisionamiento apache: provapache.sh**
Aquí se instala Apache, PHP, MySQL y Git en una máquina, clona un repositorio desde GitHub y mueve los archivos necesarios a un directorio específico. Luego, configura los permisos y ajusta la configuración de Apache para apuntar al nuevo directorio de la aplicación. Finalmente, recarga Apache para aplicar los cambios y crea un archivo de configuración PHP con los detalles de la conexión a la base de datos.

## Configuración del entorno LAMP
```bash
### Actualiza la lista de paquetes disponibles y sus versiones.
* sudo apt-get update

### Instala Apache, PHP, los módulos de PHP para Apache, el soporte PHP para MySQL y Git, todo de una vez.
* sudo apt-get install -y apache2 php libapache2-mod-php php-mysql git



