# **PracticaLAMP**
En este proyecto crearemos una configuración LAMP con dos máquinas: una para Apache y otra para MySQL. Cada una tendrá una IP estática en una red privada, y la máquina Apache también tendrá salida a Internet. El propósito es usar Vagrant para configurar y desplegar un entorno LAMP (Linux, Apache, MySQL, PHP) distribuido, simulando un entorno de producción mediante la separación del servidor web y la base de datos.

# **Vagrantfile**
Este bloque de código en Vagrant configura dos máquinas virtuales con Ubuntu. La primera máquina, AntonioZancadaApache, tiene un nombre de host definido, redireccionamiento de puertos para acceso a través del puerto 8080 en la máquina anfitriona, una red privada con una IP estática 192.168.55.1, y conexión a la red pública. Además, se ejecuta un script de aprovisionamiento provapache.sh para configurarla. La segunda máquina, AntonioZancadaMysql, se configura con un nombre de host, una red privada con la IP 192.168.55.2, y se ejecuta un script de aprovisionamiento provmysql.sh para instalar y configurar MySQL. En resumen, este Vagrantfile establece un entorno LAMP distribuido, separando las funciones del servidor web y la base de datos en máquinas virtuales distintas. 

![imagenVagrantfile](https://github.com/user-attachments/assets/5eb8d062-c53b-4fc7-9d63-119c81ffa68c)

# **Aprovisionamiento apache: provapache.sh**
Aquí se instala Apache, PHP, MySQL y Git en una máquina, clona un repositorio desde GitHub y mueve los archivos necesarios a un directorio específico. Luego, configura los permisos y ajusta la configuración de Apache para apuntar al nuevo directorio de la aplicación. Finalmente, recarga Apache para aplicar los cambios y crea un archivo de configuración PHP con los detalles de la conexión a la base de datos.
![imagen](https://github.com/user-attachments/assets/eef069a0-2af1-4efb-9905-2d947e97eb5a)

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
### Clona el repositorio iaw-practica-lamp desde GitHub en el directorio /var/www/actividadlap/.
````bash
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git /var/www/actividadlamp/
````
### Mueve todos los archivos desde el subdirectorio src al directorio principal actividadlamp.
````bash
sudo mv /var/www/actividadlamp/src/* /var/www/actividadlamp/
````
### Cambia el propietario y el grupo del directorio actividadlamp y sus contenidos a www-data, el usuario y grupo utilizado por el servidor web Apache.
````bash
sudo chown -R www-data.www-data /var/www/actividadlamp/
````
### Copia el archivo de configuración por defecto de Apache, 000-default.conf, a un nuevo archivo llamado actividadlamp.conf.
````bash
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/actividadlamp.conf
````
### Utiliza sed para modificar DocumentRoot en actividadlamp.conf, apuntando al directorio lamp_app.
````bash
sudo sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/lamp_app|' /etc/apache2/sites-available/actividadlamp.conf
````
### Habilita el nuevo sitio configurado en actividadlamp.conf.
````bash
cd /etc/apache2/sites-available/
sudo a2ensite actividadlamp.conf
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
cat <<EOL > /var/www/actividadlamp/config.php
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

# **Aprovisionamiento Mysql: provmysql.sh**
Este script actualiza la lista de paquetes e instala MySQL Server, Git y herramientas de red. Luego, inicia el servicio de MySQL, clona un repositorio desde GitHub e importa una base de datos. También crea un usuario en MySQL con permisos específicos, modifica la configuración de MySQL para permitir conexiones remotas, y reinicia el servicio para aplicar los cambios. Finalmente, ajusta la configuración de red eliminando la ruta predeterminada.
![imagen](https://github.com/user-attachments/assets/96593811-2d34-4785-8aec-ef3fba4a9fb1)

### Actualizar la lista de paquetes
````bash
sudo apt-get update
````
### Instalar MySQL Server y Git
````bash
sudo apt-get install -y mysql-server git
````
### Instalar herramientas de red
````bash
sudo apt-get install net-tools
````
### Iniciar el servicio de MySQL
````bash
sudo service mysql start
````
### Clonar el repositorio de la aplicación
````bash
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git
```` 
### Importar base de datos
````bash
sudo mysql -u root < iaw-practica-lamp/db/database.sql
````
### Crea un usuario llamado antonio01 con acceso desde 192.168.55.1 y la contraseña 12345, y otorga todos los privilegios en la base de datos lamp_db.
````bash
mysql -u root  <<EOF
USE lamp_db;
CREATE USER 'antonio01'@'192.168.55.1' IDENTIFIED BY '12345';
GRANT ALL PRIVILEGES ON lamp_db.* TO 'antonio01'@'192.168.55.1';
FLUSH PRIVILEGES;
EOF
````
### Modifica la configuración de MySQL para permitir conexiones remotas desde la IP 192.168.55.2
````bash
sudo sed -i 's/^bind-address\s*=.*/bind-address = 192.168.55.2/' /etc/mysql/mysql.conf.d/mysqld.cnf
````
### Reinicia el servicio de MySQL para aplicar los cambios de configuración.
````bash
sudo systemctl restart mysql
````
### Elimina la ruta predeterminada.
````bash
sudo ip route del default
````

# Funcionamiento Apache
La salida indica que el servicio Apache está activo y funcionando correctamente, mostrando detalles sobre el proceso principal, el tiempo que lleva en ejecución, y el uso de memoria y CPU.
![imagen](https://github.com/user-attachments/assets/53e9c16a-4813-46bc-be30-f44dcc8b163c)


# Funcionamiento MySQL
La salida indica que el servicio Apache está activo y funcionando correctamente, mostrando detalles sobre el proceso principal, el tiempo que lleva en ejecución, y el uso de memoria y CPU
![imagen](https://github.com/user-attachments/assets/3a3bb521-3766-4e26-96b6-2a51688d7da0)

# A continuación se puede observar el correcto funcionamiento de la estructura:
![imagen](https://github.com/user-attachments/assets/7cafa761-cf5b-4131-8b9d-3fa20a54cafd)






