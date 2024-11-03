# **PracticaLAMP**
En este proyecto crearemos una configuración LAMP con dos máquinas: una para Apache y otra para MySQL. Cada una tendrá una IP estática en una red privada, y la máquina Apache también tendrá salida a Internet. El propósito es usar Vagrant para configurar y desplegar un entorno LAMP (Linux, Apache, MySQL, PHP) distribuido, simulando un entorno de producción mediante la separación del servidor web y la base de datos.

# **Vagrantfile**
Este bloque de código en Vagrant configura dos máquinas virtuales con Ubuntu. La primera máquina, AntonioZancadaApache, tiene un nombre de host definido, redireccionamiento de puertos para acceso a través del puerto 8080 en la máquina anfitriona, una red privada con una IP estática 192.168.55.1, y conexión a la red pública. Además, se ejecuta un script de aprovisionamiento provapache.sh para configurarla. La segunda máquina, AntonioZancadaMysql, se configura con un nombre de host, una red privada con la IP 192.168.55.2, y se ejecuta un script de aprovisionamiento provmysql.sh para instalar y configurar MySQL. En resumen, este Vagrantfile establece un entorno LAMP distribuido, separando las funciones del servidor web y la base de datos en máquinas virtuales distintas. 

![imagenVagrantfile](https://github.com/user-attachments/assets/5eb8d062-c53b-4fc7-9d63-119c81ffa68c)

### **Aprovisionamiento apache: provapache.sh**
Aquí se instala Apache, PHP, MySQL y Git en una máquina, clona un repositorio desde GitHub y mueve los archivos necesarios a un directorio específico. Luego, configura los permisos y ajusta la configuración de Apache para apuntar al nuevo directorio de la aplicación. Finalmente, recarga Apache para aplicar los cambios y crea un archivo de configuración PHP con los detalles de la conexión a la base de datos.

## Configuración del entorno LAMP
### Actualiza la lista de paquetes disponibles y sus versiones.
```bash
sudo apt-get update
````
### Instala Apache, PHP, los módulos de PHP para Apache, el soporte PHP para MySQL y Git, todo de una vez.
````bash
sudo apt-get install -y apache2 php libapache2-mod-php php-mysql git
````
### Instala herramientas de red, útiles para obtener información de la red.
````bash
sudo apt-get install net-tools
````
### Clona el repositorio iaw-practica-lamp desde GitHub en el directorio /var/www/lamp_app/.
````bash
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git /var/www/lamp_app/
````
### Mueve todos los archivos desde el subdirectorio src al directorio principal lamp_app.
````bash
sudo mv /var/www/lamp_app/src/* /var/www/lamp_app/
````
### Cambia el propietario y el grupo del directorio lamp_app y sus contenidos a www-data, el usuario y grupo utilizado por el servidor web Apache.
````bash
sudo chown -R www-data.www-data /var/www/lamp_app/
````
### Copia el archivo de configuración por defecto de Apache, 000-default.conf, a un nuevo archivo llamado practica.conf.
````bash
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/practica.conf
````
### Utiliza sed para modificar DocumentRoot en practica.conf, apuntando al directorio lamp_app.
````bash
sudo sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/lamp_app|' /etc/apache2/sites-available/practica.conf
````
### Habilita el nuevo sitio configurado en practica.conf.
````bash
cd /etc/apache2/sites-available/
sudo a2ensite practica.conf
````
### Deshabilita el sitio por defecto configurado en 000-default.conf.
````bash
cd /etc/apache2/sites-enabled/
sudo a2dissite 000-default.conf
````
### Recarga Apache para aplicar los cambios de configuración.
````bash
sudo systemctl reload apache2
````
### Crea un archivo de configuración PHP config.php con los detalles de la conexión a la base de datos y lo guarda en el directorio de la aplicación.
````bash 
cat <<EOL > /var/www/lamp_app/config.php
<?php
define('DB_HOST', '192.168.55.2');
define('DB_NAME', 'lamp_db');
define('DB_USER', 'antonio01');
define('DB_PASSWORD', '12345');

\$mysqli = mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
?>
EOL
````
### Recarga Apache para aplicar los cambios de configuración.
````bash
sudo systemctl reload apache2
````


