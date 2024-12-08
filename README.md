### Guía de Compilación, Ejecución y Despliegue con Docker
## 1. Creación del compilado
Ejecuta el comando:

  `.\mvnw clean install`

Si el comando no funciona, asegúrate de que el archivo pom.xml incluye el siguiente plugin de Maven. Esto asegura que se genere un archivo JAR con la clase principal configurada en el manifiesto:

  ```
  <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-jar-plugin</artifactId>
      <version>3.1.0</version>
      <configuration>
          <archive>
              <manifest>
                  <mainClass>com.lilblue.demo.DemoApplication</mainClass>
              </manifest>
          </archive>
      </configuration>
  </plugin>
  ```

Una vez modificado, ejecuta el siguiente comando para crear el compilado:

  `.\mvnw package spring-boot:repackage`

## 2. Ejecución del compilado
Para ejecutar el archivo generado, utiliza el siguiente comando (sustituyendo el nombre del archivo JAR si es diferente):

  `java -jar ./target/demo-0.0.1-SNAPSHOT.jar`

## 3. Creación de la imagen Docker
Construye la imagen Docker utilizando el archivo Dockerfile existente en el proyecto:

  `docker image build . -f Dockerfile --tag api-test/web`

## 4. Ejecución de la imagen Docker
Inicia un contenedor basado en la imagen creada:

  `docker run -d --name my-api api-test/web`

## 5. Etiquetado de la imagen
Etiqueta la imagen para su publicación en un repositorio (sustituye sebasnavarro y myapp por tus valores):

  `docker tag api-test/web sebasnavarro/myapp:v1`

## 6. Publicación de la imagen
Publica la imagen en un registro remoto, como Docker Hub:

  `docker push sebasnavarro/myapp:v1`

***
## Descargar imagen desde un servidor de docker

## 1. Iniciamos sesion en docker

  `docker login`

## 2. Tirar la imagen desde Docker Hub

  `docker pull sebasnavarro/myapp:v1 `

## 3. Ejecutar el contenedor en el servidor

  `docker run -d -p 8080:8080 --name my-api sebasnavarro/myapp:v1 `

## 4. Verificamos si el contenedor esta corriendo

  `docker ps`

***
## Datos Adicionales

Eliminar contenedores existentes
Si deseas crear un nuevo contenedor con el mismo nombre, primero debes detener y eliminar el contenedor existente:

  `docker stop my-api`
  `docker rm my-api`

## 1. Asignar puertos al contenedor

Si el servicio no tiene un puerto asignado en el archivo Dockerfile o necesitas mapearlo manualmente, utiliza la opción -p para asignar el puerto. Por ejemplo:
bash

  `docker run -d -p 8080:8080 --name my-api api-test/web`

Esto mapea el puerto 8080 del host al puerto 8080 del contenedor.

## 2. Verificar contenedores en ejecución

Para verificar qué contenedores están activos:

`docker ps`



Para ver todos los contenedores (activos e inactivos):

`docker ps -a`

